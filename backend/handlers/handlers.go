package handlers

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"

	"github.com/jackc/pgx/v5/pgxpool"
	"golang.org/x/crypto/bcrypt"

	"bracelet/middleware"
	"bracelet/models"
	"bracelet/services"
)

func extractID(r *http.Request) string {
	parts := strings.Split(strings.TrimRight(r.URL.Path, "/"), "/")
	if len(parts) > 0 {
		return parts[len(parts)-1]
	}
	return ""
}

type AuthHandler struct {
	Pool      *pgxpool.Pool
	JWTSecret string
}

func (h *AuthHandler) Register(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Email    string `json:"email"`
		Password string `json:"password"`
		Name     string `json:"display_name"`
	}
	if err := decode(r, &req); err != nil {
		fail(w, 400, "invalid request body")
		return
	}
	req.Email = strings.TrimSpace(strings.ToLower(req.Email))
	if req.Email == "" || req.Password == "" {
		fail(w, 400, "email and password required")
		return
	}
	if len(req.Password) < 6 {
		fail(w, 400, "password must be at least 6 characters")
		return
	}
	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		fail(w, 500, "failed to hash password")
		return
	}
	var user models.User
	err = h.Pool.QueryRow(r.Context(),
		`INSERT INTO users (email, password_hash, display_name) VALUES ($1,$2,$3)
		 RETURNING id, email, display_name, avatar_url, role, created_at`,
		req.Email, string(hash), req.Name,
	).Scan(&user.ID, &user.Email, &user.DisplayName, &user.AvatarURL, &user.Role, &user.CreatedAt)
	if err != nil {
		if strings.Contains(err.Error(), "duplicate key") {
			fail(w, 409, "email already registered")
			return
		}
		fail(w, 500, "failed to create user")
		return
	}
	token, err := middleware.GenerateToken(user.ID, user.Role, h.JWTSecret)
	if err != nil {
		fail(w, 500, "failed to generate token")
		return
	}
	created(w, map[string]interface{}{"user": user, "token": token})
}

func (h *AuthHandler) Login(w http.ResponseWriter, r *http.Request) {
	var req struct {
		Email    string `json:"email"`
		Password string `json:"password"`
	}
	if err := decode(r, &req); err != nil {
		fail(w, 400, "invalid request body")
		return
	}
	req.Email = strings.TrimSpace(strings.ToLower(req.Email))
	var user models.User
	err := h.Pool.QueryRow(r.Context(),
		`SELECT id, email, password_hash, display_name, avatar_url, role, created_at FROM users WHERE email=$1`,
		req.Email,
	).Scan(&user.ID, &user.Email, &user.PasswordHash, &user.DisplayName, &user.AvatarURL, &user.Role, &user.CreatedAt)
	if err != nil {
		fail(w, 401, "invalid email or password")
		return
	}
	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password)); err != nil {
		fail(w, 401, "invalid email or password")
		return
	}
	token, err := middleware.GenerateToken(user.ID, user.Role, h.JWTSecret)
	if err != nil {
		fail(w, 500, "failed to generate token")
		return
	}
	success(w, map[string]interface{}{"user": user, "token": token})
}

func (h *AuthHandler) Me(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	var user models.User
	err := h.Pool.QueryRow(r.Context(),
		`SELECT id, email, password_hash, display_name, avatar_url, bio, role, stripe_account_id, created_at, updated_at FROM users WHERE id=$1`,
		userID,
	).Scan(&user.ID, &user.Email, &user.PasswordHash, &user.DisplayName, &user.AvatarURL, &user.Bio, &user.Role, &user.StripeAccountID, &user.CreatedAt, &user.UpdatedAt)
	if err != nil {
		fail(w, 404, "user not found")
		return
	}
	success(w, user)
}

func (h *AuthHandler) UpdateProfile(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	var req struct {
		DisplayName string `json:"display_name"`
		Bio         string `json:"bio"`
		AvatarURL   string `json:"avatar_url"`
	}
	if err := decode(r, &req); err != nil {
		fail(w, 400, "invalid request")
		return
	}
	_, err := h.Pool.Exec(r.Context(),
		`UPDATE users SET display_name=$1, bio=$2, avatar_url=$3, updated_at=NOW() WHERE id=$4`,
		req.DisplayName, req.Bio, req.AvatarURL, userID)
	if err != nil {
		fail(w, 500, "failed to update profile")
		return
	}
	success(w, map[string]string{"message": "profile updated"})
}

