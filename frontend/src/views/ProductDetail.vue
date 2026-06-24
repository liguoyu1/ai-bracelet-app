<template>
  <div class="pd-wrap">
    <!-- Loading -->
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

      <!-- Image Carousel -->
      <div class="pd-carousel-wrap">
        <div class="pd-carousel" ref="carouselRef">
          <div
            v-for="(img, i) in product.images"
            :key="i"
            class="pd-carousel-slide"
            :class="{ active: i === carouselIdx }"
          >
            <img :src="img" :alt="product.name + ' ' + i" />
          </div>
        </div>
        <div v-if="(product.images?.length || 1) > 1" class="pd-carousel-controls">
          <button class="pd-carousel-arrow" @click="prevImg" :disabled="carouselIdx === 0">‹</button>
          <div class="pd-carousel-dots">
            <span
              v-for="(_, i) in product.images"
              :key="i"
              class="pd-dot"
              :class="{ active: i === carouselIdx }"
              @click="carouselIdx = i"
            ></span>
          </div>
          <button
            class="pd-carousel-arrow"
            @click="nextImg"
            :disabled="carouselIdx === (product.images?.length || 1) - 1"
          >›</button>
        </div>
        <div v-else class="pd-carousel-dots solo">
          <span class="pd-dot active"></span>
        </div>
      </div>

      <!-- Body -->
      <div class="pd-body">
        <!-- Name -->
        <h1 class="pd-name">{{ product.name }}</h1>

        <!-- Rating -->
        <div class="pd-rating-row">
          <span class="pd-stars">
            <span v-for="n in 4" :key="'f'+n" class="star filled">★</span>
            <span class="star half">★</span>
            <span class="star empty">★</span>
          </span>
          <span class="pd-rating-text">4.8 (128 reviews)</span>
        </div>

        <!-- Price -->
        <p class="pd-price">{{ formatPrice(product.price_cents) }}</p>

        <!-- Chips -->
        <div class="pd-chips" v-if="chips.length">
          <span v-for="(c, i) in chips" :key="i" class="pd-chip">{{ c }}</span>
        </div>

        <!-- Description -->
        <p class="pd-desc">{{ product.description || 'Handcrafted with precision, each bead is selected for its unique energy properties.' }}</p>

        <!-- Quantity Selector + Add to Cart -->
        <div class="pd-cart-row">
          <div class="pd-qty">
            <button class="pd-qty-btn" :disabled="qty <= 1" @click="qty--">−</button>
            <span class="pd-qty-val">{{ qty }}</span>
            <button class="pd-qty-btn" @click="qty++">+</button>
          </div>
          <button class="pd-add-btn" @click="addToCart">
            {{ t('product.addToCart') || 'Add to Cart' }} — {{ formatPrice(product.price_cents * qty) }}
          </button>
        </div>

        <!-- Designer Info -->
        <div class="pd-designer" v-if="product.designer">
          <div class="pd-designer-avatar">{{ (product.designer.name || 'A')[0] }}</div>
          <div class="pd-designer-info">
            <span class="pd-designer-label">{{ t('products.designedBy') }}</span>
            <span class="pd-designer-name">{{ product.designer.name }}</span>
            <span class="pd-designer-royalty">2% of sale goes to designer</span>
          </div>
        </div>

        <!-- Reviews -->
        <div class="pd-section" v-if="reviews.length">
          <h3 class="pd-section-title">{{ t('product.reviews') || 'Reviews' }}</h3>
          <div
            v-for="(r, i) in reviews"
            :key="i"
            class="pd-review-card"
          >
            <div class="pd-review-header">
              <span class="pd-review-name">{{ r.name || 'Anonymous' }}</span>
              <span class="pd-review-stars">
                <span v-for="n in 5" :key="n" class="star" :class="{ filled: n <= r.rating }">★</span>
              </span>
            </div>
            <p class="pd-review-text">{{ r.text }}</p>
          </div>
        </div>

        <!-- You May Also Like -->
        <div class="pd-section" v-if="related.length">
          <h3 class="pd-section-title">{{ t('product.youMayAlsoLike') || 'You May Also Like' }}</h3>
          <div class="pd-related-scroll">
            <div
              v-for="p in related"
              :key="p.id"
              class="pd-related-card"
              @click="$router.push('/products/' + p.id)"
            >
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
const reviews = ref([])
const related = ref([])
let snackTimer = null

const chips = computed(() => {
  const names = []
  if (product.value?.materials) {
    const m = product.value.materials
    if (typeof m === 'object') {
      Object.values(m).forEach(v => { if (v && !names.includes(v)) names.push(v) })
    } else if (typeof m === 'string') {
      m.split(',').forEach(s => { const x = s.trim(); if (x && !names.includes(x)) names.push(x) })
    }
  }
  if (product.value?.tags?.length) {
    product.value.tags.forEach(t => { if (!names.includes(t)) names.push(t) })
  }
  return names.length ? names : ['8mm Crystal', 'Round Beads', '18K Gold Clasp']
})

