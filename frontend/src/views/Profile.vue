<template>
  <div class="page">
    <!-- AppBar -->
    <div class="profile-appbar">
      <h1 class="appbar-title">{{ t('profile.title') || 'Profile' }}</h1>
      <button class="appbar-logout" @click="handleLogout" aria-label="Logout">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
      </button>
    </div>

    <!-- Pull to refresh wrapper -->
    <div class="profile-scroll" @scroll.passive="onScroll">
      <div v-if="refreshing" class="refresh-indicator"><div class="spinner"></div></div>

      <template v-if="auth.isLoggedIn && auth.user">
        <!-- User Header -->
        <div class="user-header">
          <div class="user-avatar">{{ firstLetter }}</div>
          <div class="user-info">
            <h2 class="user-name">{{ auth.user.display_name || 'User' }}</h2>
            <p class="user-email">{{ auth.user.email }}</p>
          </div>
          <button class="edit-btn" @click="openEditDialog" aria-label="Edit profile">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M11 4H4a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-7"/><path d="M18.5 2.5a2.121 2.121 0 0 1 3 3L12 15l-4 1 1-4 9.5-9.5z"/></svg>
          </button>
        </div>

        <!-- Designer Earnings -->
        <div v-if="earnings" class="card earnings-card">
          <div class="earnings-row">
            <div class="earnings-item">
              <span class="earnings-label">{{ t('profile.totalEarned') || 'Total Earned' }}</span>
              <span class="earnings-value">{{ formatPrice(earnings.total_earned_cents) }}</span>
            </div>
            <div class="earnings-divider"></div>
            <div class="earnings-item">
              <span class="earnings-label">{{ t('profile.pending') || 'Pending' }}</span>
              <span class="earnings-value pending">{{ formatPrice(earnings.pending_cents) }}</span>
            </div>
            <div class="earnings-divider"></div>
            <div class="earnings-item">
              <span class="earnings-label">{{ t('profile.designsSold') || 'Designs Sold' }}</span>
              <span class="earnings-value">{{ earnings.total_design_sales }}</span>
            </div>
          </div>
        </div>

        <!-- Orders Section -->
        <div class="section">
          <h3 class="section-title">{{ t('profile.orders') || 'Orders' }}
            <span v-if="orders.length" class="section-badge">{{ orders.length }}</span>
          </h3>
          <div v-if="loadingOrders" class="loading-state"><div class="spinner"></div></div>
          <div v-else-if="!orders.length" class="empty-state">{{ t('profile.noOrders') || 'No orders yet' }}</div>
          <div v-else>
            <div
              v-for="o in orders.slice(0, 5)" :key="o.id"
              class="card order-card"
              @click="openOrderSheet(o)"
            >
              <div class="order-row">
                <span :class="['order-status-dot', o.status]"></span>
                <span :class="['order-status-label', o.status]">{{ o.status }}</span>
                <span class="order-total">{{ formatPrice(o.total_cents) }}</span>
              </div>
              <div class="order-row sub">
                <span class="order-date">{{ formatDate(o.created_at) }}</span>
              </div>
            </div>
            <router-link v-if="orders.length > 5" to="/profile/orders" class="see-all">{{ t('profile.seeAll') || 'See All' }}</router-link>
          </div>
        </div>

        <!-- Favorites Section -->
        <div class="section">
          <h3 class="section-title">{{ t('profile.favorites') || 'Favorites' }}</h3>
          <div v-if="!fav.ids.length" class="empty-state">{{ t('profile.noFavorites') || 'No favorites yet' }}</div>
          <div v-else class="fav-grid">
            <div v-for="id in fav.ids.slice(0, 10)" :key="id" class="card fav-card" @click="$router.push('/products/' + id)">
              <span class="fav-icon">❤️</span>
              <span class="fav-id">{{ id.slice(0, 8) }}...</span>
            </div>
          </div>
        </div>

        <!-- Addresses Section -->
        <div class="section">
          <h3 class="section-title">{{ t('profile.addresses') || 'Addresses' }}</h3>
          <div v-if="loadingAddresses" class="loading-state"><div class="spinner"></div></div>
          <div v-else>
            <div v-for="(addr, i) in addresses" :key="i" class="card address-card">
              <div class="address-info">
                <span class="address-name">{{ addr.name }}</span>
                <span class="address-detail">{{ addr.address }}, {{ addr.city }}, {{ addr.state }} {{ addr.zip }}</span>
              </div>
              <button class="address-delete" @click="deleteAddress(i)">✕</button>
            </div>
            <button class="btn-add-address" @click="showAddAddress = true">+ {{ t('profile.addAddress') || 'Add Address' }}</button>
          </div>
        </div>

        <!-- My Designs Section -->
        <div class="section">
          <h3 class="section-title">{{ t('profile.myDesigns') || 'My Designs' }}</h3>
          <div v-if="loadingDesigns" class="loading-state"><div class="spinner"></div></div>
          <div v-else-if="!designs.length" class="empty-state">{{ t('profile.noDesigns') || 'No designs yet' }}</div>
          <div v-else>
            <div
              v-for="d in designs" :key="d.id"
              class="card design-card"
              @click="openDesignDialog(d)"
            >
              <span class="design-status-icon">{{ d.is_published ? '🌐' : '🔒' }}</span>
              <div class="design-info">
                <span class="design-name">{{ d.name }}</span>
                <span class="design-meta">{{ d.is_published ? (t('profile.published') || 'Published') : (t('profile.draft') || 'Draft') }} • {{ formatPrice(d.price_cents) }} • {{ d.sales_count || 0 }} {{ t('profile.sold') || 'sold' }}</span>
              </div>
            </div>
          </div>
        </div>

        <!-- Language Selector -->
        <div class="lang-selector">
          <svg class="lang-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="10"/><line x1="2" y1="12" x2="22" y2="12"/><path d="M12 2a15.3 15.3 0 0 1 4 10 15.3 15.3 0 0 1-4 10 15.3 15.3 0 0 1-4-10 15.3 15.3 0 0 1 4-10z"/></svg>
          <span class="lang-label">{{ t('profile.language') || 'Language' }}</span>
          <div class="lang-select-wrapper">
            <select v-model="selectedLang" @change="changeLang" class="lang-select">
              <option v-for="loc in locales" :key="loc" :value="loc">
                {{ flags[loc] || '' }} {{ names[loc] || loc }}
              </option>
            </select>
          </div>
        </div>

        <!-- Admin Panel Link -->
        <router-link v-if="isAdmin" to="/admin" class="admin-link">
          <span class="admin-link-icon">⚙</span>
          {{ t('profile.adminPanel') || 'Admin Panel' }}
        </router-link>

        <!-- Sign Out -->
        <button class="btn-signout" @click="handleLogout">
          <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"/><polyline points="16 17 21 12 16 7"/><line x1="21" y1="12" x2="9" y2="12"/></svg>
          {{ t('profile.signOut') || 'Sign Out' }}
        </button>
      </template>

      <template v-else-if="auth.isLoggedIn && !auth.user">
        <div class="loading-state"><div class="spinner"></div></div>
      </template>

      <div v-else class="not-logged-in">
        <p class="not-logged-in-msg">{{ t('profile.signInRequired') || 'Sign in to view your profile' }}</p>
        <router-link to="/login" class="btn-gold">{{ t('profile.signIn') || 'Sign In' }}</router-link>
      </div>
    </div>

    <!-- Edit Profile Dialog -->
    <div v-if="showEditDialog" class="dialog-overlay" @click.self="showEditDialog = false">
      <div class="dialog">
        <h3 class="dialog-title">{{ t('profile.editProfile') || 'Edit Profile' }}</h3>
        <div class="dialog-field">
          <label>{{ t('profile.name') || 'Name' }}</label>
          <input v-model="editName" type="text" :placeholder="auth.user.display_name || ''" />
        </div>
        <div class="dialog-field">
          <label>{{ t('profile.bio') || 'Bio' }}</label>
          <textarea v-model="editBio" rows="3" :placeholder="auth.user.bio || ''"></textarea>
        </div>
        <div class="dialog-actions">
          <button class="btn-cancel" @click="showEditDialog = false">{{ t('profile.cancel') || 'Cancel' }}</button>
          <button class="btn-gold" @click="saveProfile" :disabled="saving">{{ saving ? (t('profile.saving') || 'Saving...') : (t('profile.save') || 'Save') }}</button>
        </div>
      </div>
    </div>

    <!-- Order Detail Bottom Sheet -->
    <div v-if="selectedOrder" class="sheet-overlay" @click.self="selectedOrder = null">
      <div class="bottom-sheet">
        <div class="sheet-handle"></div>
        <h3 class="sheet-title">{{ t('profile.orderDetails') || 'Order Details' }}</h3>
        <div class="sheet-row"><span class="sheet-label">{{ t('profile.orderId') || 'Order ID' }}</span><span class="sheet-value">{{ selectedOrder.id }}</span></div>
        <div class="sheet-row"><span class="sheet-label">{{ t('profile.status') || 'Status' }}</span><span :class="['order-status-label', selectedOrder.status]">{{ selectedOrder.status }}</span></div>
        <div class="sheet-row"><span class="sheet-label">{{ t('profile.total') || 'Total' }}</span><span class="sheet-value gold">{{ formatPrice(selectedOrder.total_cents) }}</span></div>
        <div class="sheet-row"><span class="sheet-label">{{ t('profile.date') || 'Date' }}</span><span class="sheet-value">{{ formatDate(selectedOrder.created_at) }}</span></div>
        <div v-if="selectedOrder.shipping_address" class="sheet-row address"><span class="sheet-label">{{ t('profile.shippingAddress') || 'Shipping Address' }}</span><span class="sheet-value">{{ selectedOrder.shipping_address }}</span></div>
        <button class="btn-gold btn-full sheet-close" @click="selectedOrder = null">{{ t('profile.close') || 'Close' }}</button>
      </div>
    </div>

    <!-- Design Edit Dialog -->
    <div v-if="editingDesign" class="dialog-overlay" @click.self="editingDesign = null">
      <div class="dialog">
        <h3 class="dialog-title">{{ t('profile.editDesign') || 'Edit Design' }}</h3>
        <div class="dialog-field">
          <label>{{ t('profile.designName') || 'Name' }}</label>
          <input v-model="designForm.name" type="text" />
        </div>
        <div class="dialog-field">
          <label>{{ t('profile.price') || 'Price (cents)' }}</label>
          <input v-model.number="designForm.price_cents" type="number" min="0" />
        </div>
        <div class="dialog-actions">
          <button class="btn-cancel" @click="editingDesign = null">{{ t('profile.cancel') || 'Cancel' }}</button>
          <button class="btn-gold" @click="saveDesign(false)" :disabled="savingDesign">{{ savingDesign ? '...' : (t('profile.save') || 'Save') }}</button>
          <button v-if="!editingDesign?.is_published" class="btn-publish" @click="saveDesign(true)" :disabled="savingDesign">{{ t('profile.publish') || 'Publish' }}</button>
        </div>
      </div>
    </div>
    <!-- Add Address Dialog -->
    <div v-if="showAddAddress" class="dialog-overlay" @click.self="showAddAddress = false">
      <div class="dialog">
        <h3 class="dialog-title">{{ t('profile.addAddress') || 'Add Address' }}</h3>
        <div class="dialog-field"><label>{{ t('order.fullName') || 'Full Name' }}</label><input v-model="newAddress.name" /></div>
        <div class="dialog-field"><label>{{ t('order.address') || 'Address' }}</label><input v-model="newAddress.address" /></div>
        <div class="dialog-field dialog-row">
          <div><label>{{ t('order.city') || 'City' }}</label><input v-model="newAddress.city" /></div>
          <div><label>{{ t('order.state') || 'State' }}</label><input v-model="newAddress.state" /></div>
        </div>
        <div class="dialog-field dialog-row">
          <div><label>{{ t('order.zip') || 'ZIP' }}</label><input v-model="newAddress.zip" /></div>
          <div><label>{{ t('order.country') || 'Country' }}</label><input v-model="newAddress.country" /></div>
        </div>
        <div class="dialog-actions">
          <button class="btn-cancel" @click="showAddAddress = false">{{ t('profile.cancel') || 'Cancel' }}</button>
          <button class="btn-gold" @click="addAddress">{{ t('profile.save') || 'Save' }}</button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from '../composables/useI18n'