type ProductHandler struct {
	Pool *pgxpool.Pool
}

func (h *ProductHandler) List(w http.ResponseWriter, r *http.Request) {
	category := queryParam(r, "category", "")
	q := queryParam(r, "q", "")
	search := queryParam(r, "search", "")
	page := queryParam(r, "page", "1")
	limit := queryParam(r, "limit", "20")
	offset := (parseInt(page, 1) - 1) * parseInt(limit, 20)
	where := "WHERE p.is_active = true"
	args := []interface{}{}
	argIdx := 1
	if category != "" {
		where += fmt.Sprintf(" AND p.category = $%d", argIdx)
		args = append(args, category)
		argIdx++
	}
	searchTerm := q
	if searchTerm == "" {
		searchTerm = search
	}
	if searchTerm != "" {
		where += fmt.Sprintf(" AND (p.name ILIKE $%d OR p.tags::text ILIKE $%d OR p.description ILIKE $%d)", argIdx, argIdx, argIdx)
		args = append(args, "%"+searchTerm+"%")
		argIdx++
	}
	var total int
	h.Pool.QueryRow(r.Context(), fmt.Sprintf("SELECT COUNT(*) FROM products p %s", where), args...).Scan(&total)
	query := fmt.Sprintf(`SELECT p.id, p.name, p.slug, p.description, p.price_cents, p.images, p.category, p.tags, p.materials, p.stock, p.sales_count, p.created_at, p.updated_at, p.i18n FROM products p %s ORDER BY p.sales_count DESC, p.created_at DESC LIMIT $%d OFFSET $%d`, where, argIdx, argIdx+1)
	args = append(args, parseInt(limit, 20), offset)
	rows, err := h.Pool.Query(r.Context(), query, args...)
	if err != nil {
		fail(w, 500, "failed to query products: "+err.Error())
		return
	}
	defer rows.Close()
	products := []models.Product{}
	for rows.Next() {
		var p models.Product
		var i18nVal interface{}
		if err := rows.Scan(&p.ID, &p.Name, &p.Slug, &p.Description, &p.PriceCents, &p.Images, &p.Category, &p.Tags, &p.Materials, &p.Stock, &p.SalesCount, &p.CreatedAt, &p.UpdatedAt, &i18nVal); err != nil {
			continue
		}
		if m, ok := i18nVal.(map[string]interface{}); ok && len(m) > 0 {
			p.I18n = m
		}
		if p.Images == nil {
			p.Images = []string{}
		}
		if p.Tags == nil {
			p.Tags = []string{}
		}
		products = append(products, p)
	}
	if products == nil {
		products = []models.Product{}
	}
	lang := queryParam(r, "lang", "")
	if lang != "" && lang != "en" {
		localized := make([]map[string]interface{}, 0, len(products))
		for _, p := range products {
			m := structToMap(p)
			localize(m, lang)
			localized = append(localized, m)
		}
		writeJSON(w, 200, apiResponse{Success: true, Data: localized, Total: total})
		return
	}
	writeJSON(w, 200, apiResponse{Success: true, Data: products, Total: total})
}

func (h *ProductHandler) Get(w http.ResponseWriter, r *http.Request) {
	id := extractID(r)
	var p models.Product
	var i18nVal interface{}
	err := h.Pool.QueryRow(r.Context(),
	`SELECT id, name, slug, description, price_cents, images, category, tags, materials, stock, sales_count, created_at, updated_at, i18n
		 FROM products WHERE (id=$1::uuid OR slug=$1)`, id,
	).Scan(&p.ID, &p.Name, &p.Slug, &p.Description, &p.PriceCents, &p.Images, &p.Category, &p.Tags, &p.Materials, &p.Stock, &p.SalesCount, &p.CreatedAt, &p.UpdatedAt, &i18nVal)
	if err != nil {
		fail(w, 404, "product not found: "+err.Error())
		return
	}
	if m, ok := i18nVal.(map[string]interface{}); ok && len(m) > 0 {
		p.I18n = m
	}
	if p.Images == nil {
		p.Images = []string{}
	}
	if p.Tags == nil {
		p.Tags = []string{}
	}
	lang := queryParam(r, "lang", "")
	if lang != "" && lang != "en" {
		m := structToMap(p)
		localize(m, lang)
		success(w, m)
		return
	}
	success(w, p)
}