function formatPrice(cents) {
  return '$' + (cents / 100).toFixed(2)
}

function prevImg() {
  if (carouselIdx.value > 0) carouselIdx.value--
}

function nextImg() {
  const len = product.value?.images?.length || 1
  if (carouselIdx.value < len - 1) carouselIdx.value++
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

onMounted(async () => {
  try {
    const res = await getProduct(route.params.id)
    const data = res.data || res
    product.value = data
    reviews.value = data.reviews || []
    related.value = data.related || []
  } catch (e) {
    router.push('/products')
  }
})
</script>

<style scoped>
.pd-wrap {
  background: #0A0A0A;
  min-height: 100vh;
  padding-bottom: 40px;
}
.pd-loading {
  display: flex;
  justify-content: center;
  padding-top: 120px;
}

/* AppBar */
.pd-appbar {
  position: sticky;
  top: 0;
  z-index: 50;
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 12px 16px;
  background: rgba(10,10,10,0.85);
  backdrop-filter: blur(10px);
}
.pd-bar-right {
  display: flex;
  gap: 8px;
}
.pd-bar-btn {
  width: 36px;
  height: 36px;
  border-radius: 50%;
  border: 1px solid rgba(200,164,92,0.4);
  background: rgba(10,10,10,0.6);
  color: #C8A45C;
  font-size: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  transition: background .2s;
  line-height: 1;
}
.pd-bar-btn:hover {
  background: rgba(200,164,92,0.15);
}

/* Carousel */
.pd-carousel-wrap {
  position: relative;
  height: 350px;
  overflow: hidden;
  background: #1A1A1A;
}
.pd-carousel {
  display: flex;
  height: 100%;
  transition: transform .3s ease;
}
.pd-carousel-slide {
  min-width: 100%;
  height: 100%;
  display: flex;
  align-items: center;
  justify-content: center;
}
.pd-carousel-slide img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.pd-carousel-controls {
  position: absolute;
  bottom: 16px;
  left: 0;
  right: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 16px;
}
.pd-carousel-arrow {
  width: 32px;
  height: 32px;
  border-radius: 50%;
  border: 1px solid rgba(200,164,92,0.4);
  background: rgba(10,10,10,0.6);
  color: #C8A45C;
  font-size: 20px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background .2s;
  line-height: 1;
}
.pd-carousel-arrow:disabled {
  opacity: 0.3;
  cursor: default;
}
.pd-carousel-arrow:not(:disabled):hover {
  background: rgba(200,164,92,0.15);
}
.pd-carousel-dots {
  display: flex;
  gap: 8px;
  align-items: center;
}
.pd-carousel-dots.solo {
  position: absolute;
  bottom: 16px;
  left: 0;
  right: 0;
  justify-content: center;
}
.pd-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  background: rgba(255,255,255,0.25);
  cursor: pointer;
  transition: all .2s;
}
.pd-dot.active {
  background: #C8A45C;
  width: 24px;
  border-radius: 4px;
}

/* Body */
.pd-body {
  padding: 20px 20px 40px;
}

/* Name */
.pd-name {
  font-family: 'Georgia', 'Cormorant Garamond', serif;
  font-size: 26px;
  color: #F5F0E8;
  margin-bottom: 8px;
  font-weight: 500;
  line-height: 1.3;
}

/* Rating */
.pd-rating-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
}
.pd-stars {
  display: flex;
  gap: 2px;
}
.star {
  font-size: 16px;
  color: rgba(245,240,232,0.2);
}
.star.filled {
  color: #C8A45C;
}
.star.half {
  color: #C8A45C;
  position: relative;
}
.star.half::before {
  content: '★';
  position: absolute;
  left: 0;
  width: 50%;
  overflow: hidden;
  color: #C8A45C;
}
.pd-rating-text {
  font-size: 13px;
  color: #F5F0E8;
  opacity: 0.6;
}

/* Price */
.pd-price {
  font-size: 24px;
  color: #C8A45C;
  font-weight: 700;
  margin-bottom: 16px;
  letter-spacing: 0.5px;
}

/* Chips */
.pd-chips {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  margin-bottom: 16px;
}
.pd-chip {
  padding: 6px 14px;
  border-radius: 20px;
  font-size: 12px;
  color: #C8A45C;
  border: 1px solid rgba(200,164,92,0.3);
  background: rgba(200,164,92,0.06);
  white-space: nowrap;
}

/* Description */
.pd-desc {
  font-size: 14px;
  color: #F5F0E8;
  opacity: 0.6;
  line-height: 1.6;
  margin-bottom: 24px;
  font-family: 'Helvetica', 'Arial', 'Raleway', sans-serif;
}

