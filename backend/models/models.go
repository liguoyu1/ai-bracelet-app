package models

import "time"

type User struct {
	ID              string    `json:"id"`
	Email           string    `json:"email"`
	PasswordHash    string    `json:"-"`
	DisplayName     string    `json:"display_name"`
	AvatarURL       string    `json:"avatar_url"`
	Bio             string    `json:"bio"`
	Role            string    `json:"role"`
	StripeAccountID string    `json:"stripe_account_id,omitempty"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

type Product struct {
	ID          string                 `json:"id"`
	Name        string                 `json:"name"`
	Slug        string                 `json:"slug"`
	Description string                 `json:"description"`
	PriceCents  int                    `json:"price_cents"`
	Images      []string               `json:"images"`
	Category    string                 `json:"category"`
	Tags        []string               `json:"tags"`
	Materials   string                 `json:"materials"`
	Stock       int                    `json:"stock"`
	IsActive    bool                   `json:"is_active"`
	SalesCount  int                    `json:"sales_count"`
	I18n        map[string]interface{} `json:"i18n,omitempty"`
	CreatedAt   time.Time              `json:"created_at"`
	UpdatedAt   time.Time              `json:"updated_at"`
}

type DesignElement struct {
	ID         string                 `json:"id"`
	Name       string                 `json:"name"`
	Type       string                 `json:"type"`
	Color      string                 `json:"color"`
	Material   string                 `json:"material"`
	Shape      string                 `json:"shape"`
	SizeMm     float64                `json:"size_mm"`
	ImageURL   string                 `json:"image_url"`
	PriceCents int                    `json:"price_cents"`
	Stock      int                    `json:"stock"`
	IsActive   bool                   `json:"is_active"`
	Metadata   string                 `json:"metadata,omitempty"`
	I18n       map[string]interface{} `json:"i18n,omitempty"`
	CreatedAt  time.Time              `json:"created_at"`
}

type UserDesign struct {
	ID                string    `json:"id"`
	UserID            string    `json:"user_id"`
	Name              string    `json:"name"`
	Description       string    `json:"description"`
	DesignData        string    `json:"design_data"`
	PreviewImages     []string  `json:"preview_images"`
	PriceCents        int       `json:"price_cents"`
	IsPublished       bool      `json:"is_published"`
	SalesCount        int       `json:"sales_count"`
	TotalEarningsCents int      `json:"total_earnings_cents"`
	CreatedAt         time.Time `json:"created_at"`
	UpdatedAt         time.Time `json:"updated_at"`
	// Joined
	DesignerName string `json:"designer_name,omitempty"`
	DesignerID   string `json:"designer_id,omitempty"`
}

type Order struct {
	ID                    string    `json:"id"`
	UserID                string    `json:"user_id"`
	StripePaymentIntentID string    `json:"stripe_payment_intent_id,omitempty"`
	TotalCents            int       `json:"total_cents"`
	Status                string    `json:"status"`
	ShippingAddress       string    `json:"shipping_address,omitempty"`
	ContactEmail          string    `json:"contact_email,omitempty"`
	Notes                 string    `json:"notes,omitempty"`
	CreatedAt             time.Time `json:"created_at"`
	UpdatedAt             time.Time `json:"updated_at"`
	Items                 []OrderItem `json:"items,omitempty"`
}

type OrderItem struct {
	ID                   string    `json:"id"`
	OrderID              string    `json:"order_id"`
	ItemType             string    `json:"item_type"`
	ItemID               string    `json:"item_id"`
	DesignSnapshot       string    `json:"design_snapshot,omitempty"`
	Quantity             int       `json:"quantity"`
	UnitPriceCents       int       `json:"unit_price_cents"`
	TotalCents           int       `json:"total_cents"`
	DesignerID           *string   `json:"designer_id,omitempty"`
	DesignerCommissionCents int   `json:"designer_commission_cents,omitempty"`
	CreatedAt            time.Time `json:"created_at"`
}

type Favorite struct {
	ID        string    `json:"id"`
	UserID    string    `json:"user_id"`
	ItemType  string    `json:"item_type"`
	ItemID    string    `json:"item_id"`
	CreatedAt time.Time `json:"created_at"`
}

type EnergyAssessment struct {
	ID                string    `json:"id"`
	UserID            string    `json:"user_id"`
	BirthDate         string    `json:"birth_date,omitempty"`
	ZodiacSign        string    `json:"zodiac_sign,omitempty"`
	ChineseZodiac     string    `json:"chinese_zodiac,omitempty"`
	FiveElements      string    `json:"five_elements,omitempty"`
	PersonalityTraits string    `json:"personality_traits,omitempty"`
	Preferences       string    `json:"preferences,omitempty"`
	RawInput          string    `json:"raw_input,omitempty"`
	AIResponse        string    `json:"ai_response,omitempty"`
	Recommendations   string    `json:"recommendations,omitempty"`
	CreatedAt         time.Time `json:"created_at"`
}

type DesignerEarning struct {
	ID            string     `json:"id"`
	DesignerID    string     `json:"designer_id"`
	OrderItemID   string     `json:"order_item_id"`
	AmountCents   int        `json:"amount_cents"`
	Status        string     `json:"status"`
	PaidAt        *time.Time `json:"paid_at,omitempty"`
	CreatedAt     time.Time  `json:"created_at"`
}
