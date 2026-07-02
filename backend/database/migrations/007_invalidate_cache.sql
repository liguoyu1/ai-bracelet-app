-- 007_invalidate_cache.sql - Fix orders stripe_payment_intent_id unique constraint
-- Drops the broken UNIQUE constraint that prevents multiple orders with empty payment_intent_id
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_stripe_payment_intent_id_key;
