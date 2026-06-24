# Spirit Bracelet - Handcrafted Crystal Bracelet Platform

海外独立站：手串自定义 + AI 能量评估 + 社区设计收益

## Tech Stack
- **Frontend:** Flutter Web (Dart)
- **Backend:** Go (Chi router)
- **Database:** PostgreSQL
- **Payment:** Stripe
- **AI:** DeepSeek API
- **Storage:** Railway Volumes
- **Deploy:** Railway

## Project Structure
```
ai_bracelet_app/
├── backend/                # Go API server
│   ├── main.go
│   ├── config/
│   ├── database/migrations/
│   ├── handlers/
│   ├── middleware/
│   ├── models/
│   ├── services/
│   └── Dockerfile
├── frontend/               # Flutter Web
│   ├── lib/
│   │   ├── main.dart
│   │   ├── config/
│   │   ├── models/
│   │   ├── services/
│   │   ├── providers/
│   │   ├── screens/
│   │   └── widgets/
│   ├── web/
│   ├── Dockerfile
│   └── nginx.conf
└── railway.json
```

## Features
1. **Shop** - Browse pre-made crystal bracelets
2. **Design Studio** - Custom bracelet builder (beads/charms/pendants/clasps)
3. **Energy Assessment** - AI-powered (DeepSeek) analysis: zodiac + 五行 → recommendations
4. **Cart & Checkout** - Stripe payment integration
5. **Community Designs** - Users publish designs, earn 2% commission
6. **Designer Dashboard** - Track earnings, sold designs

## Deploy on Railway

### 1. Create Railway Project
```bash
# Install Railway CLI
npm i -g @railway/cli
railway login
railway init
```

### 2. Environment Variables (Backend)
```
PORT=8080
DATABASE_URL=postgres://...
JWT_SECRET=<generate-random-string>
STRIPE_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
DEEPSEEK_KEY=sk-...
FRONTEND_URL=https://your-app.railway.app
```

### 3. Create PostgreSQL Database
```bash
railway add postgres
# DB URL auto-injected as DATABASE_URL
```

### 4. Deploy Backend
```bash
cd backend
railway up
```

### 5. Build & Deploy Frontend
```bash
cd frontend
flutter build web --dart-define=API_URL=https://backend.railway.app
railway up
```

### 6. Stripe Webhook
Stripe Dashboard → Webhooks → Add endpoint:
- URL: `https://backend.railway.app/api/webhook/stripe`
- Events: `payment_intent.succeeded`, `payment_intent.payment_failed`

### 7. Stripe Connect (Designer Payouts)
For automated designer payouts, set up Stripe Connect:
1. Create Stripe Connect platform account
2. Add `stripe_account_id` column handler in earnings dashboard
3. Designers onboard via Stripe Express

## API Endpoints

### Public
- `GET /api/health`
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/products`
- `GET /api/products/{id}`
- `GET /api/elements`
- `GET /api/designs`
- `POST /api/webhook/stripe`

### Authenticated
- `GET /api/auth/me`
- `PUT /api/auth/me`
- `POST /api/designs`
- `GET /api/designs/mine`
- `POST /api/orders`
- `GET /api/orders`
- `POST /api/favorites/toggle`
- `POST /api/energy/assess`
- `GET /api/earnings`

### Admin
- `POST /api/admin/products`
- `PUT /api/admin/products/{id}`
- `POST /api/admin/elements`
- `PUT /api/admin/orders/{id}/status`

## Development

### Backend
```bash
cd backend
go run .
```

### Frontend
```bash
cd frontend
flutter run -d chrome --dart-define=API_URL=http://localhost:8080
```

### Database
```bash
psql $DATABASE_URL -f backend/database/migrations/001_init.sql
psql $DATABASE_URL -f backend/database/migrations/002_seed.sql
```

## Seed Data
- 8 pre-made products (crystal, lava stone, jade, etc.)
- 28 design elements (beads, charms, pendants, spacers, clasps)
- Admin user: `admin@example.com` / `admin123` (create via register endpoint, set role manually)