func (h *ProductHandler) Create(w http.ResponseWriter, r *http.Request) {
	var p models.Product
	if err := decode(r, &p); err != nil {
		fail(w, 400, "invalid request")
		return
	}
	images, _ := json.Marshal(p.Images)
	tags, _ := json.Marshal(p.Tags)
	err := h.Pool.QueryRow(r.Context(),
		`INSERT INTO products (name, slug, description, price_cents, images, category, tags, materials, stock)
		 VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING id, created_at, updated_at`,
		p.Name, p.Slug, p.Description, p.PriceCents, images, p.Category, tags, p.Materials, p.Stock,
	).Scan(&p.ID, &p.CreatedAt, &p.UpdatedAt)
	if err != nil {
		fail(w, 500, "failed to create product: "+err.Error())
		return
	}
	created(w, p)
}

func (h *ProductHandler) Update(w http.ResponseWriter, r *http.Request) {
	id := extractID(r)
	var req struct {
		Name        string   `json:"name"`
		Description string   `json:"description"`
		PriceCents  int      `json:"price_cents"`
		Images      []string `json:"images"`
		Category    string   `json:"category"`
		Tags        []string `json:"tags"`
		Materials   string   `json:"materials"`
		Stock       int      `json:"stock"`
		IsActive    *bool    `json:"is_active"`
	}
	if err := decode(r, &req); err != nil {
		fail(w, 400, "invalid request")
		return
	}
	images, _ := json.Marshal(req.Images)
	tags, _ := json.Marshal(req.Tags)
	_, err := h.Pool.Exec(r.Context(),
		`UPDATE products SET name=$1, description=$2, price_cents=$3, images=$4, category=$5, tags=$6, materials=$7, stock=$8, updated_at=NOW() WHERE id=$9`,
		req.Name, req.Description, req.PriceCents, images, req.Category, tags, req.Materials, req.Stock, id)
	if err != nil {
		fail(w, 500, "failed to update product")
		return
	}
	if req.IsActive != nil {
		h.Pool.Exec(r.Context(), `UPDATE products SET is_active=$1 WHERE id=$2`, *req.IsActive, id)
	}
	success(w, map[string]string{"message": "product updated"})
}

type DesignElementHandler struct {
	Pool *pgxpool.Pool
}

func (h *DesignElementHandler) List(w http.ResponseWriter, r *http.Request) {
	typ := queryParam(r, "type", "")
	where := "WHERE is_active = true"
	args := []interface{}{}
	if typ != "" {
		where += " AND type = $1"
		args = append(args, typ)
	}
	rows, err := h.Pool.Query(r.Context(),
		`SELECT id, name, type, color, material, shape, size_mm, image_url, price_cents, stock, is_active, created_at FROM design_elements `+where+` ORDER BY type, name`, args...)
	if err != nil {
		fail(w, 500, "failed to query elements: "+err.Error())
		return
	}
	defer rows.Close()
	elements := []models.DesignElement{}
	for rows.Next() {
		var e models.DesignElement
		if err := rows.Scan(&e.ID, &e.Name, &e.Type, &e.Color, &e.Material, &e.Shape, &e.SizeMm, &e.ImageURL, &e.PriceCents, &e.Stock, &e.IsActive, &e.CreatedAt); err != nil {
			continue
		}
		elements = append(elements, e)
	}
	if elements == nil {
		elements = []models.DesignElement{}
	}
	success(w, elements)
}

func (h *DesignElementHandler) Create(w http.ResponseWriter, r *http.Request) {
	var e models.DesignElement
	if err := decode(r, &e); err != nil {
		fail(w, 400, "invalid request")
		return
	}
	err := h.Pool.QueryRow(r.Context(),
		`INSERT INTO design_elements (name, type, color, material, shape, size_mm, image_url, price_cents, stock) VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9) RETURNING id, created_at`,
		e.Name, e.Type, e.Color, e.Material, e.Shape, e.SizeMm, e.ImageURL, e.PriceCents, e.Stock,
	).Scan(&e.ID, &e.CreatedAt)
	if err != nil {
		fail(w, 500, "failed to create element: "+err.Error())
		return
	}
	created(w, e)
}

type DesignHandler struct {
	Pool *pgxpool.Pool
}

