# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Crystal bracelet e-commerce platform (overseas buyers). Go backend + Vue 3 SPA, PostgreSQL, Airwallex payments, DeepSeek AI for energy assessment. Migrated from Flutter Web.

## Commands

```bash
# Backend dev
cd backend && go run .

# Backend build
cd backend && CGO_ENABLED=0 GOOS=linux go build -o server .

# Frontend dev (Vite :5173, proxies /api → :8080)
cd frontend && npm run dev

# Frontend build
cd frontend && npm run build

# Docker
docker build -f backend/Dockerfile -t bracelet-api .
docker build -f frontend/Dockerfile -t bracelet-frontend .
```

**No tests exist** (0 `_test.go` files, no test infra).

**Database migrations** auto-run on startup (`database/postgres.go:RunMigrations` — reads `migrations/*.sql` by filename order, idempotent via `IF NOT EXISTS`). Skip with `SKIP_MIGRATIONS=true`.

## Architecture

Two-service monorepo deployed on Railway:

```
nginx (frontend:8080)
  ├── /api/* → proxy_pass to backend
  └── /*     → SPA fallback (index.html)

backend (Go 1.22, chi v5, pgx v5)
  ├── main.go         — config → DB connect → migrations → service clients → handler wiring → routes
  ├── config/         — env var loader
  ├── database/       — pgxpool connect, SQL migration runner
  ├── middleware/     — JWT auth (HS256, 72h), CORS, logger, admin guard
  ├── handlers/       — handlers.go (~900 lines), helpers.go (JSON + i18n), webhook.go (Airwallex HMAC)
  ├── services/       — airwallex.go, deepseek.go, energy_rules.go (deterministic)
  └── models/         — domain structs
```

### Route groups
- **PUBLIC:** auth register/login, products, design elements, designs list, webhook
- **AUTH** (JWT Bearer): profile, my designs, orders, favorites, energy assessment, earnings, upload
- **ADMIN** (`role=="admin"`): product/element CRUD, order status update

### Key flows
1. **Order → Payment:** Order created in DB txn (FOR UPDATE locks) → Airwallex payment_intent → hosted checkout → webhook (HMAC verified) → order=paid → 2% designer commission to `designer_earnings`
2. **Energy assessment:** `DeepSeekClient` injected into handler but never called — deterministic rule engine only (zodiac + element + keyword match)
3. **I18n:** 7 languages (en/zh/ja/ko/ru/fr/de) in `frontend/src/i18n/index.js` (~170 keys), `useI18n()` composable. Backend localizes via `products.i18n` JSONB column + `?lang=` query param.

### Database (8 tables)
users, products, design_elements, user_designs, orders, order_items, favorites, energy_assessments, designer_earnings. UUID PKs, JSONB for i18n. Raw SQL throughout (no ORM).

### Stack (lean)
**Go:** chi v5, pgx v5, golang-jwt v5, x/crypto (bcrypt). **JS:** vue 3, vue-router 4, pinia 3, axios 1. No CSS/i18n/testing frameworks.

## Known quirks (don't "fix" — intentional or legacy)

- `StripePaymentIntentID` / `stripe_payment_intent_id` naming throughout code/DB — all actual payment code uses Airwallex. Incomplete rename, not a bug.
- `EnergyHandler.Assess` has `DeepSeekClient` field but never calls it — rule engine only.
- `handlers.go:extractID()` splits URL path for IDs instead of using chi's `{id}` param.
- `UploadHandler` writes to `/data/uploads/` but never persists to any DB table.
- `POST /api/migrate-i18n` and `GET /api/debug-i18n` are temporary/debug routes.
- README.md describes Flutter Web frontend (outdated). PLAN.md is a Chinese audit checklist (2026-06-24).
