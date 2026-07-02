<template>
  <div class="pd-wrap">
    <div v-if="!product" class="pd-loading"><div class="spinner"></div></div>

    <template v-else>
      <!-- AppBar -->
      <div class="pd-appbar">
        <button class="pd-bar-btn" @click="router.back()">←</button>
        <div class="pd-bar-right">
          <button class="pd-bar-btn" @click="share">↗</button>
          <button class="pd-bar-btn" @click="fav.toggle(product.id)">
            {{ fav.isFav(product.id) ? '♥' : '♡' }}
          </button>
        </div>
      </div>

      <!-- Image Gallery -->
      <div class="pd-gallery">
        <div class="pd-main-img">
          <img v-if="product.images?.[carouselIdx]" :src="product.images[carouselIdx]" :alt="product.name" />
          <div v-else class="no-img">✦</div>
        </div>
        <div v-if="(product.images?.length || 0) > 1" class="pd-thumbs">
          <img v-for="(img, i) in product.images" :key="i"
            :src="img" :class="['pd-thumb', { active: i === carouselIdx }]"
            @click="carouselIdx = i" :alt="'view ' + i" />
        </div>
      </div>

      <!-- Body -->
      <div class="pd-body">
        <!-- Category badge -->
        <span class="pd-cat">{{ product.category }}</span>

        <!-- Name -->
        <h1 class="pd-name">{{ product.name }}</h1>

        <!-- Rating (only if real data) -->
        <div v-if="product.rating" class="pd-rating-row">
          <span class="pd-stars">
            <span v-for="n in 5" :key="n" class="star" :class="{ filled: n <= Math.round(product.rating) }">★</span>
          </span>
          <span class="pd-rating-text">{{ product.rating }} ({{ product.review_count || 0 }} reviews)</span>
        </div>

        <!-- Price -->
        <p class="pd-price">{{ formatPrice(product.price_cents) }}</p>

        <!-- Tags as chips -->
        <div class="pd-chips" v-if="product.tags?.length">
          <span v-for="c in product.tags" :key="c" class="pd-chip">{{ c }}</span>
        </div>

        <!-- Description -->
        <p class="pd-desc">{{ product.description }}</p>

        <!-- Material Specs -->
        <div v-if="specs.length" class="pd-specs">
          <h3 class="pd-section-title">Specifications</h3>
          <div class="pd-spec-row" v-for="s in specs" :key="s.label">
            <span class="pd-spec-label">{{ s.label }}</span>
            <span class="pd-spec-value">{{ s.value }}</span>
          </div>
        </div>

        <!-- Quantity Selector + Cart / Buy -->
        <div class="pd-cart-row">
          <div class="pd-qty">
            <button class="pd-qty-btn" :disabled="qty <= 1" @click="qty--">−</button>
            <span class="pd-qty-val">{{ qty }}</span>
            <button class="pd-qty-btn" @click="qty++">+</button>
          </div>
          <button class="pd-add-btn" @click="addToCart">
            {{ t('product.addToCart') }} — {{ formatPrice(product.price_cents * qty) }}
          </button>
          <button class="pd-buy-btn" @click="buyNow">
            {{ t('product.buyItNow') }}
          </button>
        </div>

        <!-- Share -->
        <div class="pd-share">
          <span class="pd-share-label">Share:</span>
          <button class="pd-share-btn" @click="share">🔗 Copy Link</button>
        </div>

        <!-- Related Products (only if from backend) -->
        <div class="pd-section" v-if="related.length">
          <h3 class="pd-section-title">{{ t('product.youMayAlsoLike') }}</h3>
          <div class="pd-related-scroll">
            <div v-for="p in related" :key="p.id"
              class="pd-related-card" @click="$router.push('/products/' + p.id)">
              <div class="pd-related-img">
                <img v-if="p.images?.[0]" :src="p.images[0]" :alt="p.name" />
                <div v-else class="no-img">✦</div>
              </div>
              <div class="pd-related-body">
                <span class="pd-related-name">{{ p.name }}</span>
                <span class="pd-related-price">{{ formatPrice(p.price_cents) }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Snackbar -->
      <Transition name="snack">
        <div v-if="showSnack" class="pd-snackbar">Added to cart ✦</div>
      </Transition>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useI18n } from '../composables/useI18n'
import { useCartStore } from '../stores/cart'
import { useFavoriteStore } from '../stores/favorites'
import { getProduct } from '../api'

const { t } = useI18n()
const route = useRoute()
const router = useRouter()
const cart = useCartStore()
const fav = useFavoriteStore()

const product = ref(null)
const qty = ref(1)
const carouselIdx = ref(0)
const showSnack = ref(false)
const related = ref([])
let snackTimer = null