import { useAuthStore } from '../stores/auth'
import { useFavoriteStore } from '../stores/favorites'
import { getOrders, getMyDesigns, getEarnings, updateProfile, updateDesign, publishDesign } from '../api'

const { t, lang, setLanguage, locales, flags, names } = useI18n()
const auth = useAuthStore()
const router = useRouter()
const fav = useFavoriteStore()

// Addresses (localStorage, max 10)
const addresses = ref(JSON.parse(localStorage.getItem('addresses') || '[]'))
const loadingAddresses = ref(false)
const showAddAddress = ref(false)
const newAddress = ref({ name: '', address: '', city: '', state: '', zip: '', country: 'US', phone: '' })

function addAddress() {
  if (addresses.value.length >= 10) return
  const a = newAddress.value
  if (!a.name || !a.address) return
  addresses.value.push({ ...a })
  localStorage.setItem('addresses', JSON.stringify(addresses.value))
  newAddress.value = { name: '', address: '', city: '', state: '', zip: '', country: 'US', phone: '' }
  showAddAddress.value = false
}

function deleteAddress(i) {
  addresses.value.splice(i, 1)
  localStorage.setItem('addresses', JSON.stringify(addresses.value))
}

// State
const orders = ref([])
const designs = ref([])
const earnings = ref(null)
const loadingOrders = ref(true)
const loadingDesigns = ref(true)
const refreshing = ref(false)
const selectedLang = ref(lang.value)

