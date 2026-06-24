-- 001_init.sql - Core schema
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    display_name VARCHAR(100) NOT NULL DEFAULT '',
    avatar_url TEXT DEFAULT '',
    bio TEXT DEFAULT '',
    role VARCHAR(20) NOT NULL DEFAULT 'user' CHECK (role IN ('user','designer','admin')),
    stripe_account_id TEXT DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Products (pre-made/admin-created)
CREATE TABLE products (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    slug VARCHAR(255) UNIQUE NOT NULL,
    description TEXT DEFAULT '',
    price_cents INTEGER NOT NULL CHECK (price_cents > 0),
    images TEXT[] DEFAULT '{}',
    category VARCHAR(100) NOT NULL DEFAULT 'general',
    tags TEXT[] DEFAULT '{}',
    materials JSONB DEFAULT '{}',
    stock INTEGER NOT NULL DEFAULT 999 CHECK (stock >= 0),
    is_active BOOLEAN NOT NULL DEFAULT true,
    sales_count INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Design elements catalog (beads, charms, pendants, strings)
CREATE TABLE design_elements (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(255) NOT NULL,
    type VARCHAR(50) NOT NULL CHECK (type IN ('bead','charm','pendant','string','spacer','clasp')),
    color VARCHAR(50) DEFAULT '',
    material VARCHAR(100) DEFAULT '',
    shape VARCHAR(50) DEFAULT '',
    size_mm DECIMAL(5,1) DEFAULT 8.0,
    image_url TEXT NOT NULL DEFAULT '',
    price_cents INTEGER NOT NULL DEFAULT 0,
    stock INTEGER NOT NULL DEFAULT 999,
    is_active BOOLEAN NOT NULL DEFAULT true,
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- User designs (custom bracelet designs)
CREATE TABLE user_designs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(255) NOT NULL DEFAULT 'My Design',
    description TEXT DEFAULT '',
    design_data JSONB NOT NULL DEFAULT '{}'::jsonb,
    -- { elements: [{element_id, x, y, rotation, scale, quantity}], layout: {...} }
    preview_images TEXT[] DEFAULT '{}',
    price_cents INTEGER NOT NULL DEFAULT 0,
    is_published BOOLEAN NOT NULL DEFAULT false,
    sales_count INTEGER NOT NULL DEFAULT 0,
    total_earnings_cents INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Orders
CREATE TABLE orders (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    stripe_payment_intent_id TEXT UNIQUE DEFAULT '',
    total_cents INTEGER NOT NULL CHECK (total_cents > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','paid','processing','shipped','delivered','cancelled','refunded')),
    shipping_address JSONB DEFAULT '{}',
    contact_email VARCHAR(255) DEFAULT '',
    notes TEXT DEFAULT '',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Order items
CREATE TABLE order_items (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    order_id UUID NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    item_type VARCHAR(20) NOT NULL CHECK (item_type IN ('product','design')),
    item_id UUID NOT NULL,
    design_snapshot JSONB DEFAULT '{}',
    quantity INTEGER NOT NULL DEFAULT 1 CHECK (quantity > 0),
    unit_price_cents INTEGER NOT NULL CHECK (unit_price_cents > 0),
    total_cents INTEGER NOT NULL CHECK (total_cents > 0),
    designer_id UUID REFERENCES users(id) ON DELETE SET NULL,
    designer_commission_cents INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Favorites
CREATE TABLE favorites (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    item_type VARCHAR(20) NOT NULL CHECK (item_type IN ('product','design')),
    item_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(user_id, item_type, item_id)
);

-- Energy assessments
CREATE TABLE energy_assessments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    birth_date DATE,
    zodiac_sign VARCHAR(20) DEFAULT '',
    chinese_zodiac VARCHAR(20) DEFAULT '',
    five_elements JSONB DEFAULT '{}',
    personality_traits JSONB DEFAULT '{}',
    preferences JSONB DEFAULT '{}',
    raw_input JSONB DEFAULT '{}',
    ai_response TEXT DEFAULT '',
    recommendations JSONB DEFAULT '[]',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Designer earnings ledger
CREATE TABLE designer_earnings (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    designer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    order_item_id UUID NOT NULL REFERENCES order_items(id) ON DELETE CASCADE,
    amount_cents INTEGER NOT NULL CHECK (amount_cents > 0),
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','available','paid','cancelled')),
    paid_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- Indexes
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_active ON products(is_active) WHERE is_active = true;

CREATE INDEX idx_user_designs_user ON user_designs(user_id);
CREATE INDEX idx_user_designs_published ON user_designs(is_published) WHERE is_published = true;

CREATE INDEX idx_orders_user ON orders(user_id);
CREATE INDEX idx_orders_status ON orders(status);

CREATE INDEX idx_order_items_designer ON order_items(designer_id) WHERE designer_id IS NOT NULL;
CREATE INDEX idx_order_items_order ON order_items(order_id);

CREATE INDEX idx_favorites_user ON favorites(user_id);
CREATE INDEX idx_energy_assessments_user ON energy_assessments(user_id);
CREATE INDEX idx_designer_earnings_designer ON designer_earnings(designer_id);
CREATE INDEX idx_design_elements_type ON design_elements(type);