const specs = computed(() => {
  const p = product.value
  if (!p?.materials) return []
  const m = typeof p.materials === 'string' ? tryParseObj(p.materials) : p.materials
  if (!m || typeof m !== 'object') return []
  const labelMap = {
    main_stone: 'Main Stone', accent_stone: 'Accent Stone',
    bead_size: 'Bead Size', string_type: 'String Type',
    origin: 'Origin', composition: 'Composition',
    accent: 'Accent', fragrance: 'Fragrance'
  }
  return Object.entries(m)
    .filter(([k, v]) => v && labelMap[k])
    .map(([k, v]) => ({ label: labelMap[k], value: v }))
})

function tryParseObj(s) {
  try { return JSON.parse(s) } catch { return null }
}

function formatPrice(cents) {
  return '$' + (cents / 100).toFixed(2)
}

function share() {
  const url = window.location.href
  if (navigator.share) {
    navigator.share({ title: product.value.name, url })
  } else {
    navigator.clipboard?.writeText(url)
    showSnackbar('Link copied')
  }
}

function showSnackbar(msg) {
  showSnack.value = true
  clearTimeout(snackTimer)
  snackTimer = setTimeout(() => { showSnack.value = false }, 2000)
}

function addToCart() {
  for (let i = 0; i < qty.value; i++) {
    cart.addItem({
      id: product.value.id,
      name: product.value.name,
      price_cents: product.value.price_cents,
      images: product.value.images
    })
  }
  qty.value = 1
  showSnackbar('Added to cart')
}

function buyNow() {
  cart.clear()
  for (let i = 0; i < qty.value; i++) {
    cart.addItem({
      id: product.value.id,
      name: product.value.name,
      price_cents: product.value.price_cents,
      images: product.value.images
    })
  }
  router.push('/order')
}

onMounted(async () => {
  try {
    const res = await getProduct(route.params.id)
    const data = res.data || res
    product.value = data
    related.value = data.related || []
  } catch (e) {
    router.push('/products')
  }
})
</script>