// Edit profile
const showEditDialog = ref(false)
const editName = ref('')
const editBio = ref('')
const saving = ref(false)

// Order sheet
const selectedOrder = ref(null)

// Design edit
const editingDesign = ref(null)
const designForm = ref({ name: '', price_cents: 0 })
const savingDesign = ref(false)

// Computed
const firstLetter = computed(() => {
  const name = auth.user?.display_name || auth.user?.email || ''
  return name.charAt(0).toUpperCase()
})

const isAdmin = computed(() => {
  return auth.user?.is_admin || auth.user?.role === 'admin' || false
})

// Format helpers
function formatPrice(cents) {
  return '$' + (cents / 100).toFixed(2)
}

function formatDate(dateStr) {
  return new Date(dateStr).toLocaleDateString()
}

// Pull to refresh
let scrollTop = 0
function onScroll(e) {
  const el = e.target
  if (el.scrollTop < -60 && !refreshing.value) {
    refreshData()
  }
}

async function refreshData() {
  refreshing.value = true
  await Promise.all([
    loadOrders(),
    loadDesigns(),
    loadEarningsData(),
    auth.fetchProfile()
  ])
  refreshing.value = false
}

// Load data
async function loadOrders() {
  try {
    const res = await getOrders()
    orders.value = res.data || res || []
  } catch { orders.value = [] }
  loadingOrders.value = false
}

