package config

import (
	"os"
	"strconv"
)

type Config struct {
	Port         string
	DatabaseURL  string
	JWTSecret    string
	AirwallexClientID string
	AirwallexAPIKey   string
	AirwallexWebhookKey string
	DeepSeekKey  string
	FrontendURL  string
	ImageMaxSize int64 // bytes
}

func Load() *Config {
	return &Config{
		Port:                getEnv("PORT", "8080"),
		DatabaseURL:         getEnv("DATABASE_URL", "postgres://localhost:5432/bracelet?sslmode=disable"),
		JWTSecret:           getEnv("JWT_SECRET", "change-me-in-production"),
		AirwallexClientID:   getEnv("AIRWALLEX_CLIENT_ID", ""),
		AirwallexAPIKey:     getEnv("AIRWALLEX_API_KEY", ""),
		AirwallexWebhookKey: getEnv("AIRWALLEX_WEBHOOK_KEY", ""),
		DeepSeekKey:         getEnv("DEEPSEEK_KEY", ""),
		FrontendURL:         getEnv("FRONTEND_URL", "http://localhost:3000"),
		ImageMaxSize:        int64(getEnvInt("IMAGE_MAX_SIZE", 10 * 1024 * 1024)),
	}
}

func getEnv(key, fallback string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return fallback
}

func getEnvInt(key string, fallback int) int {
	if v := os.Getenv(key); v != "" {
		if n, err := strconv.Atoi(v); err == nil {
			return n
		}
	}
	return fallback
}
