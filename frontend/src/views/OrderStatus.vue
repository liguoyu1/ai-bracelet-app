<template>
  <div class="status-page">
    <div class="status-card">
      <!-- Icon -->
      <div :class="['status-icon', isSuccess ? 'success' : 'cancel']">
        <span v-if="isSuccess">✓</span>
        <span v-else>✕</span>
      </div>

      <!-- Title -->
      <h2 class="status-title">
        {{ isSuccess ? t('order.paymentSuccess') : t('order.paymentCancelled') }}
      </h2>

      <!-- Subtitle -->
      <p class="status-subtitle">
        {{ isSuccess ? t('order.paymentSuccessSub') : t('order.paymentCancelledSub') }}
      </p>

      <!-- Order ID badge -->
      <div v-if="orderId" class="order-badge">
        {{ t('order.orderId') }} #{{ orderId }}
      </div>

      <!-- Back to Shop -->
      <button class="btn-gold btn-full btn-shop" @click="router.push('/')">
        {{ t('order.backToShop') }}
      </button>
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from '../composables/useI18n'

const { t } = useI18n()
const route = useRoute()
const router = useRouter()

const status = computed(() => route.query.status || '')
const orderId = computed(() => route.query.order_id || null)
const isSuccess = computed(() => status.value === 'succeeded')
</script>

<style scoped>
.status-page {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 80vh;
  padding: 32px;
  background: var(--bg);
}

.status-card {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  max-width: 360px;
  width: 100%;
}

.status-icon {
  width: 96px;
  height: 96px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 48px;
  margin-bottom: 24px;
}

.status-icon.success {
  background: rgba(200, 164, 92, 0.15);
  color: var(--gold);
}

.status-icon.cancel {
  background: rgba(231, 76, 60, 0.15);
  color: #e74c3c;
}

.status-title {
  font-family: var(--serif);
  font-size: 24px;
  color: var(--cream);
  font-weight: 600;
  margin-bottom: 12px;
}

.status-subtitle {
  font-size: 14px;
  color: var(--cream);
  opacity: 0.6;
  line-height: 1.5;
  margin-bottom: 8px;
}

.order-badge {
  display: inline-block;
  margin-top: 12px;
  padding: 10px 16px;
  background: var(--surface);
  border: 1px solid rgba(200, 164, 92, 0.2);
  border-radius: 8px;
  font-size: 13px;
  color: var(--gold);
  margin-bottom: 40px;
}

.btn-shop {
  width: 100%;
  height: 52px;
  font-size: 16px;
  font-weight: 600;
  display: flex;
  align-items: center;
  justify-content: center;
}

.btn-gold {
  background: transparent;
  border: 1px solid var(--gold);
  color: var(--gold);
  padding: 12px 24px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  transition: all 0.2s;
  cursor: pointer;
}

.btn-gold:hover {
  background: var(--gold);
  color: var(--bg);
}

.btn-full { width: 100%; }
</style>
