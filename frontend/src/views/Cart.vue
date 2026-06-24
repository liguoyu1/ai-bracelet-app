<template>
  <div class="cart-page">
    <!-- Empty state -->
    <div v-if="!items.length" class="empty-state">
      <span class="empty-icon">🪷</span>
      <h2 class="empty-title">Your cart is empty</h2>
      <p class="empty-subtitle">Browse products or design your own</p>
    </div>

    <!-- Cart body + bottom bar -->
    <template v-else>
      <div class="cart-body">
        <div v-for="(item, i) in items" :key="i" class="cart-item card">
          <!-- Thumbnail -->
          <div class="item-thumb">
            <img :src="item.image" :alt="item.name" />
          </div>

          <!-- Name + type chip -->
          <div class="item-info">
            <h3 class="item-name">{{ item.name }}</h3>
            <span class="item-type-chip">{{ item.itemType === 'design' ? 'Custom' : 'Product' }}</span>
          </div>

          <!-- Price + qty selector + delete -->
          <div class="item-actions">
            <span class="item-price">{{ formatPrice(item.price) }}</span>

            <!-- Qty selector -->
            <div class="qty-selector">
              <button
                class="qty-btn"
                :disabled="item.qty <= 1"
                @click="item.qty > 1 ? cartStore.updateQty(i, item.qty - 1) : cartStore.removeItem(i)"
              >−</button>
              <span class="qty-value">{{ item.qty }}</span>
              <button class="qty-btn" @click="cartStore.updateQty(i, item.qty + 1)">+</button>
            </div>

            <!-- Delete -->
            <button class="delete-btn" @click="cartStore.removeItem(i)">
              <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="3 6 5 6 21 6" />
                <path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2" />
              </svg>
            </button>
          </div>
        </div>
      </div>

      <!-- Bottom bar -->
      <div class="bottom-bar">
        <div class="total-row">
          <span class="total-label">Total</span>
          <span class="total-value">{{ cartStore.totalStr }}</span>
        </div>
        <button class="checkout-btn" @click="goCheckout">Checkout</button>
      </div>
    </template>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import { useI18n } from '../composables/useI18n'
import { useCartStore } from '../stores/cart'

const { t } = useI18n()
const router = useRouter()
const cartStore = useCartStore()

const items = cartStore.items

function formatPrice(cents) {
  return '$' + ((cents || 0) / 100).toFixed(2)
}

function goCheckout() {
  router.push('/order')
}
</script>

<style scoped>
.cart-page {
  display: flex;
  flex-direction: column;
  min-height: calc(100vh - 64px);
  padding: 20px;
  max-width: 500px;
  margin: 0 auto;
}

/* ── Empty state ── */
.empty-state {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  text-align: center;
}
.empty-icon {
  font-size: 64px;
  margin-bottom: 20px;
  opacity: 0.8;
}
.empty-title {
  font-family: var(--serif);
  color: var(--gold);
  font-size: 22px;
  font-weight: 600;
  margin-bottom: 10px;
}
.empty-subtitle {
  color: var(--cream);
  font-size: 14px;
  opacity: 0.7;
}

/* ── Cart body (scrollable) ── */
.cart-body {
  flex: 1;
  overflow-y: auto;
  padding-bottom: 16px;
}

/* ── Cart item card ── */
.cart-item {
  display: flex;
  gap: 12px;
  padding: 12px;
  margin-bottom: 12px;
  align-items: flex-start;
}
.item-thumb {
  width: 60px;
  height: 60px;
  border-radius: 8px;
  overflow: hidden;
  background: var(--card);
  flex-shrink: 0;
}
.item-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.item-info {
  flex: 1;
  min-width: 0;
}
.item-name {
  font-family: var(--serif);
  font-size: 15px;
  font-weight: 500;
  color: var(--cream);
  line-height: 1.3;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  text-overflow: ellipsis;
  margin-bottom: 6px;
}
.item-type-chip {
  display: inline-block;
  padding: 3px 8px;
  border: 1px solid var(--gold);
  border-radius: 4px;
  color: var(--gold);
  font-size: 11px;
  font-weight: 500;
}
.item-actions {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 8px;
  flex-shrink: 0;
}
.item-price {
  font-family: var(--serif);
  color: var(--gold);
  font-size: 16px;
  font-weight: bold;
}

/* ── Qty selector ── */
.qty-selector {
  display: flex;
  align-items: center;
  border: 1px solid rgba(200, 164, 92, 0.6);
  border-radius: 6px;
}
.qty-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 28px;
  height: 28px;
  background: none;
  border: none;
  color: var(--gold);
  font-size: 16px;
  cursor: pointer;
  transition: opacity .15s;
}
.qty-btn:disabled {
  opacity: 0.3;
  cursor: default;
}
.qty-btn:not(:disabled):hover {
  opacity: 0.7;
}
.qty-value {
  min-width: 20px;
  text-align: center;
  color: var(--cream);
  font-size: 14px;
  font-weight: 600;
  padding: 0 8px;
}

/* ── Delete button ── */
.delete-btn {
  background: none;
  border: none;
  color: var(--copper);
  cursor: pointer;
  padding: 0;
  display: flex;
  align-items: center;
  transition: opacity .15s;
}
.delete-btn:hover {
  opacity: 0.7;
}

/* ── Bottom bar ── */
.bottom-bar {
  background: var(--surface);
  padding: 16px 20px;
  border-radius: 12px 12px 0 0;
  box-shadow: 0 -4px 12px rgba(0, 0, 0, 0.3);
  margin: 0 -20px -20px;
}
.total-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 16px;
}
.total-label {
  font-family: var(--serif);
  color: var(--cream);
  font-size: 16px;
}
.total-value {
  font-family: var(--serif);
  color: var(--gold);
  font-size: 22px;
  font-weight: bold;
}
.checkout-btn {
  width: 100%;
  background: var(--gold);
  color: #000;
  border: none;
  border-radius: 8px;
  padding: 16px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: opacity .15s;
}
.checkout-btn:hover {
  opacity: 0.85;
}
</style>
