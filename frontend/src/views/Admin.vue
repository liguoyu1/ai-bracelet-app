<template>
  <div class="page admin-page">
    <div v-if="!auth.isLoggedIn" class="not-admin">
      <p>{{ t('admin.signInRequired') || 'Please sign in' }}</p>
      <router-link to="/login" class="btn-gold">{{ t('admin.signIn') || 'Sign In' }}</router-link>
    </div>

    <div v-else-if="!isAdmin" class="not-admin">
      <p>{{ t('admin.accessDenied') || 'Admin access required' }}</p>
    </div>

    <template v-else>
      <!-- AppBar -->
      <div class="admin-appbar">
        <h1 class="appbar-title">{{ t('admin.title') || 'Admin Panel' }}</h1>
        <button class="admin-back" @click="$router.push('/profile')">{{ t('admin.back') || 'Back' }}</button>
      </div>

      <!-- Tabs -->
      <div class="admin-tabs">
        <button
          v-for="tab in tabs" :key="tab.key"
          :class="['tab-btn', { active: activeTab === tab.key }]"
          @click="switchTab(tab.key)"
        >{{ tab.label }}</button>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="loading-state"><div class="spinner"></div></div>

      <!-- Products Tab -->
      <div v-else-if="activeTab === 'products'" class="tab-content">
        <div v-if="!products.length" class="empty-state">{{ t('admin.noProducts') || 'No products' }}</div>
        <div v-else class="list">
          <div
            v-for="p in products" :key="p.id"
            class="card list-item"
            @click="openProductForm(p)"
          >
            <img v-if="p.image_url" :src="p.image_url" class="item-thumb" @error="e => e.target.style.display='none'" />
            <div v-else class="item-thumb placeholder">{{ p.name?.charAt(0) }}</div>
            <div class="item-info">
              <span class="item-name">{{ p.name }}</span>
              <span class="item-meta">{{ formatPrice(p.price_cents) }} • {{ p.stock || 0 }} in stock • {{ p.sales_count || 0 }} sold</span>
            </div>
            <svg class="item-chevron" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          </div>
        </div>
      </div>

      <!-- Elements Tab -->
      <div v-else-if="activeTab === 'elements'" class="tab-content">
        <div v-if="!elements.length" class="empty-state">{{ t('admin.noElements') || 'No elements' }}</div>
        <div v-else class="list">
          <div
            v-for="e in elements" :key="e.id"
            class="card list-item"
            @click="openElementForm(e)"
          >
            <div class="item-thumb color-circle" :style="{ background: e.color || '#C8A45C' }"></div>
            <div class="item-info">
              <span class="item-name">{{ e.name }}</span>
              <span class="item-meta">{{ e.type }} • {{ formatPrice(e.price_cents) }} • {{ e.stock || 0 }} in stock</span>
            </div>
            <svg class="item-chevron" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="9 18 15 12 9 6"/></svg>
          </div>
        </div>
      </div>

      <!-- Orders Tab -->
      <div v-else-if="activeTab === 'orders'" class="tab-content">
        <div v-if="!adminOrders.length" class="empty-state">{{ t('admin.noOrders') || 'No orders' }}</div>
        <div v-else class="list">
          <div
            v-for="o in adminOrders" :key="o.id"
            class="card list-item"
          >
            <div class="item-info">
              <span class="item-name mono">{{ o.id?.slice(0, 10) }}…</span>
              <span class="item-meta">{{ formatPrice(o.total_cents) }} • {{ formatDate(o.created_at) }}</span>
            </div>
            <span :class="['order-status-badge', o.status]">{{ o.status }}</span>
          </div>
        </div>
      </div>

      <!-- FAB -->
      <button class="fab" @click="openAddDialog">
        <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="5" x2="12" y2="19"/><line x1="5" y1="12" x2="19" y2="12"/></svg>
      </button>

      <!-- Product Form Dialog -->
      <div v-if="productFormVisible" class="dialog-overlay" @click.self="productFormVisible = false">
        <div class="dialog admin-dialog">
          <h3 class="dialog-title">{{ editingProduct ? (t('admin.editProduct') || 'Edit Product') : (t('admin.addProduct') || 'Add Product') }}</h3>
          <div class="dialog-scroll">
            <div class="dialog-field"><label>Name</label><input v-model="pf.name" type="text" /></div>
            <div class="dialog-field"><label>Slug</label><input v-model="pf.slug" type="text" /></div>
            <div class="dialog-field"><label>Price (cents)</label><input v-model.number="pf.price_cents" type="number" min="0" /></div>
            <div class="dialog-field"><label>Stock</label><input v-model.number="pf.stock" type="number" min="0" /></div>
            <div class="dialog-field"><label>Image URL</label><input v-model="pf.image_url" type="text" /></div>
            <div class="dialog-field"><label>Category</label><input v-model="pf.category" type="text" /></div>
            <div class="dialog-field"><label>Description</label><textarea v-model="pf.description" rows="3"></textarea></div>
          </div>
          <div class="dialog-actions">
            <button class="btn-cancel" @click="productFormVisible = false">{{ t('admin.cancel') || 'Cancel' }}</button>
            <button class="btn-gold" @click="saveProduct" :disabled="savingProduct">{{ t('admin.save') || 'Save' }}</button>
          </div>
        </div>
      </div>

      <!-- Element Form Dialog -->
      <div v-if="elementFormVisible" class="dialog-overlay" @click.self="elementFormVisible = false">
        <div class="dialog admin-dialog">
          <h3 class="dialog-title">{{ editingElement ? (t('admin.editElement') || 'Edit Element') : (t('admin.addElement') || 'Add Element') }}</h3>
          <div class="dialog-scroll">
            <div class="dialog-field"><label>Name</label><input v-model="ef.name" type="text" /></div>
            <div class="dialog-field">
              <label>Type</label>
              <select v-model="ef.type" class="dialog-select">
                <option value="bead">Bead</option>
                <option value="charm">Charm</option>
                <option value="pendant">Pendant</option>
                <option value="spacer">Spacer</option>
                <option value="clasp">Clasp</option>
              </select>
            </div>
            <div class="dialog-field"><label>Price (cents)</label><input v-model.number="ef.price_cents" type="number" min="0" /></div>
            <div class="dialog-field"><label>Stock</label><input v-model.number="ef.stock" type="number" min="0" /></div>
            <div class="dialog-field"><label>Image URL</label><input v-model="ef.image_url" type="text" /></div>
          </div>
          <div class="dialog-actions">
            <button class="btn-cancel" @click="elementFormVisible = false">{{ t('admin.cancel') || 'Cancel' }}</button>
            <button class="btn-gold" @click="saveElement" :disabled="savingElement">{{ t('admin.save') || 'Save' }}</button>
          </div>
        </div>
      </div>
    </template>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from '../composables/useI18n'