/* Cart Row */
.pd-cart-row {
  display: flex;
  gap: 12px;
  align-items: center;
  margin-bottom: 24px;
}

/* Quantity */
.pd-qty {
  display: flex;
  align-items: center;
  gap: 0;
  border: 1px solid rgba(200,164,92,0.3);
  border-radius: 12px;
  overflow: hidden;
  background: #1A1A1A;
  flex-shrink: 0;
}
.pd-qty-btn {
  width: 40px;
  height: 40px;
  border: none;
  background: transparent;
  color: #C8A45C;
  font-size: 18px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: background .15s;
  line-height: 1;
}
.pd-qty-btn:hover {
  background: rgba(200,164,92,0.1);
}
.pd-qty-btn:disabled {
  opacity: 0.3;
  cursor: default;
}
.pd-qty-val {
  min-width: 36px;
  text-align: center;
  color: #F5F0E8;
  font-size: 16px;
  font-weight: 600;
}

/* Add to Cart */
.pd-add-btn {
  flex: 1;
  height: 40px;
  border: 1px solid #C8A45C;
  border-radius: 12px;
  background: #C8A45C;
  color: #0A0A0A;
  font-size: 14px;
  font-weight: 700;
  cursor: pointer;
  letter-spacing: 0.5px;
  transition: all .2s;
}
.pd-add-btn:hover {
  background: #D4B06A;
}

/* Designer */
.pd-designer {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 16px;
  background: #1A1A1A;
  border-radius: 12px;
  border: 1px solid rgba(200,164,92,0.1);
  margin-bottom: 24px;
}
.pd-designer-avatar {
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background: #C8A45C;
  color: #0A0A0A;
  font-weight: 700;
  font-size: 18px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  font-family: 'Georgia', serif;
}
.pd-designer-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.pd-designer-label {
  font-size: 11px;
  color: #F5F0E8;
  opacity: 0.4;
  text-transform: uppercase;
  letter-spacing: 1px;
}
.pd-designer-name {
  font-size: 14px;
  color: #F5F0E8;
  font-weight: 600;
}
.pd-designer-royalty {
  font-size: 12px;
  color: #C8A45C;
  opacity: 0.7;
}

/* Section */
.pd-section {
  margin-bottom: 24px;
}
.pd-section-title {
  font-family: 'Georgia', 'Cormorant Garamond', serif;
  font-size: 20px;
  color: #C8A45C;
  margin-bottom: 12px;
  letter-spacing: 1px;
}

/* Review Cards */
.pd-review-card {
  padding: 14px 16px;
  background: #1A1A1A;
  border-radius: 12px;
  border: 1px solid rgba(200,164,92,0.1);
  margin-bottom: 10px;
}
.pd-review-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 6px;
}
.pd-review-name {
  font-size: 13px;
  color: #F5F0E8;
  font-weight: 600;
}
.pd-review-stars {
  display: flex;
  gap: 1px;
}
.pd-review-stars .star {
  font-size: 13px;
  color: rgba(245,240,232,0.2);
}
.pd-review-stars .star.filled {
  color: #C8A45C;
}
.pd-review-text {
  font-size: 13px;
  color: #F5F0E8;
  opacity: 0.65;
  line-height: 1.5;
}

/* Related Products Horizontal Scroll */
.pd-related-scroll {
  display: flex;
  gap: 12px;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  padding-bottom: 4px;
}
.pd-related-scroll::-webkit-scrollbar {
  display: none;
}
.pd-related-card {
  min-width: 150px;
  max-width: 150px;
  background: #1A1A1A;
  border-radius: 12px;
  overflow: hidden;
  border: 1px solid rgba(200,164,92,0.1);
  cursor: pointer;
  transition: transform .2s, border-color .2s;
  flex-shrink: 0;
}
.pd-related-card:hover {
  transform: translateY(-4px);
  border-color: rgba(200,164,92,0.3);
}
.pd-related-img {
  height: 150px;
  background: #222;
  overflow: hidden;
}
.pd-related-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.pd-related-img .no-img {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  color: #C8A45C;
  opacity: 0.3;
  font-size: 28px;
}
.pd-related-body {
  padding: 8px 10px 10px;
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.pd-related-name {
  font-family: 'Georgia', 'Cormorant Garamond', serif;
  font-size: 13px;
  color: #F5F0E8;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.pd-related-price {
  font-size: 14px;
  color: #C8A45C;
  font-weight: 700;
}

/* Snackbar */
.pd-snackbar {
  position: fixed;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  background: #C8A45C;
  color: #0A0A0A;
  padding: 10px 24px;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 600;
  z-index: 200;
  box-shadow: 0 4px 20px rgba(200,164,92,0.3);
}
.snack-enter-active,
.snack-leave-active {
  transition: all .3s ease;
}
.snack-enter-from,
.snack-leave-to {
  opacity: 0;
  transform: translateX(-50%) translateY(20px);
}
</style>
