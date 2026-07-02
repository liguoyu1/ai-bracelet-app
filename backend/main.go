package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/go-chi/chi/v5"

	"bracelet/config"
	"bracelet/database"
	"bracelet/handlers"
	"bracelet/middleware"
	"bracelet/services"
)

func main() {
	cfg := config.Load()

	// Connect DB
	log.Println("Connecting to database...")
	pool, err := database.Connect(cfg.DatabaseURL)
	if err != nil {
		log.Fatalf("Database connection failed: %v", err)
	}
	defer pool.Close()
	log.Println("Connected to database")

	// Run migrations
	if os.Getenv("SKIP_MIGRATIONS") != "true" {
		log.Println("Running database migrations...")
		if err := database.RunMigrations(pool, "database/migrations"); err != nil {
			log.Printf("Migration warning: %v (may already be applied)", err)
		}
	}

	// Init services
	airwallexClient := services.NewAirwallexClient(cfg.AirwallexClientID, cfg.AirwallexAPIKey)
	airwallexClient.ReturnURL = cfg.FrontendURL + "/order/status"
	airwallexClient.WebhookKey = cfg.AirwallexWebhookKey
	deepSeekClient := services.NewDeepSeekClient(cfg.DeepSeekKey)

	// Init handlers
	authH := &handlers.AuthHandler{Pool: pool, JWTSecret: cfg.JWTSecret}
	productH := &handlers.ProductHandler{Pool: pool}
	elemH := &handlers.DesignElementHandler{Pool: pool}
	designH := &handlers.DesignHandler{Pool: pool}
	orderH := &handlers.OrderHandler{Pool: pool, AirwallexClient: airwallexClient}
	favH := &handlers.FavoriteHandler{Pool: pool}
	energyH := &handlers.EnergyHandler{Pool: pool, DeepSeekClient: deepSeekClient}
	earningsH := &handlers.EarningsHandler{Pool: pool}
	uploadH := &handlers.UploadHandler{Pool: pool}
	webhookH := &handlers.WebhookHandler{Pool: pool, AirwallexClient: airwallexClient}

	// Router
	r := chi.NewRouter()

	// Global middleware
	r.Use(middleware.CORSHandler(cfg.FrontendURL))
	r.Use(middleware.Logger)
	r.Use(middleware.JSON)

	// Public routes
	r.Get("/api/health", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte(`{"status":"ok"}`))
	})
	r.Get("/api/config", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]interface{}{
			"frontend_url": cfg.FrontendURL,
		})
	})
	r.Post("/api/webhook/airwallex", webhookH.HandleAirwallex)

	// Fix: drop broken UNIQUE constraint on orders.stripe_payment_intent_id
	// (UNIQUE DEFAULT '' blocks all but first order)
	pool.Exec(context.Background(), `ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_stripe_payment_intent_id_key`)

	// Auth (public)
	r.Post("/api/auth/register", authH.Register)
	r.Post("/api/auth/login", authH.Login)

	// Protected routes
	r.Group(func(r chi.Router) {
		r.Use(middleware.AuthMiddleware(cfg.JWTSecret))

		r.Get("/api/auth/me", authH.Me)
		r.Put("/api/auth/me", authH.UpdateProfile)

		// Designs (authenticated)
		r.Get("/api/designs/mine", designH.MyDesigns)
		r.Post("/api/designs", designH.Create)
		r.Put("/api/designs/{id}", designH.Update)
		r.Post("/api/designs/{id}/publish", designH.Publish)

		// Orders
		r.Post("/api/orders", orderH.Create)
		r.Get("/api/orders", orderH.List)
		r.Get("/api/orders/{id}", orderH.Get)
		r.Post("/api/orders/{id}/payment-intent", orderH.CreatePaymentIntent)

		// Favorites
		r.Get("/api/favorites", favH.List)
		r.Post("/api/favorites/toggle", favH.Toggle)

		// Energy
		r.Post("/api/energy/assess", energyH.Assess)
		r.Get("/api/energy/history", energyH.History)
		r.Get("/api/energy/{id}", energyH.Get)

		// Earnings (designer)
		r.Get("/api/earnings", earningsH.Summary)
		r.Get("/api/earnings/history", earningsH.History)

		// Upload
		r.Post("/api/upload", uploadH.Upload)

		// Admin routes
		r.Group(func(r chi.Router) {
			r.Use(middleware.AdminOnly)

			// Product management
			r.Get("/api/admin/products", productH.AdminList)
			r.Post("/api/admin/products", productH.Create)
			r.Put("/api/admin/products/{id}", productH.Update)

			// Design elements management
			r.Get("/api/admin/elements", elemH.AdminList)
			r.Post("/api/admin/elements", elemH.Create)
			r.Put("/api/admin/elements/{id}", elemH.AdminUpdate)

			// Order management
			r.Put("/api/admin/orders/{id}/status", orderH.UpdateStatus)
		})
	})

	// Public routes
	r.Get("/api/products", productH.List)
	r.Get("/api/products/{id}", productH.Get)
	r.Get("/api/elements", elemH.List)
	r.Get("/api/designs", designH.List)
	r.Get("/api/designs/{id}", designH.Get)

	// Serve uploaded files
	fileServer := http.FileServer(http.Dir("/data/uploads"))
	r.Handle("/uploads/*", http.StripPrefix("/uploads/", fileServer))

	// Start server
	addr := fmt.Sprintf(":%s", cfg.Port)
	log.Printf("Bracelet API server starting on %s", addr)
	if err := http.ListenAndServe(addr, r); err != nil {
		log.Fatalf("Server failed: %v", err)
	}
}
