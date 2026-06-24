package services

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"time"
)

type AirwallexClient struct {
	ClientID    string
	APIKey      string
	BaseURL     string
	ReturnURL   string
	WebhookKey  string
	token       string
	tokenExpiry time.Time
}

type CheckoutSessionResponse struct {
	ID  string `json:"id"`
	URL string `json:"url"`
}

type awxAuthResp struct {
	Token string `json:"token"`
}

type awxPaymentIntentReq struct {
	RequestID       string `json:"request_id"`
	Amount          int    `json:"amount"`
	Currency        string `json:"currency"`
	MerchantOrderID string `json:"merchant_order_id"`
	ReturnURL       string `json:"return_url"`
	CancelURL       string `json:"cancel_url"`
	Descriptor      string `json:"descriptor"`
}

type awxPaymentIntentResp struct {
	ID         string `json:"id"`
	Status     string `json:"status"`
	ClientSeed string `json:"client_secret"`
	HostedPage *struct {
		URL string `json:"url"`
	} `json:"hosted_page"`
}

func NewAirwallexClient(clientID, apiKey string) *AirwallexClient {
	return &AirwallexClient{
		ClientID:   clientID,
		APIKey:     apiKey,
		BaseURL:    "https://api.airwallex.com/v1",
		ReturnURL:  "https://bracelet-app.com/order/success",
		WebhookKey: "",
	}
}

func (c *AirwallexClient) authenticate() error {
	// Check if token is still valid
	if c.token != "" && time.Now().Before(c.tokenExpiry) {
		return nil
	}

	body := fmt.Sprintf(`{"client_id":"%s","api_key":"%s"}`, c.ClientID, c.APIKey)
	req, err := http.NewRequest("POST", c.BaseURL+"/authentication/login", bytes.NewBufferString(body))
	if err != nil {
		return fmt.Errorf("auth request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return fmt.Errorf("auth call: %w", err)
	}
	defer resp.Body.Close()

	respBody, _ := io.ReadAll(resp.Body)
	if resp.StatusCode != 200 {
		return fmt.Errorf("airwallex auth failed %d: %s", resp.StatusCode, string(respBody))
	}

	var auth awxAuthResp
	if err := json.Unmarshal(respBody, &auth); err != nil {
		return fmt.Errorf("auth parse: %w", err)
	}
	if auth.Token == "" {
		return fmt.Errorf("empty auth token")
	}

	c.token = auth.Token
	c.tokenExpiry = time.Now().Add(55 * time.Minute) // tokens last ~1h
	return nil
}

// CreateCheckoutSession creates payment intent and returns hosted page URL
func (c *AirwallexClient) CreateCheckoutSession(amountCents int, currency string, orderID string, metadata map[string]string) (*CheckoutSessionResponse, error) {
	if err := c.authenticate(); err != nil {
		return nil, fmt.Errorf("auth: %w", err)
	}

	reqBody := awxPaymentIntentReq{
		RequestID:       orderID,
		Amount:          amountCents,
		Currency:        currency,
		MerchantOrderID: orderID,
		ReturnURL:       c.ReturnURL + "/" + orderID,
		CancelURL:       c.ReturnURL + "?canceled=1",
		Descriptor:      "Bracelet Order",
	}

	b, _ := json.Marshal(reqBody)
	req, err := http.NewRequest("POST", c.BaseURL+"/pa/payment_intents/create", bytes.NewBuffer(b))
	if err != nil {
		return nil, fmt.Errorf("create request: %w", err)
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+c.token)

	client := &http.Client{Timeout: 15 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return nil, fmt.Errorf("airwallex request: %w", err)
	}
	defer resp.Body.Close()

	respBody, _ := io.ReadAll(resp.Body)
	if resp.StatusCode < 200 || resp.StatusCode > 299 {
		return nil, fmt.Errorf("airwallex error %d: %s", resp.StatusCode, string(respBody))
	}

	var pi awxPaymentIntentResp
	if err := json.Unmarshal(respBody, &pi); err != nil {
		return nil, fmt.Errorf("parse response: %w", err)
	}

	checkoutURL := ""
	if pi.HostedPage != nil && pi.HostedPage.URL != "" {
		checkoutURL = pi.HostedPage.URL
	} else {
		// Fallback: construct HPP URL
		checkoutURL = fmt.Sprintf("https://hpp.airwallex.com/payment/checkout/%s?client_secret=%s", pi.ID, pi.ClientSeed)
	}

	return &CheckoutSessionResponse{
		ID:  pi.ID,
		URL: checkoutURL,
	}, nil
}