func (h *DesignHandler) List(w http.ResponseWriter, r *http.Request) {
	rows, err := h.Pool.Query(r.Context(), `SELECT d.id, d.user_id, d.name, d.description, d.design_data, d.preview_images, d.price_cents, d.sales_count, d.created_at, d.updated_at, u.display_name FROM user_designs d JOIN users u ON u.id = d.user_id WHERE d.is_published = true ORDER BY d.sales_count DESC, d.created_at DESC`)
	if err != nil {
		fail(w, 500, "failed to query designs: "+err.Error())
		return
	}
	defer rows.Close()
	designs := []models.UserDesign{}
	for rows.Next() {
		var d models.UserDesign
		if err := rows.Scan(&d.ID, &d.UserID, &d.Name, &d.Description, &d.DesignData, &d.PreviewImages, &d.PriceCents, &d.SalesCount, &d.CreatedAt, &d.UpdatedAt, &d.DesignerName); err != nil {
			continue
		}
		if d.PreviewImages == nil {
			d.PreviewImages = []string{}
		}
		designs = append(designs, d)
	}
	if designs == nil {
		designs = []models.UserDesign{}
	}
	success(w, designs)
}

func (h *DesignHandler) Get(w http.ResponseWriter, r *http.Request) {
	id := extractID(r)
	var d models.UserDesign
	err := h.Pool.QueryRow(r.Context(), `SELECT d.id, d.user_id, d.name, d.description, d.design_data, d.preview_images, d.price_cents, d.is_published, d.sales_count, d.total_earnings_cents, d.created_at, d.updated_at, u.display_name FROM user_designs d JOIN users u ON u.id = d.user_id WHERE d.id = $1`, id,
	).Scan(&d.ID, &d.UserID, &d.Name, &d.Description, &d.DesignData, &d.PreviewImages, &d.PriceCents, &d.IsPublished, &d.SalesCount, &d.TotalEarningsCents, &d.CreatedAt, &d.UpdatedAt, &d.DesignerName)
	if err != nil {
		fail(w, 404, "design not found")
		return
	}
	if d.PreviewImages == nil {
		d.PreviewImages = []string{}
	}
	success(w, d)
}

func (h *DesignHandler) Create(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	var req struct {
		Name        string `json:"name"`
		Description string `json:"description"`
		DesignData  string `json:"design_data"`
		PriceCents  int    `json:"price_cents"`
	}
	if err := decode(r, &req); err != nil {
		fail(w, 400, "invalid request")
		return
	}
	var d models.UserDesign
	err := h.Pool.QueryRow(r.Context(),
		`INSERT INTO user_designs (user_id, name, description, design_data, price_cents) VALUES ($1,$2,$3,$4,$5) RETURNING id, created_at, updated_at`,
		userID, req.Name, req.Description, req.DesignData, req.PriceCents,
	).Scan(&d.ID, &d.CreatedAt, &d.UpdatedAt)
	if err != nil {
		fail(w, 500, "failed to create design: "+err.Error())
		return
	}
	d.UserID = userID
	d.Name = req.Name
	d.Description = req.Description
	d.PriceCents = req.PriceCents
	created(w, d)
}

func (h *DesignHandler) Update(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	id := extractID(r)
	var existing models.UserDesign
	err := h.Pool.QueryRow(r.Context(), `SELECT user_id FROM user_designs WHERE id=$1`, id).Scan(&existing.UserID)
	if err != nil {
		fail(w, 404, "design not found")
		return
	}
	if existing.UserID != userID && middleware.GetUserRole(r) != "admin" {
		fail(w, 403, "not your design")
		return
	}
	var req struct {
		Name        string `json:"name"`
		Description string `json:"description"`
		DesignData  string `json:"design_data"`
		PriceCents  int    `json:"price_cents"`
	}
	if err := decode(r, &req); err != nil {
		fail(w, 400, "invalid request")
		return
	}
	_, err = h.Pool.Exec(r.Context(), `UPDATE user_designs SET name=$1, description=$2, design_data=$3, price_cents=$4, updated_at=NOW() WHERE id=$5`,
		req.Name, req.Description, req.DesignData, req.PriceCents, id)
	if err != nil {
		fail(w, 500, "failed to update design")
		return
	}
	success(w, map[string]string{"message": "design updated"})
}