async function loadDesigns() {
  try {
    const res = await getMyDesigns()
    designs.value = res.data || res || []
  } catch { designs.value = [] }
  loadingDesigns.value = false
}

async function loadEarningsData() {
  try {
    const res = await getEarnings()
    earnings.value = res.data || res || null
  } catch { earnings.value = null }
}

// Edit dialog
function openEditDialog() {
  editName.value = auth.user?.display_name || ''
  editBio.value = auth.user?.bio || ''
  showEditDialog.value = true
}

async function saveProfile() {
  saving.value = true
  try {
    const payload = {}
    if (editName.value) payload.display_name = editName.value
    if (editBio.value) payload.bio = editBio.value
    await updateProfile(payload)
    await auth.fetchProfile()
    showEditDialog.value = false
  } catch {}
  saving.value = false
}

// Order sheet
function openOrderSheet(order) {
  selectedOrder.value = order
}

// Design edit
function openDesignDialog(design) {
  editingDesign.value = design
  designForm.value = { name: design.name, price_cents: design.price_cents }
}

async function saveDesign(publishIt) {
  savingDesign.value = true
  try {
    const payload = { name: designForm.value.name, price_cents: designForm.value.price_cents }
    await updateDesign(editingDesign.value.id, payload)
    if (publishIt) {
      await publishDesign(editingDesign.value.id)
    }
    await loadDesigns()
    editingDesign.value = null
  } catch {}
  savingDesign.value = false
}

// Language
function changeLang() {
  setLanguage(selectedLang.value)
}

// Logout
function handleLogout() {
  auth.logout()
  router.push('/login')
}

onMounted(async () => {
  if (auth.isLoggedIn) {
    await auth.fetchProfile()
    loadOrders()
    loadDesigns()
    loadEarningsData()
    fav.syncFromBackend()
  }
})
</script>

<style scoped>
.profile-appbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 16px 20px;
  border-bottom: 1px solid rgba(200,164,92,0.1);
}
.appbar-title {
  font-family: var(--serif);
  font-size: 22px;
  color: var(--gold);
  letter-spacing: 2px;
}
.appbar-logout {
  background: none;
  border: none;
  color: rgba(255,255,255,0.4);
  padding: 8px;
  border-radius: 50%;
  transition: all 0.2s;
}
.appbar-logout:hover {
  color: var(--gold);
  background: rgba(200,164,92,0.1);
}