<style scoped>
.pd-wrap { background: #0A0A0A; min-height: 100vh; padding-bottom: 40px; }
.pd-loading { display: flex; justify-content: center; padding-top: 120px; }

/* AppBar */
.pd-appbar {
  position: sticky; top: 0; z-index: 50;
  display: flex; justify-content: space-between; align-items: center;
  padding: 12px 16px; background: rgba(10,10,10,0.85); backdrop-filter: blur(10px);
}
.pd-bar-right { display: flex; gap: 8px; }
.pd-bar-btn {
  width: 36px; height: 36px; border-radius: 50%;
  border: 1px solid rgba(200,164,92,0.4); background: rgba(10,10,10,0.6);
  color: #C8A45C; font-size: 18px; display: flex; align-items: center;
  justify-content: center; cursor: pointer; transition: background .2s; line-height: 1;
}
.pd-bar-btn:hover { background: rgba(200,164,92,0.15); }

/* Gallery */
.pd-gallery { background: #1A1A1A; }
.pd-main-img { height: 360px; display: flex; align-items: center; justify-content: center; }
.pd-main-img img { width: 100%; height: 100%; object-fit: cover; }
.pd-thumbs { display: flex; gap: 8px; padding: 10px 16px 14px; overflow-x: auto; }
.pd-thumb { width: 56px; height: 56px; border-radius: 8px; object-fit: cover; cursor: pointer; opacity: 0.5; border: 2px solid transparent; transition: all .2s; flex-shrink: 0; }
.pd-thumb.active { opacity: 1; border-color: #C8A45C; }
.pd-thumb:hover { opacity: 0.8; }

/* Body */
.pd-body { padding: 20px 20px 40px; }

/* Category badge */
.pd-cat { display: inline-block; padding: 4px 10px; border-radius: 4px; background: rgba(200,164,92,0.1); color: #C8A45C; font-size: 11px; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 10px; }

/* Name */
.pd-name { font-family: 'Georgia', serif; font-size: 26px; color: #F5F0E8; margin-bottom: 8px; font-weight: 500; line-height: 1.3; }

/* Rating */
.pd-rating-row { display: flex; align-items: center; gap: 8px; margin-bottom: 12px; }
.pd-stars { display: flex; gap: 2px; }
.star { font-size: 16px; color: rgba(245,240,232,0.2); }
.star.filled { color: #C8A45C; }
.pd-rating-text { font-size: 13px; color: #F5F0E8; opacity: 0.6; }

/* Price */
.pd-price { font-size: 24px; color: #C8A45C; font-weight: 700; margin-bottom: 16px; letter-spacing: 0.5px; }

/* Chips */
.pd-chips { display: flex; gap: 8px; flex-wrap: wrap; margin-bottom: 16px; }
.pd-chip { padding: 6px 14px; border-radius: 20px; font-size: 12px; color: #C8A45C; border: 1px solid rgba(200,164,92,0.3); background: rgba(200,164,92,0.06); white-space: nowrap; }

/* Description */
.pd-desc { font-size: 14px; color: #F5F0E8; opacity: 0.6; line-height: 1.6; margin-bottom: 20px; font-family: 'Helvetica', 'Arial', sans-serif; }

/* Specs table */
.pd-specs { border: 1px solid rgba(200,164,92,0.15); border-radius: 12px; overflow: hidden; margin-bottom: 20px; }
.pd-specs .pd-section-title { padding: 14px 16px 8px; margin: 0; }
.pd-spec-row { display: flex; justify-content: space-between; padding: 10px 16px; border-top: 1px solid rgba(200,164,92,0.08); }
.pd-spec-label { font-size: 13px; color: #F5F0E8; opacity: 0.5; }
.pd-spec-value { font-size: 13px; color: #F5F0E8; text-align: right; max-width: 60%; }

/* Cart Row */
.pd-cart-row { display: flex; gap: 8px; align-items: center; margin-bottom: 20px; }

.pd-qty { display: flex; align-items: center; border: 1px solid rgba(200,164,92,0.3); border-radius: 12px; overflow: hidden; background: #1A1A1A; flex-shrink: 0; }
.pd-qty-btn { width: 40px; height: 40px; border: none; background: transparent; color: #C8A45C; font-size: 18px; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: background .15s; line-height: 1; }
.pd-qty-btn:hover { background: rgba(200,164,92,0.1); }
.pd-qty-btn:disabled { opacity: 0.3; cursor: default; }
.pd-qty-val { min-width: 36px; text-align: center; color: #F5F0E8; font-size: 16px; font-weight: 600; }

.pd-add-btn { flex: 1; height: 40px; border: 1px solid #C8A45C; border-radius: 12px; background: #C8A45C; color: #0A0A0A; font-size: 13px; font-weight: 700; cursor: pointer; letter-spacing: 0.5px; transition: all .2s; white-space: nowrap; }
.pd-add-btn:hover { background: #D4B06A; }
.pd-buy-btn { height: 40px; border: 1px solid rgba(200,164,92,0.4); border-radius: 12px; background: transparent; color: #C8A45C; font-size: 13px; font-weight: 600; cursor: pointer; padding: 0 14px; white-space: nowrap; transition: all .2s; }
.pd-buy-btn:hover { background: rgba(200,164,92,0.1); }

/* Share */
.pd-share { display: flex; align-items: center; gap: 10px; margin-bottom: 24px; padding: 16px; background: #1A1A1A; border-radius: 12px; border: 1px solid rgba(200,164,92,0.1); }
.pd-share-label { font-size: 13px; color: #F5F0E8; opacity: 0.5; }
.pd-share-btn { padding: 6px 14px; border-radius: 8px; border: 1px solid rgba(200,164,92,0.3); background: transparent; color: #C8A45C; font-size: 12px; cursor: pointer; transition: all .2s; }
.pd-share-btn:hover { background: rgba(200,164,92,0.1); }

/* Section */
.pd-section { margin-bottom: 24px; }
.pd-section-title { font-family: 'Georgia', serif; font-size: 18px; color: #C8A45C; margin-bottom: 12px; letter-spacing: 1px; }

/* Related */
.pd-related-scroll { display: flex; gap: 12px; overflow-x: auto; padding-bottom: 4px; }
.pd-related-scroll::-webkit-scrollbar { display: none; }
.pd-related-card { min-width: 150px; max-width: 150px; background: #1A1A1A; border-radius: 12px; overflow: hidden; border: 1px solid rgba(200,164,92,0.1); cursor: pointer; transition: transform .2s; flex-shrink: 0; }
.pd-related-card:hover { transform: translateY(-4px); border-color: rgba(200,164,92,0.3); }
.pd-related-img { height: 150px; background: #222; overflow: hidden; }
.pd-related-img img { width: 100%; height: 100%; object-fit: cover; }
.pd-related-img .no-img { display: flex; align-items: center; justify-content: center; height: 100%; color: #C8A45C; opacity: 0.3; font-size: 28px; }
.pd-related-body { padding: 8px 10px 10px; display: flex; flex-direction: column; gap: 2px; }
.pd-related-name { font-family: 'Georgia', serif; font-size: 13px; color: #F5F0E8; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.pd-related-price { font-size: 14px; color: #C8A45C; font-weight: 700; }

/* Snackbar */
.pd-snackbar { position: fixed; bottom: 24px; left: 50%; transform: translateX(-50%); background: #C8A45C; color: #0A0A0A; padding: 10px 24px; border-radius: 8px; font-size: 14px; font-weight: 600; z-index: 200; box-shadow: 0 4px 20px rgba(200,164,92,0.3); }
.snack-enter-active, .snack-leave-active { transition: all .3s ease; }
.snack-enter-from, .snack-leave-to { opacity: 0; transform: translateX(-50%) translateY(20px); }
</style>