import { useAuthStore } from '../stores/auth'
import {
  adminGetProducts, adminCreateProduct, adminUpdateProduct,
  adminGetElements, adminCreateElement, adminUpdateElement,
  getOrders
} from '../api'

const { t } = useI18n()
const auth = useAuthStore()
const router = useRouter()

const tabs = [
  { key: 'products', label: 'Products' },
  { key: 'elements', label: 'Elements' },
  { key: 'orders', label: 'Orders' },
]

// State
const activeTab = ref('products')
const loading = ref(true)
const products = ref([])
const elements = ref([])
const adminOrders = ref([])

// Product form
const productFormVisible = ref(false)
const editingProduct = ref(null)
const savingProduct = ref(false)
const pf = ref({ name: '', slug: '', price_cents: 0, stock: 0, image_url: '', category: '', description: '' })

// Element form
const elementFormVisible = ref(false)
const editingElement = ref(null)
const savingElement = ref(false)
const ef = ref({ name: '', type: 'bead', price_cents: 0, stock: 0, image_url: '' })

// Computed
const isAdmin = computed(() => {
  return auth.user?.is_admin || auth.user?.role === 'admin' || false
})

// Helpers
function formatPrice(cents) {
  return '$' + (cents / 100).toFixed(2)
}
function formatDate(dateStr) {
  return new Date(dateStr).toLocaleDateString()
}

// Tab switching
async function switchTab(key) {
  activeTab.value = key
  loading.value = true
  if (key === 'products') await loadProducts()
  else if (key === 'elements') await loadElements()
  else if (key === 'orders') await loadAdminOrders()
  loading.value = false
}