.profile-scroll {
  padding: 0 20px 40px;
  max-width: 500px;
  margin: 0 auto;
  overflow-y: auto;
  -webkit-overflow-scrolling: touch;
}

.refresh-indicator {
  display: flex;
  justify-content: center;
  padding: 12px 0;
}

/* User Header */
.user-header {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 24px 0 20px;
}
.user-avatar {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  border: 2px solid var(--gold);
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: var(--serif);
  font-size: 28px;
  color: var(--gold);
  background: var(--surface);
  flex-shrink: 0;
}
.user-info {
  flex: 1;
  min-width: 0;
}
.user-name {
  font-family: var(--serif);
  font-size: 24px;
  color: var(--gold);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.user-email {
  font-size: 13px;
  opacity: 0.5;
  margin-top: 2px;
}
.edit-btn {
  background: none;
  border: 1px solid rgba(200,164,92,0.3);
  border-radius: 50%;
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  color: var(--gold);
  cursor: pointer;
  transition: all 0.2s;
  flex-shrink: 0;
}
.edit-btn:hover {
  background: rgba(200,164,92,0.1);
}

/* Earnings Card */
.earnings-card {
  padding: 20px;
  margin-bottom: 24px;
}
.earnings-row {
  display: flex;
  align-items: center;
  gap: 0;
}
.earnings-item {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  gap: 6px;
}
.earnings-label {
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 1px;
  opacity: 0.5;
}
.earnings-value {
  font-family: var(--serif);
  font-size: 18px;
  color: var(--gold);
  font-weight: 700;
}
.earnings-value.pending {
  color: var(--copper);
  opacity: 0.8;
}
.earnings-divider {
  width: 1px;
  height: 40px;
  background: rgba(200,164,92,0.15);
  flex-shrink: 0;
}

/* Sections */
.section {
  margin-bottom: 28px;
}
.section-title {
  font-family: var(--serif);
  color: var(--gold);
  font-size: 16px;
  margin-bottom: 12px;
  letter-spacing: 1px;
}

/* Order cards */
.order-card {
  padding: 14px 16px;
  margin-bottom: 8px;
  cursor: pointer;
  transition: all 0.2s;
}
.order-card:hover {
  border-color: rgba(200,164,92,0.3);
}
.order-row {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 4px;
}
.order-row:last-child { margin-bottom: 0; }
.order-row.sub {
  justify-content: flex-end;
}
.order-status-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
  flex-shrink: 0;
}
.order-status-dot.pending { background: var(--copper); }
.order-status-dot.paid { background: #2ecc71; }
.order-status-dot.shipped { background: #2ecc71; }
.order-status-dot.delivered { background: #2ecc71; }
.order-status-dot.cancelled { background: #e53935; }

.order-status-label {
  font-size: 11px;
  text-transform: uppercase;
  letter-spacing: 1px;
  padding: 2px 8px;
  border-radius: 4px;
  font-weight: 600;
}
.order-status-label.pending { color: var(--copper); background: rgba(139,111,71,0.15); }
.order-status-label.paid { color: #2ecc71; background: rgba(46,204,113,0.1); }
.order-status-label.shipped { color: #2ecc71; background: rgba(46,204,113,0.1); }
.order-status-label.delivered { color: #2ecc71; background: rgba(46,204,113,0.1); }
.order-status-label.cancelled { color: #e53935; background: rgba(229,57,53,0.1); }

.order-total {
  font-weight: 700;
  color: var(--gold);
  font-size: 14px;
  margin-left: auto;
}
.order-date {
  font-size: 11px;
  opacity: 0.4;
}

/* Design cards */
.design-card {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 14px 16px;
  margin-bottom: 8px;
  cursor: pointer;
  transition: all 0.2s;
}
.design-card:hover {
  border-color: rgba(200,164,92,0.3);
}
.design-status-icon {
  font-size: 20px;
  flex-shrink: 0;
}
.design-info {
  display: flex;
  flex-direction: column;
  min-width: 0;
}
.design-name {
  font-family: var(--serif);
  font-size: 14px;
  color: var(--cream);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.design-meta {
  font-size: 11px;
  opacity: 0.5;
  margin-top: 2px;
}

/* Language Selector */
.lang-selector {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 16px;
  background: var(--surface);
  border-radius: 12px;
  border: 1px solid rgba(200,164,92,0.1);
  margin-bottom: 12px;
}
.lang-icon {
  color: var(--gold);
  flex-shrink: 0;
}
.lang-label {
  font-size: 14px;
  color: var(--cream);
  flex: 1;
}
.lang-select-wrapper {
  position: relative;
}
.lang-select {
  appearance: none;
  background: var(--bg);
  border: 1px solid rgba(200,164,92,0.2);
  border-radius: 8px;
  padding: 8px 32px 8px 12px;
  color: var(--cream);
  font-size: 13px;
  cursor: pointer;
  outline: none;
  min-width: 120px;
}
.lang-select-wrapper::after {
  content: '▾';
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--gold);
  font-size: 10px;
  pointer-events: none;
}

/* Admin Link */
.admin-link {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 16px;
  background: var(--surface);
  border-radius: 12px;
  border: 1px solid rgba(200,164,92,0.1);
  color: var(--gold);
  font-size: 14px;
  text-decoration: none;
  margin-bottom: 12px;
  transition: all 0.2s;
}
.admin-link:hover {
  border-color: var(--gold);
}
.admin-link-icon {
  font-size: 16px;
}

/* Sign Out Button */
.btn-signout {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
  width: 100%;
  padding: 14px;
  background: transparent;
  border: 1px solid var(--copper);
  border-radius: 12px;
  color: var(--copper);
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  margin-top: 8px;
}
.btn-signout:hover {
  background: rgba(139,111,71,0.1);
}
.btn-signout svg {
  width: 16px;
  height: 16px;
}

/* Not logged in */
.not-logged-in {
  text-align: center;
  padding: 80px 20px;
}
.not-logged-in-msg {
  opacity: 0.5;
  margin-bottom: 20px;
  font-size: 15px;
}

/* Loading / Empty states */
.loading-state,
.empty-state {
  text-align: center;
  padding: 40px 20px;
  color: rgba(255,255,255,0.5);
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
  max-width: 400px;
}
.dialog-title {
  font-family: var(--serif);
  color: var(--gold);
  font-size: 18px;
  margin-bottom: 20px;
}
.dialog-field {
  margin-bottom: 16px;
}
.dialog-field label {
  display: block;
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 1px;
  opacity: 0.5;
  margin-bottom: 6px;
}
.dialog-field input,
.dialog-field textarea {
  width: 100%;
}
.dialog-actions {
  display: flex;
  gap: 10px;
  margin-top: 20px;
  flex-wrap: wrap;
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
.btn-publish {
  flex: 1;
  padding: 12px;
  background: var(--gold);
  border: none;
  border-radius: 12px;
  color: var(--bg);
  font-size: 14px;
  font-weight: 700;
  transition: all 0.2s;
}
.btn-publish:hover {
  opacity: 0.9;
}
.btn-publish:disabled {
  opacity: 0.4;
  cursor: default;
}

/* Bottom Sheet */
.sheet-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0,0,0,0.6);
  z-index: 200;
  display: flex;
  align-items: flex-end;
  justify-content: center;
}
.bottom-sheet {
  background: var(--surface);
  border: 1px solid rgba(200,164,92,0.15);
  border-radius: 20px 20px 0 0;
  padding: 16px 20px 32px;
  width: 100%;
  max-width: 500px;
  animation: slideUp 0.3s ease;
}
@keyframes slideUp {
  from { transform: translateY(100%); }
  to { transform: translateY(0); }
}
.sheet-handle {
  width: 36px;
  height: 4px;
  background: rgba(255,255,255,0.15);
  border-radius: 2px;
  margin: 0 auto 16px;
}
.sheet-title {
  font-family: var(--serif);
  color: var(--gold);
  font-size: 18px;
  margin-bottom: 16px;
}
.sheet-row {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  padding: 10px 0;
  border-bottom: 1px solid rgba(200,164,92,0.06);
  gap: 12px;
}
.sheet-row:last-of-type { border-bottom: none; }
.sheet-row.address {
  flex-direction: column;
  gap: 4px;
}
.sheet-label {
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 1px;
  opacity: 0.4;
  flex-shrink: 0;
  min-width: 90px;
}
.sheet-value {
  font-size: 14px;
  color: var(--cream);
  text-align: right;
  word-break: break-all;
}
.sheet-value.gold {
  color: var(--gold);
  font-weight: 700;
}
.sheet-close {
  margin-top: 16px;
  width: 100%;
}

.btn-full {
  width: 100%;
  text-align: center;
}
</style>
