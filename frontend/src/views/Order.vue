<template>
  <div class="order-page">
    <!-- Confirmation state -->
    <template v-if="orderId">
      <div class="order-confirm">
        <div class="confirm-icon">✓</div>
        <h2 class="confirm-title">{{ t('order.orderPlaced') }}</h2>
        <p class="confirm-id">{{ t('order.orderId') }}: {{ orderId }}</p>
        <p class="confirm-total">{{ t('order.total') }}: {{ cart.totalStr }}</p>
        <p class="confirm-notice">{{ t('order.shippingNotice') }}</p>
        <button class="btn-gold btn-full" @click="router.push('/')">{{ t('order.backToShop') }}</button>
      </div>
    </template>

    <!-- Checkout form -->
    <template v-else>
      <div class="order-header">
        <button class="back-btn" @click="router.back()">←</button>
        <h1 class="page-title">{{ t('order.title') }}</h1>
      </div>

      <div class="order-body">
        <!-- Order Summary -->
        <div class="summary-card">
          <h3 class="summary-title">{{ t('order.summary') }}</h3>
          <div v-for="(item, i) in cart.items" :key="i" class="summary-row">
            <span class="summary-name">{{ item.name }} x{{ item.qty || 1 }}</span>
            <span class="summary-price">${{ ((item.price || 0) * (item.qty || 1) / 100).toFixed(2) }}</span>
          </div>
          <div class="summary-divider"></div>
          <div class="summary-total">
            <span>{{ t('order.total') }}</span>
            <span class="total-amount">{{ cart.totalStr }}</span>
          </div>
        </div>

        <!-- Shipping Information -->
        <h3 class="section-title">{{ t('order.shippingInfo') }}</h3>

        <div class="form-group">
          <label class="field-label">{{ t('order.email') }}</label>
          <input v-model="email" type="email" class="field-input" :placeholder="t('order.email')" />
        </div>

        <div class="form-group">
          <label class="field-label">{{ t('order.fullName') }}</label>
          <input v-model="name" class="field-input" :placeholder="t('order.fullName')" />
        </div>

        <div class="form-group">
          <label class="field-label">{{ t('order.address') }}</label>
          <input v-model="address" class="field-input" :placeholder="t('order.address')" />
        </div>

        <div class="form-row">
          <div class="form-group flex-3">
            <label class="field-label">{{ t('order.city') }}</label>
            <input v-model="city" class="field-input" :placeholder="t('order.city')" />
          </div>
          <div class="form-group flex-1">
            <label class="field-label">{{ t('order.state') }}</label>
            <input v-model="state" class="field-input" :placeholder="t('order.state')" />
          </div>
          <div class="form-group flex-1">
            <label class="field-label">{{ t('order.zip') }}</label>
            <input v-model="zip" class="field-input" :placeholder="t('order.zip')" />
          </div>
        </div>

        <div class="form-row">
          <div class="form-group flex-1">
            <label class="field-label">{{ t('order.country') }}</label>
            <input v-model="country" class="field-input" :placeholder="t('order.country')" />
          </div>
          <div class="form-group flex-1">
            <label class="field-label">{{ t('order.phone') }}</label>
            <input v-model="phone" type="tel" class="field-input" :placeholder="t('order.phone')" />
          </div>
        </div>

        <!-- Error -->
        <p v-if="error" class="error-text">{{ error }}</p>

        <!-- Place Order -->
        <button
          class="btn-gold btn-full btn-place"
          :disabled="processing"
          @click="placeOrder"
        >
          <span v-if="processing" class="spinner" style="margin:0 auto"></span>
          <span v-else>{{ t('order.placeOrder') }} — {{ cart.totalStr }}</span>
        </button>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useCartStore } from '../stores/cart'
import { useI18n } from '../composables/useI18n'
import { createOrder, getOrderPaymentIntent } from '../api'

const { t } = useI18n()
const router = useRouter()
const cart = useCartStore()

const email = ref('')
const name = ref('')
const address = ref('')
const city = ref('')
const state = ref('')
const zip = ref('')
const country = ref('US')
const phone = ref('')
const processing = ref(false)
const error = ref(null)
const orderId = ref(null)

function validate() {
  if (!email.value.trim() || !name.value.trim() || !address.value.trim() || !city.value.trim() || !zip.value.trim()) {
    error.value = t('order.required')
    return false
  }
  return true
}

