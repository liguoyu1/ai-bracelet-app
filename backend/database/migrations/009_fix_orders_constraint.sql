-- 009_fix_orders_constraint.sql - Fix orders UNIQUE constraint
-- stripe_payment_intent_id has UNIQUE DEFAULT '' which breaks all orders after the first
ALTER TABLE orders DROP CONSTRAINT IF EXISTS orders_stripe_payment_intent_id_key;
