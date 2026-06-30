package main

import (
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

	// Temporary: manually run i18n migration (remove after DB column exists)
	r.Post("/api/migrate-i18n", func(w http.ResponseWriter, r *http.Request) {
		_, err1 := pool.Exec(r.Context(), `ALTER TABLE products ADD COLUMN IF NOT EXISTS i18n JSONB DEFAULT '{}'`)
		_, err2 := pool.Exec(r.Context(), `ALTER TABLE design_elements ADD COLUMN IF NOT EXISTS i18n JSONB DEFAULT '{}'`)
		if err1 != nil || err2 != nil {
			errMsg := fmt.Sprintf("migration errors: %v / %v", err1, err2)
			w.WriteHeader(500)
			json.NewEncoder(w).Encode(map[string]interface{}{"success": false, "error": errMsg})
			return
		}
		pool.Exec(r.Context(), `UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"水晶和谐手串"') WHERE slug = 'crystal-harmony'`)
		pool.Exec(r.Context(), `UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"熔岩接地手串"') WHERE slug = 'lava-stone-grounding'`)
		pool.Exec(r.Context(), `UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"玉石智慧手串"') WHERE slug = 'jade-wisdom'`)
		pool.Exec(r.Context(), `UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"虎眼成功手串"') WHERE slug = 'tiger-eye-success'`)
		pool.Exec(r.Context(), `UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"粉晶爱情手串"') WHERE slug = 'rose-quartz-love'`)
		pool.Exec(r.Context(), `UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"黑曜石护盾手串"') WHERE slug = 'black-obsidian-shield'`)
		pool.Exec(r.Context(), `UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"黄晶丰盛手串"') WHERE slug = 'citrine-abundance'`)
		pool.Exec(r.Context(), `UPDATE products SET i18n = jsonb_set(COALESCE(i18n, '{}'::jsonb), '{zh,name}', '"芳香精油手串"') WHERE slug = 'aromatherapy-essential'`)
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]interface{}{"success": true, "data": map[string]string{"message": "i18n migration applied"}})
	})

	// Debug: check raw i18n for a product
	r.Get("/api/debug-i18n", func(w http.ResponseWriter, r *http.Request) {
		slug := r.URL.Query().Get("slug")
		var i18nRaw []byte
		err := pool.QueryRow(r.Context(), `SELECT i18n FROM products WHERE slug=$1`, slug).Scan(&i18nRaw)
		if err != nil {
			w.WriteHeader(404)
			json.NewEncoder(w).Encode(map[string]string{"error": err.Error()})
			return
		}
		w.Header().Set("Content-Type", "application/json")
		w.Write(i18nRaw)
	})

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
