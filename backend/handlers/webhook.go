package handlers

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"

	"github.com/jackc/pgx/v5/pgxpool"

	"bracelet/services"
)

type WebhookHandler struct {
	Pool            *pgxpool.Pool
	AirwallexClient *services.AirwallexClient
}

func (h *WebhookHandler) HandleAirwallex(w http.ResponseWriter, r *http.Request) {
	body, err := io.ReadAll(r.Body)
	if err != nil {
		fail(w, 400, "failed to read body")
		return
	}
	defer r.Body.Close()

	// Parse Airwallex webhook event
	var event struct {
		EventType string `json:"event_type"`
		ID        string `json:"id"`
		Data      struct {
			Object struct {
				ID              string `json:"id"`
				Status          string `json:"status"`
				Amount          int    `json:"amount"`
				Currency        string `json:"currency"`
				MerchantOrderID string `json:"merchant_order_id"`
			} `json:"object"`
		} `json:"data"`
	}
	if err := json.Unmarshal(body, &event); err != nil {
		fail(w, 400, "invalid webhook payload")
		return
	}

	switch event.EventType {
	case "payment_intent.succeeded":
		orderID := event.Data.Object.MerchantOrderID
		if orderID == "" {
			fmt.Println("Airwallex webhook: no merchant_order_id")
			break
		}

		// Update order to paid
		tag, err := h.Pool.Exec(r.Context(),
			`UPDATE orders SET status='paid', updated_at=NOW() WHERE id=$1 AND status='pending'`,
			orderID)
		if err != nil {
			fmt.Printf("Airwallex webhook: failed to update order %s: %v\n", orderID, err)
			break
		}
		if tag.RowsAffected() == 0 {
			fmt.Printf("Airwallex webhook: order %s not found or already paid\n", orderID)
			break
		}

		// Distribute designer commissions (2%)
		h.distributeCommissions(r, orderID)

		fmt.Printf("Airwallex webhook: order %s paid successfully\n", orderID)

	case "payment_intent.failed":
		orderID := event.Data.Object.MerchantOrderID
		if orderID != "" {
			h.Pool.Exec(r.Context(),
				`UPDATE orders SET status='cancelled', updated_at=NOW() WHERE id=$1 AND status='pending'`,
				orderID)
			fmt.Printf("Airwallex webhook: order %s payment failed\n", orderID)
		}
	}

	w.WriteHeader(http.StatusOK)
	w.Write([]byte(`{"received":true}`))
}

func (h *WebhookHandler) distributeCommissions(r *http.Request, orderID string) {
	// Get order items with designer commissions
	rows, err := h.Pool.Query(r.Context(), `
		SELECT oi.id, oi.designer_id, oi.designer_commission_cents
		FROM order_items oi
		WHERE oi.order_id = $1 AND oi.designer_id IS NOT NULL AND oi.designer_commission_cents > 0`,
		orderID)
	if err != nil {
		fmt.Printf("Webhook: failed to query commissions for order %s: %v\n", orderID, err)
		return
	}
	defer rows.Close()

	for rows.Next() {
		var itemID string
		var designerID string
		var commissionCents int
		if err := rows.Scan(&itemID, &designerID, &commissionCents); err != nil {
			continue
		}

		// Create earnings record
		_, err := h.Pool.Exec(r.Context(),
			`INSERT INTO designer_earnings (designer_id, order_item_id, amount_cents, status)
			 VALUES ($1, $2, $3, 'pending')`,
			designerID, itemID, commissionCents)
		if err != nil {
			fmt.Printf("Webhook: failed to create earning for designer %s: %v\n", designerID, err)
		}

		// Update designer total earnings
		h.Pool.Exec(r.Context(),
			`UPDATE user_designs SET total_earnings_cents = total_earnings_cents + $1
			 WHERE user_id = $2 AND id IN (
			     SELECT item_id FROM order_items WHERE id = $3
			 )`,
			commissionCents, designerID, itemID)

		fmt.Printf("Webhook: commission of %d cents credited to designer %s\n", commissionCents, designerID)
	}
}