async function loadProducts() {
  try {
    const res = await adminGetProducts()
    products.value = res.data || res || []
  } catch { products.value = [] }
}

async function loadElements() {
  try {
    const res = await adminGetElements()
    elements.value = res.data || res || []
  } catch { elements.value = [] }
}

async function loadAdminOrders() {
  try {
    const res = await getOrders()
    adminOrders.value = res.data || res || []
  } catch { adminOrders.value = [] }
}

// Product form
function openProductForm(product) {
  editingProduct.value = product
  pf.value = {
    name: product.name || '',
    slug: product.slug || '',
    price_cents: product.price_cents || 0,
    stock: product.stock || 0,
    image_url: product.image_url || '',
    category: product.category || '',
    description: product.description || '',
  }
  productFormVisible.value = true
}

function openAddDialog() {
  if (activeTab.value === 'products') {
    editingProduct.value = null
    pf.value = { name: '', slug: '', price_cents: 0, stock: 0, image_url: '', category: '', description: '' }
    productFormVisible.value = true
  } else if (activeTab.value === 'elements') {
    editingElement.value = null
    ef.value = { name: '', type: 'bead', price_cents: 0, stock: 0, image_url: '' }
    elementFormVisible.value = true
  }
}

async function saveProduct() {
  savingProduct.value = true
  try {
    if (editingProduct.value) {
      await adminUpdateProduct(editingProduct.value.id, pf.value)
    } else {
      await adminCreateProduct(pf.value)
    }
    productFormVisible.value = false
    await loadProducts()
  } catch {}
  savingProduct.value = false
}

// Element form
function openElementForm(element) {
  editingElement.value = element
  ef.value = {
    name: element.name || '',
    type: element.type || 'bead',
    price_cents: element.price_cents || 0,
    stock: element.stock || 0,
    image_url: element.image_url || '',
  }
  elementFormVisible.value = true
}

async function saveElement() {
  savingElement.value = true
  try {
    if (editingElement.value) {
      await adminUpdateElement(editingElement.value.id, ef.value)
    } else {
      await adminCreateElement(ef.value)
    }
    elementFormVisible.value = false
    await loadElements()
  } catch {}
  savingElement.value = false
}

onMounted(async () => {
  if (!auth.isLoggedIn) return
  await auth.fetchProfile()
  switchTab('products')
})
</script>

<style scoped>
.admin-page {
  min-height: 100vh;
}

.not-admin {
  text-align: center;
  padding: 100px 20px;
}
.not-admin p {
  opacity: 0.5;
  margin-bottom: 20px;
  font-size: 16px;
}

.admin-appbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid rgba(200,164,92,0.1);
}
.appbar-title {
  font-family: var(--serif);
  font-size: 20px;
  color: var(--gold);
  letter-spacing: 2px;
}
.admin-back {
  background: none;
  border: 1px solid rgba(200,164,92,0.2);
  border-radius: 8px;
  padding: 8px 16px;
  color: var(--gold);
  font-size: 13px;
  cursor: pointer;
  transition: all 0.2s;
}
.admin-back:hover {
  background: rgba(200,164,92,0.1);
}

/* Tabs */
.admin-tabs {
  display: flex;
  border-bottom: 1px solid rgba(200,164,92,0.1);
}
.tab-btn {
  flex: 1;
  padding: 14px;
  background: none;
  border: none;
  border-bottom: 2px solid transparent;
  color: rgba(255,255,255,0.4);
  font-size: 14px;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 1px;
  cursor: pointer;
  transition: all 0.2s;
}
.tab-btn.active {
  color: var(--gold);
  border-bottom-color: var(--gold);
}
.tab-btn:hover {
  color: var(--cream);
}

/* Tab Content */
.tab-content {
  padding: 12px 16px 100px;
  max-width: 600px;
  margin: 0 auto;
}

