<template>
  <div class="designs-page">
    <div class="page-header">
      <h1 class="page-title">Community Designs</h1>
      <p class="page-sub">Original bracelet designs by our community — support creators & earn commission</p>
    </div>

    <!-- States -->
    <div v-if="loading" class="loading-state"><div class="spinner"></div></div>
    <div v-else-if="error" class="error-state">{{ error }}</div>
    <div v-else-if="!designs.length" class="empty-state">
      <span class="empty-icon">✦</span>
      <p>No community designs yet</p>
      <p class="empty-sub">Be the first — create and publish your design!</p>
      <router-link to="/designer" class="btn-gold">Create Your Design</router-link>
    </div>

    <!-- Design grid -->
    <div v-else class="design-grid">
      <div
        v-for="d in designs" :key="d.id"
        class="design-card"
        @click="$router.push('/designs/' + d.id)"
      >
        <div class="card-img">
          <!-- Preview: show first image or fallback -->
          <img v-if="d.preview_images?.[0]" :src="d.preview_images[0]" :alt="d.name" />
          <div v-else class="preview-placeholder">
            <div v-for="i in 8" :key="i" class="mock-bead" :style="beadColor(i)"></div>
          </div>
          <button class="fav-btn" :class="{active: fav.isFav(d.id)}"
            @click.stop="fav.toggle(d.id)" aria-label="Favorite">♥</button>
        </div>
        <div class="card-body">
          <div class="card-designer">
            <span class="designer-avatar">{{ (d.designer_name || 'D')[0] }}</span>
            <span class="designer-name">{{ d.designer_name || 'Anonymous' }}</span>
          </div>
          <h3 class="card-name">{{ d.name }}</h3>
          <p class="card-price">{{ formatPrice(d.price_cents) }}</p>
          <button class="btn-buy-now" @click.stop="buyDesign(d)">
            Buy Now — {{ formatPrice(d.price_cents) }}
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from '../composables/useI18n'
import { useFavoriteStore } from '../stores/favorites'
import { useCartStore } from '../stores/cart'
import api from '../api'

const { t } = useI18n()
const router = useRouter()
const fav = useFavoriteStore()
const cart = useCartStore()

const designs = ref([])
const loading = ref(true)
const error = ref(null)

function formatPrice(cents) { return '$' + (cents / 100).toFixed(2) }

function beadColor(i) {
  const colors = ['#7B2D8B','#E8E8E8','#F7C0D0','#B8860B','#1A1A1A','#F5C542','#8FBC8F','#2E5090']
  return { background: colors[i % colors.length] }
}

function buyDesign(d) {
  cart.clear()
  cart.addItem({
    id: d.id,
    name: d.name,
    price_cents: d.price_cents,
    images: d.preview_images || []
  })
  router.push('/order')
}

async function fetchDesigns() {
  try {
    const res = await api.get('/designs')
    const items = res.data || res || []
    designs.value = Array.isArray(items) ? items : items.data || []
  } catch (e) {
    error.value = 'Failed to load designs'
  }
}

onMounted(() => {
  fetchDesigns().finally(() => loading.value = false)
})
</script>

<style scoped>
.designs-page { padding-bottom: 20px; }
.page-header { padding: 20px 20px 0; }
.page-title { font-family: var(--serif); font-size: 28px; color: var(--gold); letter-spacing: 2px; }
.page-sub { font-size: 14px; opacity: 0.5; margin-top: 4px; }

.empty-state { text-align: center; padding: 80px 20px; }
.empty-icon { font-size: 48px; color: var(--gold); opacity: 0.3; display: block; margin-bottom: 16px; }
.empty-sub { font-size: 13px; opacity: 0.4; margin: 8px 0 24px; }

.design-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; padding: 16px 20px; }

.design-card {
  border-radius: 12px; overflow: hidden; background: var(--surface);
  cursor: pointer; transition: transform .2s, box-shadow .2s;
}
.design-card:hover { transform: translateY(-2px); box-shadow: 0 4px 20px rgba(0,0,0,0.3); }

.card-img { position: relative; height: 200px; background: #1A1A1A; display: flex; align-items: center; justify-content: center; overflow: hidden; }
.card-img img { width: 100%; height: 100%; object-fit: cover; }
.preview-placeholder { display: flex; gap: 4px; flex-wrap: wrap; justify-content: center; padding: 20px; }
.mock-bead { width: 28px; height: 28px; border-radius: 50%; border: 1px solid rgba(200,164,92,0.2); }

.card-body { padding: 10px 12px 12px; }
.card-designer { display: flex; align-items: center; gap: 6px; margin-bottom: 6px; }
.designer-avatar { width: 20px; height: 20px; border-radius: 50%; background: var(--gold); color: #000; font-size: 10px; font-weight: 700; display: flex; align-items: center; justify-content: center; }
.designer-name { font-size: 11px; opacity: 0.5; letter-spacing: 0.3px; }
.card-name { font-family: var(--serif); font-size: 14px; color: var(--cream); margin-bottom: 4px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.card-price { font-size: 16px; font-weight: 700; color: var(--gold); margin-bottom: 8px; }

.btn-buy-now {
  width: 100%; padding: 8px; border: 1px solid var(--gold); border-radius: 8px;
  background: transparent; color: var(--gold); font-size: 13px; font-weight: 600;
  cursor: pointer; transition: all .2s; font-family: var(--sans);
}
.btn-buy-now:hover { background: var(--gold); color: #000; }

.fav-btn {
  position: absolute; top: 8px; right: 8px; width: 32px; height: 32px;
  background: rgba(10,10,10,0.5); border-radius: 50%; display: flex;
  align-items: center; justify-content: center; font-size: 15px;
  cursor: pointer; z-index: 2; border: none; line-height: 1;
  color: rgba(255,255,255,0.5); transition: all .2s;
}
.fav-btn.active { color: #e53935; background: rgba(229,57,53,0.15); }
</style>