func (h *DesignHandler) Publish(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	id := extractID(r)
	var existing struct {
		UserID     string
		PriceCents int
	}
	err := h.Pool.QueryRow(r.Context(), `SELECT user_id, price_cents FROM user_designs WHERE id=$1`, id).Scan(&existing.UserID, &existing.PriceCents)
	if err != nil {
		fail(w, 404, "design not found")
		return
	}
	if existing.UserID != userID {
		fail(w, 403, "not your design")
		return
	}
	if existing.PriceCents <= 0 {
		fail(w, 400, "set a price before publishing")
		return
	}
	_, err = h.Pool.Exec(r.Context(), `UPDATE user_designs SET is_published=true, updated_at=NOW() WHERE id=$1`, id)
	if err != nil {
		fail(w, 500, "failed to publish design")
		return
	}
	success(w, map[string]string{"message": "design published"})
}

func (h *DesignHandler) MyDesigns(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	rows, err := h.Pool.Query(r.Context(), `SELECT id, name, description, design_data, preview_images, price_cents, is_published, sales_count, total_earnings_cents, created_at, updated_at FROM user_designs WHERE user_id=$1 ORDER BY created_at DESC`, userID)
	if err != nil {
		fail(w, 500, "failed to query designs: "+err.Error())
		return
	}
	defer rows.Close()
	designs := []models.UserDesign{}
	for rows.Next() {
		var d models.UserDesign
		if err := rows.Scan(&d.ID, &d.Name, &d.Description, &d.DesignData, &d.PreviewImages, &d.PriceCents, &d.IsPublished, &d.SalesCount, &d.TotalEarningsCents, &d.CreatedAt, &d.UpdatedAt); err != nil {
			continue
		}
		if d.PreviewImages == nil {
			d.PreviewImages = []string{}
		}
		designs = append(designs, d)
	}
	if designs == nil {
		designs = []models.UserDesign{}
	}
	success(w, designs)
}

type OrderHandler struct {
	Pool            *pgxpool.Pool
	StripeKey       string
	AirwallexClient *services.AirwallexClient
}

func (h *OrderHandler) Create(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	var req struct {
		Items           []struct {
			ItemType string `json:"item_type"`
			ItemID   string `json:"item_id"`
			Quantity int    `json:"quantity"`
		} `json:"items"`
		ShippingAddress map[string]interface{} `json:"shipping_address"`
		ContactEmail    string                 `json:"contact_email"`
	}
	if err := decode(r, &req); err != nil || len(req.Items) == 0 {
		fail(w, 400, "invalid order request")
		return
	}
	tx, err := h.Pool.Begin(r.Context())
	if err != nil {
		fail(w, 500, "failed to begin transaction")
		return
	}
	defer tx.Rollback(r.Context())
	var totalCents int
	var orderItems []models.OrderItem
	for _, item := range req.Items {
		var unitPrice int
		var designerID *string
		switch item.ItemType {
		case "product":
			err := tx.QueryRow(r.Context(), `SELECT price_cents FROM products WHERE id=$1 AND is_active=true FOR UPDATE`, item.ItemID).Scan(&unitPrice)
			if err != nil {
				fail(w, 400, "product not found or inactive: "+item.ItemID)
				return
			}
		case "design":
			err := tx.QueryRow(r.Context(), `SELECT price_cents, user_id FROM user_designs WHERE id=$1 AND is_published=true FOR UPDATE`, item.ItemID).Scan(&unitPrice, &designerID)
			if err != nil {
				fail(w, 400, "design not found or not published: "+item.ItemID)
				return
			}
		default:
			fail(w, 400, "invalid item type")
			return
		}
		subtotal := unitPrice * item.Quantity
		totalCents += subtotal
		var commission int
		if designerID != nil && *designerID != userID {
			commission = subtotal * 2 / 100
		}
		orderItems = append(orderItems, models.OrderItem{
			ItemType: item.ItemType, ItemID: item.ItemID, Quantity: item.Quantity,
			UnitPriceCents: unitPrice, TotalCents: subtotal,
			DesignerID: designerID, DesignerCommissionCents: commission,
		})
	}
	shipAddr, _ := json.Marshal(req.ShippingAddress)
	var orderID string
	err = tx.QueryRow(r.Context(),
		`INSERT INTO orders (user_id, total_cents, shipping_address, contact_email, status) VALUES ($1,$2,$3,$4,'pending') RETURNING id`,
		userID, totalCents, shipAddr, req.ContactEmail,
	).Scan(&orderID)
	if err != nil {
		fail(w, 500, "failed to create order: "+err.Error())
		return
	}
	for _, oi := range orderItems {
		_, err = tx.Exec(r.Context(),
			`INSERT INTO order_items (order_id, item_type, item_id, quantity, unit_price_cents, total_cents, designer_id, designer_commission_cents) VALUES ($1,$2,$3,$4,$5,$6,$7,$8)`,
			orderID, oi.ItemType, oi.ItemID, oi.Quantity, oi.UnitPriceCents, oi.TotalCents, oi.DesignerID, oi.DesignerCommissionCents)
		if err != nil {
			fail(w, 500, "failed to create order items: "+err.Error())
			return
		}
		switch oi.ItemType {
		case "product":
			tx.Exec(r.Context(), `UPDATE products SET sales_count = sales_count + $1 WHERE id=$2`, oi.Quantity, oi.ItemID)
		case "design":
			tx.Exec(r.Context(), `UPDATE user_designs SET sales_count = sales_count + $1 WHERE id=$2`, oi.Quantity, oi.ItemID)
		}
	}
	if err := tx.Commit(r.Context()); err != nil {
		fail(w, 500, "failed to commit order: "+err.Error())
		return
	}
	success(w, map[string]interface{}{"order_id": orderID, "total_cents": totalCents})
}