async function placeOrder() {
  if (!validate()) return
  processing.value = true
  error.value = null

  try {
    const res = await createOrder({
      shipping_address: {
        name: name.value.trim(),
        address: address.value.trim(),
        city: city.value.trim(),
        state: state.value.trim(),
        zip: zip.value.trim(),
        country: country.value.trim(),
        phone: phone.value.trim(),
      },
      contact_email: email.value.trim(),
      items: cart.items.map(i => ({ item_type: 'product', item_id: i.id, quantity: i.qty || 1 })),
    })
    const order = res.data || res
    const id = order.order_id || order.id || order._id
    orderId.value = id

    // Get Stripe checkout URL
    try {
      const piRes = await getOrderPaymentIntent(id)
      const checkoutUrl = piRes.data?.checkout_url || piRes.checkout_url
      if (checkoutUrl) {
        cart.clear()
        window.open(checkoutUrl, '_self')
      } else {
        error.value = t('order.contactSupport')
      }
    } catch {
      error.value = t('order.contactSupport')
    }
  } catch (e) {
    error.value = t('order.failed')
  } finally {
    processing.value = false
  }
}
</script>

<style scoped>
.order-page {
  max-width: 500px;
  margin: 0 auto;
  padding: 20px;
}

.order-header {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-bottom: 24px;
}

.back-btn {
  background: none;
  border: none;
  color: var(--gold);
  font-size: 22px;
  cursor: pointer;
  padding: 0;
  line-height: 1;
}

.page-title {
  font-family: var(--serif);
  font-size: 20px;
  color: var(--gold);
  margin: 0;
}

.order-body {
  display: flex;
  flex-direction: column;
  gap: 16px;
}

/* Confirmation */
.order-confirm {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 60px 24px;
  text-align: center;
}

.confirm-icon {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  background: rgba(200, 164, 92, 0.15);
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 36px;
  color: var(--gold);
  margin-bottom: 24px;
}

.confirm-title {
  font-family: var(--serif);
  font-size: 22px;
  color: var(--cream);
  margin-bottom: 8px;
}

.confirm-id {
  color: var(--cream);
  font-size: 14px;
  margin-bottom: 8px;
}

.confirm-total {
  font-size: 16px;
  font-weight: bold;
  color: var(--gold);
  margin-bottom: 24px;
}

.confirm-notice {
  color: #999;
  font-size: 13px;
  margin-bottom: 32px;
}

/* Summary Card */
.summary-card {
  background: var(--surface);
  border-radius: 12px;
  padding: 16px;
  border: 1px solid rgba(200, 164, 92, 0.1);
}

.summary-title {
  font-size: 16px;
  font-weight: bold;
  color: var(--gold);
  margin-bottom: 12px;
}

.summary-row {
  display: flex;
  justify-content: space-between;
  padding: 4px 0;
}

.summary-name {
  font-size: 14px;
  color: var(--cream);
}

.summary-price {
  font-size: 14px;
  color: var(--cream);
}

.summary-divider {
  height: 1px;
  background: #333;
  margin: 12px 0;
}

.summary-total {
  display: flex;
  justify-content: space-between;
  font-size: 16px;
  font-weight: bold;
  color: var(--cream);
}

.total-amount {
  color: var(--gold);
}

/* Section */
.section-title {
  font-size: 16px;
  font-weight: bold;
  color: var(--gold);
  margin: 0;
}

/* Form */
.form-group {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.field-label {
  font-size: 13px;
  color: var(--gold);
}

.field-input {
  background: var(--surface);
  border: 1px solid rgba(200, 164, 92, 0.2);
  border-radius: 12px;
  padding: 14px 16px;
  color: var(--cream);
  font-size: 14px;
  outline: none;
  width: 100%;
  transition: border-color 0.2s;
  box-sizing: border-box;
}

.field-input:focus {
  border-color: var(--gold);
}

.field-input::placeholder {
  color: #666;
}

.form-row {
  display: flex;
  gap: 8px;
}

.flex-3 { flex: 3; }
.flex-1 { flex: 1; }

/* Error */
.error-text {
  color: #e74c3c;
  font-size: 14px;
}

/* Button */
.btn-place {
  width: 100%;
  padding: 16px;
  font-size: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 52px;
}

.btn-full { width: 100%; }

.btn-gold:disabled {
  opacity: 0.4;
  cursor: default;
}
</style>
