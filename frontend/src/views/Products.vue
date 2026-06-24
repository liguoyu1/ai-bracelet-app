<template>
  <div class="products-page">
    <div class="page-header">
      <h1 class="page-title">{{ t('products.title') }}</h1>
      <p class="page-sub">{{ t('products.subtitle') }}</p>
    </div>

    <!-- Search bar -->
    <div class="search-bar-wrapper">
      <div class="search-bar">
        <svg class="search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="11" cy="11" r="8"/><path d="m21 21-4.35-4.35"/></svg>
        <input
          v-model="searchText"
          type="text"
          class="search-input"
          :placeholder="t('products.search')"
          @input="onSearchInput"
        />
        <button v-if="searchText" class="search-clear" @click="clearSearch" aria-label="Clear search">✕</button>
      </div>
    </div>

    <!-- Filter chips -->
    <div class="filter-bar">
      <button
        v-for="f in filters" :key="f.key"
        :class="['filter-chip', { active: activeFilter === f.key }]"
        @click="setFilter(f.key)"
      >{{ f.label }}</button>
    </div>

    <!-- States -->
    <div v-if="loading" class="loading-state"><div class="spinner"></div></div>
    <div v-else-if="error" class="error-state">{{ error }}</div>
    <div v-else-if="!products.length" class="empty-state">{{ t('products.empty') }}</div>

    <!-- Product grid -->
    <div v-else class="product-grid">
      <div
        v-for="p in products" :key="p.id"
        class="product-card"
        @click="$router.push('/products/' + p.id)"
      >
        <div class="card-img">
          <img v-if="p.images?.[0]" :src="p.images[0]" :alt="p.name" @error="e => e.target.style.display='none'" />
          <div v-else class="no-img">✦</div>
          <!-- Favorite heart -->
          <button
            class="fav-btn"
            :class="{ active: fav.isFav(p.id) }"
            @click.stop="fav.toggle(p.id)"
            aria-label="Toggle favorite"
          >♥</button>
          <!-- Hover overlay: Add to Cart -->
          <div class="hover-overlay" @click.stop>
            <button class="btn-add-cart" @click="cart.addItem(p)">{{ t('products.addToCart') }}</button>
          </div>
        </div>
        <div class="card-body">
          <h3 class="card-name">{{ p.name }}</h3>
          <p class="card-tags">{{ p.tags?.join(', ') }}</p>
          <p class="card-price">{{ formatPrice(p.price_cents) }}</p>
        </div>
      </div>
    </div>

    <!-- Load More -->
    <div v-if="hasMore" class="load-more">
      <button
        class="btn-load-more"
        :disabled="loadingMore"
        @click="loadMore"
      >
        <span v-if="loadingMore" class="spinner" style="width:18px;height:18px;border-width:2px"></span>
        <span v-else>{{ t('products.loadMore') }} ({{ products.length }}/{{ total }})</span>
      </button>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { getProducts, getProduct } from '../api'
import { useI18n } from '../composables/useI18n'
import { useFavoriteStore } from '../stores/favorites'
import { useCartStore } from '../stores/cart'

const { t } = useI18n()
const fav = useFavoriteStore()
const cart = useCartStore()
const route = useRoute()
const router = useRouter()

const products = ref([])
const loading = ref(true)
const loadingMore = ref(false)
const error = ref(null)
const page = ref(1)
const total = ref(0)
const activeFilter = ref(route.query.cat || '')
const searchText = ref(route.query.search || '')
let searchTimer = null

const filters = [
  { key: '', label: t('products.all') },
  { key: 'crystal', label: 'Crystal' },
  { key: 'jade', label: 'Jade' },
  { key: 'amber', label: 'Amber' },
  { key: 'lava', label: 'Lava' },
]

const hasMore = computed(() => products.value.length < total.value)

function formatPrice(cents) {
  return '$' + (cents / 100).toFixed(2)
}

async function fetchProducts(p, append) {
  try {
    const params = { page: p, limit: 20 }
    if (activeFilter.value) params.category = activeFilter.value
    if (searchText.value) params.search = searchText.value
    const res = await getProducts(params)
    const items = res.data || []
    if (append) products.value.push(...items)
    else products.value = items
    total.value = res.total || items.length
  } catch (e) {
    error.value = 'Failed to load products'
  }
}

function setFilter(key) {
  activeFilter.value = key
  page.value = 1
  loading.value = true
  router.replace({ query: { ...route.query, cat: key || undefined } })
  fetchProducts(1).finally(() => loading.value = false)
}

async function loadMore() {
  loadingMore.value = true
  page.value++
  await fetchProducts(page.value, true)
  loadingMore.value = false
}

function onSearchInput() {
  clearTimeout(searchTimer)
  searchTimer = setTimeout(() => {
    page.value = 1
    loading.value = true
    router.replace({ query: { ...route.query, search: searchText.value || undefined } })
    fetchProducts(1).finally(() => loading.value = false)
  }, 300)
}

function clearSearch() {
  searchText.value = ''
  page.value = 1
  loading.value = true
  router.replace({ query: { ...route.query, search: undefined } })
  fetchProducts(1).finally(() => loading.value = false)
}

watch(activeFilter, (val) => {
  // sync query param
})

onMounted(() => {
  fetchProducts(1).finally(() => loading.value = false)
})
</script>

<style scoped>
.products-page {
  padding-bottom: 20px;
}

