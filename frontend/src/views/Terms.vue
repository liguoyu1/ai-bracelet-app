<template>
  <div class="page terms-page">
    <div class="terms-header">
      <h1>{{ t('terms.title') || 'Terms of Service' }}</h1>
      <button class="back-link" @click="$router.back()">{{ t('common.back') || 'Back' }}</button>
    </div>

    <section>
      <h2>{{ t('terms.copyright') || 'Design Copyright & License' }}</h2>
      <p>
        {{ t('terms.copyrightP1') || 'When you publish a design on AURA, you retain full copyright ownership of your original design. You grant AURA a non-exclusive, worldwide, royalty-bearing license to manufacture, sell, and reproduce the design on your behalf.' }}
      </p>
      <p>
        {{ t('terms.copyrightP2') || 'The commission you earn on each sale (currently 2% of the sale price) constitutes the license fee for this usage. By publishing, you acknowledge this arrangement.' }}
      </p>
    </section>

    <section>
      <h2>{{ t('terms.commission') || 'Commission Structure' }}</h2>
      <p>{{ t('terms.commissionP1') || 'Designers earn a commission on each sale of their published designs. The current commission rate is 2% of the total order amount. Commission rates may be adjusted in the future with notice.' }}</p>
      <p>{{ t('terms.commissionP2') || 'Commissions are credited to your account as "pending" when an order is paid and become available for withdrawal according to the platform\'s payout schedule.' }}</p>
    </section>

    <section>
      <h2>{{ t('terms.platform') || 'Platform Responsibilities' }}</h2>
      <p>{{ t('terms.platformP1') || 'AURA handles order fulfillment, payment processing, shipping, customer service, and returns for all designs. The platform ensures quality control and handles any disputes related to manufacturing defects.' }}</p>
    </section>

    <section>
      <h2>{{ t('terms.user') || 'User Responsibilities' }}</h2>
      <p>{{ t('terms.userP1') || 'You agree not to submit designs that infringe on third-party intellectual property rights, contain prohibited content, or violate applicable laws. You are responsible for the originality of your designs.' }}</p>
    </section>

    <p class="terms-footer">{{ t('terms.footer') || 'Last updated: June 2026' }}</p>
  </div>
</template>

<script setup>
import { useI18n } from '../composables/useI18n'
const { t } = useI18n()
</script>

<style scoped>
.terms-page { max-width: 720px; margin: 0 auto; padding: 20px 16px 80px; }
.terms-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; }
.terms-header h1 { font-size: 22px; color: #F5F0E8; margin: 0; }
.back-link { background: none; border: 1px solid #333; color: #999; padding: 6px 14px; border-radius: 6px; cursor: pointer; font-size: 13px; }
.back-link:hover { border-color: #C8A45C; color: #C8A45C; }
section { margin-bottom: 28px; }
section h2 { font-size: 17px; color: #C8A45C; margin-bottom: 10px; }
section p { font-size: 14px; line-height: 1.7; color: #BBB; margin: 0 0 8px; }
.terms-footer { text-align: center; color: #666; font-size: 12px; margin-top: 32px; }
</style>