func (h *OrderHandler) List(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	role := middleware.GetUserRole(r)
	var rows_query string
	var args []interface{}
	if role == "admin" {
		rows_query = `SELECT id, user_id, total_cents, status, shipping_address, contact_email, created_at FROM orders ORDER BY created_at DESC LIMIT 50`
	} else {
		rows_query = `SELECT id, user_id, total_cents, status, shipping_address, contact_email, created_at FROM orders WHERE user_id=$1 ORDER BY created_at DESC LIMIT 50`
		args = append(args, userID)
	}
	rows, err := h.Pool.Query(r.Context(), rows_query, args...)
	if err != nil {
		fail(w, 500, "failed to query orders: "+err.Error())
		return
	}
	defer rows.Close()
	orders := []models.Order{}
	for rows.Next() {
		var o models.Order
		if err := rows.Scan(&o.ID, &o.UserID, &o.TotalCents, &o.Status, &o.ShippingAddress, &o.ContactEmail, &o.CreatedAt); err != nil {
			continue
		}
		orders = append(orders, o)
	}
	if orders == nil {
		orders = []models.Order{}
	}
	success(w, orders)
}

func (h *OrderHandler) Get(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	role := middleware.GetUserRole(r)
	id := extractID(r)
	var o models.Order
	err := h.Pool.QueryRow(r.Context(),
		`SELECT id, user_id, total_cents, status, shipping_address, contact_email, notes, created_at, updated_at FROM orders WHERE id=$1`, id,
	).Scan(&o.ID, &o.UserID, &o.TotalCents, &o.Status, &o.ShippingAddress, &o.ContactEmail, &o.Notes, &o.CreatedAt, &o.UpdatedAt)
	if err != nil {
		fail(w, 404, "order not found")
		return
	}
	if o.UserID != userID && role != "admin" {
		fail(w, 403, "not your order")
		return
	}
	success(w, o)
}

func (h *OrderHandler) CreatePaymentIntent(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	id := extractID(r)
	var totalCents int
	var status string
	err := h.Pool.QueryRow(r.Context(), `SELECT total_cents, status FROM orders WHERE id=$1 AND user_id=$2`, id, userID).Scan(&totalCents, &status)
	if err != nil {
		fail(w, 404, "order not found")
		return
	}
	if status != "pending" {
		fail(w, 400, "order already paid or cancelled")
		return
	}
	checkout, err := h.AirwallexClient.CreateCheckoutSession(totalCents, "usd", id, nil)
	if err != nil {
		fail(w, 500, "failed to create payment: "+err.Error())
		return
	}
	_, _ = h.Pool.Exec(r.Context(), `UPDATE orders SET stripe_payment_intent_id=$1 WHERE id=$2`, checkout.ID, id)
	success(w, map[string]interface{}{"checkout_url": checkout.URL, "amount": totalCents, "payment_id": checkout.ID})
}

func (h *OrderHandler) UpdateStatus(w http.ResponseWriter, r *http.Request) {
	if middleware.GetUserRole(r) != "admin" {
		fail(w, 403, "admin only")
		return
	}
	id := extractID(r)
	var req struct {
		Status string `json:"status"`
	}
	if err := decode(r, &req); err != nil {
		fail(w, 400, "invalid request")
		return
	}
	_, err := h.Pool.Exec(r.Context(), `UPDATE orders SET status=$1, updated_at=NOW() WHERE id=$2`, req.Status, id)
	if err != nil {
		fail(w, 500, "failed to update order status: "+err.Error())
		return
	}
	success(w, map[string]string{"message": "order status updated"})
}