/* List */
.list {
  display: flex;
  flex-direction: column;
  gap: 8px;
}
.list-item {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 12px;
  cursor: pointer;
  transition: all 0.2s;
}
.list-item:hover {
  border-color: rgba(200,164,92,0.3);
}
.item-thumb {
  width: 44px;
  height: 44px;
  border-radius: 8px;
  object-fit: cover;
  flex-shrink: 0;
  background: var(--bg);
}
.item-thumb.placeholder {
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: var(--serif);
  color: var(--gold);
  font-size: 16px;
  background: var(--surface);
  border: 1px solid rgba(200,164,92,0.15);
}
.color-circle {
  border-radius: 50%;
  border: 1px solid rgba(255,255,255,0.1);
}
.item-info {
  flex: 1;
  min-width: 0;
  display: flex;
  flex-direction: column;
  gap: 2px;
}
.item-name {
  font-size: 14px;
  color: var(--cream);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.item-name.mono {
  font-family: monospace;
  font-size: 13px;
  opacity: 0.7;
}
.item-meta {
  font-size: 11px;
  opacity: 0.4;
}
.item-chevron {
  color: rgba(255,255,255,0.15);
  flex-shrink: 0;
}

/* Order status badge */
.order-status-badge {
  font-size: 10px;
  text-transform: uppercase;
  letter-spacing: 1px;
  padding: 3px 8px;
  border-radius: 4px;
  font-weight: 600;
  flex-shrink: 0;
}
.order-status-badge.pending { color: var(--copper); background: rgba(139,111,71,0.15); }
.order-status-badge.paid { color: #2ecc71; background: rgba(46,204,113,0.1); }
.order-status-badge.shipped { color: #2ecc71; background: rgba(46,204,113,0.1); }
.order-status-badge.delivered { color: #2ecc71; background: rgba(46,204,113,0.1); }
.order-status-badge.cancelled { color: #e53935; background: rgba(229,57,53,0.1); }

/* FAB */
.fab {
  position: fixed;
  bottom: 24px;
  right: 24px;
  width: 56px;
  height: 56px;
  border-radius: 50%;
  background: var(--gold);
  border: none;
  color: var(--bg);
  display: flex;
  align-items: center;
  justify-content: center;
  box-shadow: 0 4px 16px rgba(200,164,92,0.3);
  cursor: pointer;
  transition: all 0.2s;
  z-index: 50;
}
.fab:hover {
  transform: scale(1.05);
  box-shadow: 0 6px 24px rgba(200,164,92,0.4);
}

/* Dialog */
.dialog-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.7);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 200;
  padding: 20px;
}
.dialog {
  background: var(--surface);
  border: 1px solid rgba(200,164,92,0.2);
  border-radius: 16px;
  padding: 24px;
  width: 100%;
  max-width: 480px;
  max-height: 90vh;
  display: flex;
  flex-direction: column;
}
.admin-dialog {
  max-height: 85vh;
}
.dialog-title {
  font-family: var(--serif);
  color: var(--gold);
  font-size: 18px;
  margin-bottom: 16px;
  flex-shrink: 0;
}
.dialog-scroll {
  overflow-y: auto;
  flex: 1;
  padding-right: 4px;
}
.dialog-field {
  margin-bottom: 14px;
}
.dialog-field label {
  display: block;
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 1px;
  opacity: 0.5;
  margin-bottom: 6px;
}
.dialog-field input,
.dialog-field textarea,
.dialog-select {
  width: 100%;
}
.dialog-select {
  background: var(--bg);
  border: 1px solid rgba(200,164,92,0.2);
  border-radius: 8px;
  padding: 12px 16px;
  color: var(--cream);
  font-size: 14px;
  outline: none;
  appearance: none;
  cursor: pointer;
}
.dialog-actions {
  display: flex;
  gap: 10px;
  margin-top: 16px;
  flex-shrink: 0;
}
.btn-cancel {
  flex: 1;
  padding: 12px;
  background: transparent;
  border: 1px solid rgba(255,255,255,0.15);
  border-radius: 12px;
  color: rgba(255,255,255,0.5);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
}
.btn-cancel:hover {
  border-color: rgba(255,255,255,0.3);
  color: var(--cream);
}
.dialog-actions .btn-gold {
  flex: 1;
  text-align: center;
}

/* Loading / Empty */
.loading-state,
.empty-state {
  text-align: center;
  padding: 80px 20px;
  color: rgba(255,255,255,0.5);
}
</style>