/* Header */
.page-header {
  padding: 20px 20px 0;
}
.page-title {
  font-family: var(--serif);
  font-size: 28px;
  color: var(--gold);
  letter-spacing: 2px;
}
.page-sub {
  font-size: 14px;
  opacity: 0.5;
  margin-top: 4px;
}

/* Search bar */
.search-bar-wrapper {
  padding: 16px 20px 0;
}
.search-bar {
  display: flex;
  align-items: center;
  gap: 10px;
  background: #1A1A1A;
  border: 1px solid transparent;
  border-radius: 24px;
  padding: 0 16px;
  height: 44px;
  transition: border-color 0.2s;
}
.search-bar:focus-within {
  border-color: var(--gold);
}
.search-icon {
  flex-shrink: 0;
  color: rgba(255,255,255,0.4);
}
.search-input {
  flex: 1;
  background: transparent;
  border: none;
  outline: none;
  color: var(--cream);
  font-size: 15px;
  font-family: var(--sans);
}
.search-input::placeholder {
  color: rgba(255,255,255,0.3);
}
.search-clear {
  flex-shrink: 0;
  background: none;
  border: none;
  color: rgba(255,255,255,0.4);
  font-size: 14px;
  cursor: pointer;
  padding: 4px;
  line-height: 1;
}
.search-clear:hover {
  color: var(--gold);
}

/* Filter chips */
.filter-bar {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
  padding: 16px 20px;
}
.filter-chip {
  padding: 6px 16px;
  border-radius: 20px;
  font-size: 13px;
  background: var(--surface);
  color: var(--cream);
  border: 1px solid rgba(200,164,92,0.15);
  transition: all 0.2s;
  cursor: pointer;
  font-family: var(--sans);
}
.filter-chip.active {
  border-color: var(--gold);
  color: var(--gold);
  font-weight: 600;
}
.filter-chip:hover {
  border-color: var(--gold);
}

/* Loading / Error / Empty */
.loading-state,
.error-state,
.empty-state {
  text-align: center;
  padding: 60px 20px;
  color: rgba(255,255,255,0.5);
}

/* Product grid: 2 cols, gap 12px */
.product-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  padding: 0 20px;
}

/* Product card */
.product-card {
  border-radius: 12px;
  overflow: hidden;
  background: var(--surface);
  cursor: pointer;
  transition: transform 0.2s, box-shadow 0.2s;
}
.product-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 20px rgba(0,0,0,0.3);
}

.card-img {
  position: relative;
  width: 100%;
  height: 180px;
  overflow: hidden;
  background: #1A1A1A;
  display: flex;
  align-items: center;
  justify-content: center;
}
.card-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
.no-img {
  font-size: 32px;
  color: rgba(255,255,255,0.15);
}

/* Favorite heart: top-right circle */
.fav-btn {
  position: absolute;
  top: 8px;
  right: 8px;
  width: 34px;
  height: 34px;
  border-radius: 50%;
  background: rgba(0,0,0,0.5);
  border: none;
  color: rgba(255,255,255,0.5);
  font-size: 16px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s;
  z-index: 2;
  line-height: 1;
}
.fav-btn.active {
  color: #e53935;
  background: rgba(229,57,53,0.15);
}
.fav-btn:hover {
  transform: scale(1.1);
}

/* Hover overlay: Add to Cart */
.hover-overlay {
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  background: linear-gradient(transparent, rgba(0,0,0,0.7));
  padding: 12px;
  opacity: 0;
  transition: opacity 0.25s;
  display: flex;
  justify-content: center;
  z-index: 2;
}
.product-card:hover .hover-overlay {
  opacity: 1;
}
.btn-add-cart {
  padding: 8px 20px;
  border: 1px solid var(--gold);
  border-radius: 20px;
  background: transparent;
  color: var(--gold);
  font-size: 13px;
  font-family: var(--sans);
  cursor: pointer;
  transition: all 0.2s;
  font-weight: 500;
}
.btn-add-cart:hover {
  background: var(--gold);
  color: #000;
}

/* Card body */
.card-body {
  padding: 10px 12px 12px;
}
.card-name {
  font-family: var(--serif);
  font-size: 15px;
  color: #F5F0E8;
  margin: 0 0 4px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.card-tags {
  font-size: 12px;
  color: rgba(255,255,255,0.4);
  margin: 0 0 6px;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.card-price {
  font-size: 16px;
  font-weight: 700;
  color: var(--gold);
  margin: 0;
}

/* Load More */
.load-more {
  text-align: center;
  padding: 20px 0 40px;
}
.btn-load-more {
  padding: 10px 32px;
  border: 1px solid var(--gold);
  border-radius: 24px;
  background: transparent;
  color: var(--gold);
  font-size: 14px;
  font-family: var(--sans);
  cursor: pointer;
  transition: all 0.2s;
  display: inline-flex;
  align-items: center;
  gap: 8px;
}
.btn-load-more:hover:not(:disabled) {
  background: var(--gold);
  color: #000;
}
.btn-load-more:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

/* Spinner */
.spinner {
  width: 24px;
  height: 24px;
  border: 3px solid rgba(200,164,92,0.2);
  border-top-color: var(--gold);
  border-radius: 50%;
  animation: spin 0.7s linear infinite;
  display: inline-block;
}
@keyframes spin {
  to { transform: rotate(360deg); }
}
</style>