type FavoriteHandler struct {
	Pool *pgxpool.Pool
}

func (h *FavoriteHandler) List(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	rows, err := h.Pool.Query(r.Context(), `SELECT id, item_type, item_id, created_at FROM favorites WHERE user_id=$1 ORDER BY created_at DESC`, userID)
	if err != nil {
		fail(w, 500, "failed to query favorites: "+err.Error())
		return
	}
	defer rows.Close()
	favs := []models.Favorite{}
	for rows.Next() {
		var f models.Favorite
		if err := rows.Scan(&f.ID, &f.ItemType, &f.ItemID, &f.CreatedAt); err != nil {
			continue
		}
		favs = append(favs, f)
	}
	if favs == nil {
		favs = []models.Favorite{}
	}
	success(w, favs)
}

func (h *FavoriteHandler) Toggle(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	var req struct {
		ItemType string `json:"item_type"`
		ItemID   string `json:"item_id"`
	}
	if err := decode(r, &req); err != nil {
		fail(w, 400, "invalid request")
		return
	}
	var exists bool
	h.Pool.QueryRow(r.Context(), `SELECT EXISTS(SELECT 1 FROM favorites WHERE user_id=$1 AND item_type=$2 AND item_id=$3)`, userID, req.ItemType, req.ItemID).Scan(&exists)
	if exists {
		h.Pool.Exec(r.Context(), `DELETE FROM favorites WHERE user_id=$1 AND item_type=$2 AND item_id=$3`, userID, req.ItemType, req.ItemID)
		success(w, map[string]interface{}{"favorited": false})
	} else {
		h.Pool.Exec(r.Context(), `INSERT INTO favorites (user_id, item_type, item_id) VALUES ($1,$2,$3)`, userID, req.ItemType, req.ItemID)
		success(w, map[string]interface{}{"favorited": true})
	}
}

type EnergyHandler struct {
	Pool          *pgxpool.Pool
	DeepSeekKey   string
	DeepSeekClient *services.DeepSeekClient
}

func (h *EnergyHandler) Assess(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	var req struct {
		BirthDate       string `json:"birth_date"`
		ZodiacSign      string `json:"zodiac_sign"`
		PreferredElement string `json:"preferred_element"`
		Concerns        string `json:"concerns"`
		Lifestyle       string `json:"lifestyle"`
	}
	if err := decode(r, &req); err != nil {
		fail(w, 400, "invalid request body")
		return
	}
	if req.ZodiacSign == "" {
		fail(w, 400, "zodiac_sign is required")
		return
	}
	recs := services.NewEnergyRecommendations(req.ZodiacSign, req.PreferredElement, req.Concerns, req.Lifestyle)
	recommendations := make([]interface{}, len(recs))
	for i, r := range recs {
		recommendations[i] = r
	}
	recJSON, _ := json.Marshal(recommendations)
	prefJSON, _ := json.Marshal(map[string]string{"preferred_element": req.PreferredElement})
	extraInput, _ := json.Marshal(map[string]string{"concerns": req.Concerns, "lifestyle": req.Lifestyle})
	var assessment models.EnergyAssessment
	h.Pool.QueryRow(r.Context(),
		`INSERT INTO energy_assessments (user_id, birth_date, zodiac_sign, preferences, raw_input, ai_response, recommendations)
		 VALUES ($1,$2,$3,$4,$5,$6,$7) RETURNING id, created_at`,
		userID, req.BirthDate, req.ZodiacSign, string(prefJSON), string(extraInput), string(recJSON), string(recJSON),
	).Scan(&assessment.ID, &assessment.CreatedAt)
	success(w, map[string]interface{}{"assessment_id": assessment.ID, "recommendations": recommendations})
}

func (h *EnergyHandler) History(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	rows, err := h.Pool.Query(r.Context(), `SELECT id, created_at FROM energy_assessments WHERE user_id=$1 ORDER BY created_at DESC LIMIT 10`, userID)
	if err != nil {
		fail(w, 500, "failed to query history: "+err.Error())
		return
	}
	defer rows.Close()
	type summary struct {
		ID        string    `json:"id"`
		CreatedAt time.Time `json:"created_at"`
	}
	results := []summary{}
	for rows.Next() {
		var s summary
		if err := rows.Scan(&s.ID, &s.CreatedAt); err != nil {
			continue
		}
		results = append(results, s)
	}
	if results == nil {
		results = []summary{}
	}
	success(w, results)
}

func (h *EnergyHandler) Get(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	id := extractID(r)
	var a models.EnergyAssessment
	err := h.Pool.QueryRow(r.Context(),
		`SELECT id, user_id, birth_date, zodiac_sign, raw_input, ai_response, recommendations, created_at FROM energy_assessments WHERE id=$1`, id,
	).Scan(&a.ID, &a.UserID, &a.BirthDate, &a.ZodiacSign, &a.RawInput, &a.AIResponse, &a.Recommendations, &a.CreatedAt)
	if err != nil {
		fail(w, 404, "assessment not found")
		return
	}
	if a.UserID != userID && middleware.GetUserRole(r) != "admin" {
		fail(w, 403, "not your assessment")
		return
	}
	success(w, a)
}

type EarningsHandler struct {
	Pool *pgxpool.Pool
}

func (h *EarningsHandler) Summary(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	var totalEarned, pendingAmount int
	h.Pool.QueryRow(r.Context(), `SELECT COALESCE(SUM(amount_cents),0) FROM designer_earnings WHERE designer_id=$1 AND status='paid'`, userID).Scan(&totalEarned)
	h.Pool.QueryRow(r.Context(), `SELECT COALESCE(SUM(amount_cents),0) FROM designer_earnings WHERE designer_id=$1 AND status='pending'`, userID).Scan(&pendingAmount)
	var totalSales int
	h.Pool.QueryRow(r.Context(), `SELECT COALESCE(SUM(sales_count),0) FROM user_designs WHERE user_id=$1`, userID).Scan(&totalSales)
	success(w, map[string]interface{}{
		"total_earned_cents": totalEarned, "pending_cents": pendingAmount, "total_design_sales": totalSales,
	})
}

func (h *EarningsHandler) History(w http.ResponseWriter, r *http.Request) {
	userID := middleware.GetUserID(r)
	rows, err := h.Pool.Query(r.Context(), `SELECT id, order_item_id, amount_cents, status, paid_at, created_at FROM designer_earnings WHERE designer_id=$1 ORDER BY created_at DESC LIMIT 50`, userID)
	if err != nil {
		fail(w, 500, "failed to query earnings history: "+err.Error())
		return
	}
	defer rows.Close()
	earnings := []models.DesignerEarning{}
	for rows.Next() {
		var e models.DesignerEarning
		if err := rows.Scan(&e.ID, &e.OrderItemID, &e.AmountCents, &e.Status, &e.PaidAt, &e.CreatedAt); err != nil {
			continue
		}
		earnings = append(earnings, e)
	}
	if earnings == nil {
		earnings = []models.DesignerEarning{}
	}
	success(w, earnings)
}

type UploadHandler struct{}

func (h *UploadHandler) Upload(w http.ResponseWriter, r *http.Request) {
	r.Body = http.MaxBytesReader(w, r.Body, 10<<20)
	if err := r.ParseMultipartForm(10 << 20); err != nil {
		fail(w, 400, "file too large (max 10MB)")
		return
	}
	file, header, err := r.FormFile("file")
	if err != nil {
		fail(w, 400, "no file provided")
		return
	}
	defer file.Close()
	filename := fmt.Sprintf("%d_%s", time.Now().UnixNano(), header.Filename)
		dst, err := os.Create("/data/uploads/" + filename)
	if err != nil {
		fail(w, 500, "failed to save file: "+err.Error())
		return
	}
	defer dst.Close()
	if _, err := io.Copy(dst, file); err != nil {
		fail(w, 500, "failed to write file: "+err.Error())
		return
	}
	success(w, map[string]interface{}{"url": "/uploads/" + filename, "filename": filename})
}

func parseInt(s string, def int) int {
	var n int
	if _, err := fmt.Sscanf(s, "%d", &n); err != nil {
		return def
	}
	return n
}

func extractJSON(s string) string {
	start := strings.Index(s, "[")
	if start < 0 {
		start = strings.Index(s, "{")
	}
	if start < 0 {
		return ""
	}
	end := strings.LastIndex(s, "]")
	if end < 0 {
		end = strings.LastIndex(s, "}")
	}
	if end < 0 || end <= start {
		return ""
	}
	return s[start : end+1]
}
