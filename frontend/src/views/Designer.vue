<template>
  <div class="designer-page">
    <!-- Header -->
    <div class="designer-header">
      <h1 class="designer-title">{{ t('designer.title') || 'Design Studio' }}</h1>
      <button class="header-clear" @click="clearDesign" :title="t('designer.clear') || 'Clear'">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
          <path d="M3 6h18"/><path d="M19 6v14c0 1-1 2-2 2H7c-1 0-2-1-2-2V6"/><path d="M8 6V4c0-1 1-2 2-2h4c1 0 2 1 2 2v2"/>
          <line x1="10" y1="11" x2="10" y2="17"/><line x1="14" y1="11" x2="14" y2="17"/>
        </svg>
      </button>
    </div>

    <!-- Loading -->
    <div v-if="_loading" class="loading-state"><div class="spinner"></div></div>

    <template v-else>
      <!-- Bracelet Preview (140px) -->
      <div class="preview-area">
        <div class="preview-string">
          <div class="clasp clasp-left">◈</div>
          <div class="preview-beads">
            <div
              v-for="(el, i) in _placed"
              :key="i"
              class="preview-bead"
              :style="{ background: el.color || '#666' }"
            >
              <span class="bead-index">{{ i + 1 }}</span>
            </div>
            <div v-if="!_placed.length" class="preview-placeholder">{{ t('designer.tapToStart') || 'Add elements to your bracelet' }}</div>
          </div>
          <div class="clasp clasp-right">◈</div>
        </div>
        <!-- Controls under beads -->
        <div class="bead-controls" v-if="_placed.length">
          <div v-for="(el, i) in _placed" :key="i" class="bead-control-item">
            <div class="bead-dot" :style="{ background: el.color || '#666' }"></div>
            <span class="bead-ctrl-num">{{ i + 1 }}</span>
            <div class="bead-arrows">
              <button class="arr-btn" @click="moveElement(i, -1)" :disabled="i === 0" :title="'◀'">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m15 18-6-6 6-6"/></svg>
              </button>
              <button class="arr-btn" @click="moveElement(i, 1)" :disabled="i === _placed.length - 1" :title="'▶'">
                <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="m9 18 6-6-6-6"/></svg>
              </button>
            </div>
            <button class="remove-btn" @click="removeElement(i)" :title="'✕'">✕</button>
          </div>
        </div>
      </div>

      <!-- Design Name + Price bar -->
      <div class="name-price-bar">
        <input
          v-model="_name"
          class="design-name-input"
          :placeholder="t('designer.designName') || 'Design name...'"
          maxlength="60"
        />
        <div class="price-badge">
          <span class="price-count">{{ _placed.length }} {{ t('designer.elements') || 'elements' }}</span>
          <span class="price-value">{{ formatPrice(totalCents) }}</span>
        </div>
      </div>

      <!-- String/Band selector -->
      <div class="section-label">{{ t('designer.stringBand') || 'String / Band' }}</div>
      <div class="string-selector">
        <button
          :class="['string-chip', { active: !_selectedString }]"
          @click="_selectedString = null"
        >{{ t('designer.none') || 'None' }}</button>
        <button
          v-for="s in strings"
          :key="s.id"
          :class="['string-chip', { active: _selectedString?.id === s.id }]"
          @click="_selectedString = s"
        >
          <span class="string-chip-dot" :style="{ background: s.color || '#666' }"></span>
          {{ s.name }}
        </button>
      </div>

      <!-- Element Type Tabs -->
      <div class="type-tabs">
        <button
          v-for="t in typeTabs"
          :key="t.key"
          :class="['type-tab', { active: _selectedType === t.key }]"
          @click="_selectedType = t.key"
        >{{ t.label }}</button>
      </div>

      <!-- Element Grid -->
      <div class="element-grid-wrap">
        <div v-if="!filteredElements.length" class="empty-state">{{ t('designer.noElements') || 'No elements available' }}</div>
        <div v-else class="element-grid">
          <div
            v-for="el in filteredElements"
            :key="el.id"
            class="element-card"
            @click="addElement(el)"
          >
            <div class="el-color" :style="{ background: el.color || '#444' }">
              <img v-if="el.image_url" :src="el.image_url" :alt="el.name" @error="e => e.target.style.display='none'" />
            </div>
            <div class="el-info">
              <span class="el-name">{{ el.name }}</span>
              <span class="el-price">{{ formatPrice(el.price_cents) }}</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Action Buttons -->
      <div class="action-bar">
        <button class="btn-save" :disabled="_saving || !_placed.length" @click="saveDesign(false)">
          <span v-if="_saving" class="spinner" style="width:16px;height:16px;border-width:2px"></span>
          <span v-else>{{ t('designer.save') || 'Save' }}</span>
        </button>
        <button class="btn-publish" :disabled="_saving || !_placed.length" @click="_showCopyright = true">
          <span v-if="_saving" class="spinner" style="width:16px;height:16px;border-width:2px"></span>
          <span v-else>{{ t('designer.publish') || 'Publish' }}</span>
        </button>
      </div>
    </template>

    <!-- Copyright Confirmation Modal -->
    <Teleport to="body">
      <div v-if="_showCopyright" class="copyright-overlay" @click.self="_showCopyright = false">
        <div class="copyright-modal">
          <h3>{{ t('designer.copyrightTitle') || 'Design Copyright Agreement' }}</h3>
          <div class="copyright-body">
            <p>{{ t('designer.copyrightText1') || 'By publishing this design, you agree that:' }}</p>
            <ul>
              <li>{{ t('designer.copyright1') || 'The copyright of this design belongs to you as the author.' }}</li>
              <li>{{ t('designer.copyright2') || 'The platform is authorized to produce and sell this design.' }}</li>
              <li>{{ t('designer.copyright3') || 'You will receive a commission for each sale of your design.' }}</li>
              <li>{{ t('designer.copyright4') || 'This agreement cannot be revoked once published.' }}</li>
            </ul>
            <router-link to="/terms" class="terms-link" @click.stop>{{ t('terms.title') || 'Terms of Service' }}</router-link>
          </div>
          <div class="copyright-actions">
            <label class="copyright-check">
              <input type="checkbox" v-model="_copyrightAccepted" />
              <span>{{ t('designer.copyrightAccept') || 'I understand and agree to these terms' }}</span>
            </label>
            <div class="copyright-btns">
              <button class="btn-cancel" @click="_showCopyright = false">{{ t('designer.cancel') || 'Cancel' }}</button>
              <button class="btn-gold-solid" :disabled="!_copyrightAccepted" @click="_showCopyright = false; saveDesign(true)">
                {{ t('designer.confirmPublish') || 'Confirm & Publish' }}
              </button>
            </div>
          </div>
        </div>
      </div>
    </Teleport>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { useI18n } from '../composables/useI18n'
import { getElements, createDesign, updateDesign, publishDesign } from '../api'

const { t } = useI18n()
const router = useRouter()

// State
const _loading = ref(true)
const _saving = ref(false)
const _copyrightAccepted = ref(false)
const _showCopyright = ref(false)
const _elements = ref([])
const _placed = ref([])
const _selectedString = ref(null)
const _selectedType = ref('beads')
const _name = ref('')
const _savedDesignId = ref(null)

const typeTabs = [
  { key: 'beads', label: t('designer.beads') || 'Beads' },
  { key: 'charms', label: t('designer.charms') || 'Charms' },
  { key: 'pendants', label: t('designer.pendants') || 'Pendants' },
  { key: 'spacers', label: t('designer.spacers') || 'Spacers' },
  { key: 'string', label: t('designer.string') || 'String' },
]

// Computed
const strings = computed(() => _elements.value.filter(e => e.type === 'string'))

const filteredElements = computed(() => {
  if (_selectedType.value === 'string') return strings.value
  return _elements.value.filter(e => e.type === _selectedType.value)
})

const totalCents = computed(() => {
  let sum = 0
  for (const el of _placed.value) sum += (el.price_cents || 0)
  if (_selectedString.value) sum += (_selectedString.value.price_cents || 0)
  return sum
})

function formatPrice(cents) {
  return '$' + ((cents || 0) / 100).toFixed(2)
}

// Methods
async function loadElements() {
  _loading.value = true
  try {
    const res = await getElements()
    // res is already res.data due to interceptor
    _elements.value = (Array.isArray(res) ? res : res.data || []).filter(e => e.is_active !== false)
  } catch (e) {
    console.error('Failed to load elements', e)
  } finally {
    _loading.value = false
  }
}

function addElement(element) {
  if (element.type === 'string') {
    _selectedString.value = element
  } else {
    _placed.value.push(element)
  }
}

function removeElement(index) {
  _placed.value.splice(index, 1)
}

function moveElement(index, delta) {
  const newIndex = index + delta
  if (newIndex < 0 || newIndex >= _placed.value.length) return
  const arr = _placed.value
  const tmp = arr[index]
  arr[index] = arr[newIndex]
  arr[newIndex] = tmp
  // Trigger reactivity
  _placed.value = [...arr]
}

function clearDesign() {
  _placed.value = []
  _selectedString.value = null
  _savedDesignId.value = null
  _name.value = ''
  _selectedType.value = 'beads'
}

async function saveDesign(publish = false) {
  if (!_placed.value.length) return
  _saving.value = true
  try {
    const designData = {
      name: _name.value || 'Untitled Design',
      elements: _placed.value.map(el => el.id),
      string_element_id: _selectedString.value?.id || null,
      price_cents: totalCents.value,
    }

    let res
    if (_savedDesignId.value) {
      res = await updateDesign(_savedDesignId.value, designData)
    } else {
      res = await createDesign(designData)
      _savedDesignId.value = res?.id || res?.data?.id || null
    }

    if (publish && _savedDesignId.value) {
      await publishDesign(_savedDesignId.value)
    }

    // Navigate away on success
    router.push('/profile')
  } catch (e) {
    console.error('Save failed', e)
  } finally {
    _saving.value = false
  }
}

onMounted(() => {
  loadElements()
})
</script>

<style scoped>
.designer-page {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
  background: var(--bg, #0A0A0A);
  color: var(--cream, #F5F0E8);
  padding: 16px;
  gap: 14px;
  padding-bottom: 100px;
}

/* Header */
.designer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 0;
}
.designer-title {
  font-family: var(--serif, Georgia, serif);
  font-size: 22px;
  color: var(--gold, #C8A45C);
  letter-spacing: 2px;
}
.header-clear {
  background: none;
  border: none;
  color: var(--cream, #F5F0E8);
  opacity: 0.6;
  padding: 8px;
  border-radius: 8px;
  cursor: pointer;
  transition: opacity 0.2s;
}
.header-clear:hover { opacity: 1; color: #e74c3c; }

/* Preview Area (140px) */
.preview-area {
  background: linear-gradient(135deg, rgba(200,164,92,0.08), rgba(10,10,10,0.5));
  border: 1px solid rgba(200,164,92,0.15);
  border-radius: 14px;
  padding: 16px;
  min-height: 140px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}
.preview-string {
  display: flex;
  align-items: center;
  gap: 6px;
  flex: 1;
}
.clasp {
  font-size: 22px;
  color: var(--gold, #C8A45C);
  opacity: 0.7;
  flex-shrink: 0;
}
.preview-beads {
  flex: 1;
  display: flex;
  gap: 6px;
  overflow-x: auto;
  padding: 8px 0;
  align-items: center;
  scrollbar-width: none;
}
.preview-beads::-webkit-scrollbar { display: none; }
.preview-bead {
  width: 38px;
  height: 38px;
  border-radius: 50%;
  flex-shrink: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 2px solid rgba(200,164,92,0.4);
  position: relative;
}
.bead-index {
  font-size: 12px;
  font-weight: 700;
  color: #fff;
  text-shadow: 0 1px 2px rgba(0,0,0,0.6);
}
.preview-placeholder {
  color: rgba(245,240,232,0.35);
  font-size: 13px;
  font-style: italic;
  width: 100%;
  text-align: center;
}

/* Bead controls */
.bead-controls {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  padding: 4px 0;
  scrollbar-width: none;
}
.bead-controls::-webkit-scrollbar { display: none; }
.bead-control-item {
  display: flex;
  align-items: center;
  gap: 4px;
  background: var(--card, #222);
  border-radius: 20px;
  padding: 4px 8px 4px 6px;
  flex-shrink: 0;
  border: 1px solid rgba(200,164,92,0.1);
}
.bead-dot {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  flex-shrink: 0;
  border: 1px solid rgba(255,255,255,0.2);
}
.bead-ctrl-num {
  font-size: 11px;
  font-weight: 600;
  color: var(--gold, #C8A45C);
  min-width: 16px;
  text-align: center;
}
.bead-arrows {
  display: flex;
  gap: 2px;
}
.arr-btn {
  background: rgba(200,164,92,0.1);
  border: none;
  color: var(--gold, #C8A45C);
  width: 18px;
  height: 18px;
  border-radius: 4px;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 10px;
  padding: 0;
  transition: background 0.15s;
}
.arr-btn:hover:not(:disabled) { background: rgba(200,164,92,0.25); }
.arr-btn:disabled { opacity: 0.25; cursor: default; }
.remove-btn {
  background: none;
  border: none;
  color: #e74c3c;
  font-size: 12px;
  cursor: pointer;
  padding: 0 2px;
  opacity: 0.6;
  line-height: 1;
}
.remove-btn:hover { opacity: 1; }

/* Name + Price bar */
.name-price-bar {
  display: flex;
  align-items: center;
  gap: 12px;
}
.design-name-input {
  flex: 1;
  background: var(--surface, #1A1A1A);
  border: 1px solid rgba(200,164,92,0.2);
  border-radius: 10px;
  padding: 12px 14px;
  color: var(--cream, #F5F0E8);
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
}
.design-name-input:focus {
  border-color: var(--gold, #C8A45C);
}
.design-name-input::placeholder {
  color: rgba(245,240,232,0.3);
}
.price-badge {
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 2px;
  flex-shrink: 0;
}
.price-count {
  font-size: 11px;
  color: rgba(245,240,232,0.5);
}
.price-value {
  font-size: 16px;
  font-weight: 700;
  color: var(--gold, #C8A45C);
}

/* Section label */
.section-label {
  font-size: 12px;
  text-transform: uppercase;
  letter-spacing: 1.5px;
  color: rgba(245,240,232,0.5);
  padding: 4px 0;
}

/* String selector */
.string-selector {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  padding: 4px 0;
  scrollbar-width: none;
}
.string-selector::-webkit-scrollbar { display: none; }
.string-chip {
  display: flex;
  align-items: center;
  gap: 6px;
  background: var(--surface, #1A1A1A);
  border: 1px solid rgba(200,164,92,0.15);
  border-radius: 20px;
  padding: 8px 16px;
  color: var(--cream, #F5F0E8);
  font-size: 13px;
  white-space: nowrap;
  cursor: pointer;
  transition: all 0.15s;
  flex-shrink: 0;
}
.string-chip.active {
  border-color: var(--gold, #C8A45C);
  background: rgba(200,164,92,0.1);
  color: var(--gold, #C8A45C);
}
.string-chip:hover {
  border-color: rgba(200,164,92,0.4);
}
.string-chip-dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  flex-shrink: 0;
}

/* Type Tabs */
.type-tabs {
  display: flex;
  gap: 4px;
  border-bottom: 1px solid rgba(200,164,92,0.1);
  padding: 0;
}
.type-tab {
  background: none;
  border: none;
  border-bottom: 2px solid transparent;
  padding: 10px 16px;
  font-size: 14px;
  color: rgba(245,240,232,0.5);
  cursor: pointer;
  transition: all 0.2s;
  white-space: nowrap;
  font-weight: 500;
}
.type-tab.active {
  color: var(--gold, #C8A45C);
  border-bottom-color: var(--gold, #C8A45C);
}
.type-tab:hover {
  color: var(--cream, #F5F0E8);
}

/* Element Grid */
.element-grid-wrap {
  flex: 1;
  overflow-y: auto;
  padding: 12px 16px 90px;
}
.element-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 10px;
  padding: 4px 0;
}
.element-card {
  background: var(--card, #222);
  border: 1px solid rgba(200,164,92,0.08);
  border-radius: 12px;
  overflow: hidden;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  flex-direction: column;
}
.element-card:hover {
  border-color: var(--gold, #C8A45C);
  transform: translateY(-2px);
  box-shadow: 0 4px 16px rgba(200,164,92,0.15);
}
.el-color {
  width: 100%;
  aspect-ratio: 1;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 12px 12px 0 0;
  min-height: 60px;
}
.el-color img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 12px 12px 0 0;
}
.el-info {
  padding: 8px 10px;
  display: flex;
  flex-direction: column;
  gap: 4px;
}
.el-name {
  font-size: 12px;
  font-weight: 600;
  color: var(--cream, #F5F0E8);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}
.el-price {
  font-size: 12px;
  color: var(--gold, #C8A45C);
  font-weight: 500;
}

/* Action Buttons */
.action-bar {
  position: fixed;
  bottom: 70px;
  left: 0;
  right: 0;
  display: flex;
  gap: 12px;
  padding: 16px;
  background: rgba(10,10,10,0.95);
  backdrop-filter: blur(10px);
  border-top: 1px solid rgba(200,164,92,0.12);
  z-index: 50;
}
.btn-save {
  flex: 1;
  background: transparent;
  border: 1px solid var(--gold, #C8A45C);
  color: var(--gold, #C8A45C);
  padding: 14px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}
.btn-save:hover:not(:disabled) {
  background: rgba(200,164,92,0.1);
}
.btn-save:disabled {
  opacity: 0.35;
  cursor: default;
}
.btn-publish {
  flex: 1;
  background: var(--gold, #C8A45C);
  border: 1px solid var(--gold, #C8A45C);
  color: var(--bg, #0A0A0A);
  padding: 14px;
  border-radius: 12px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 8px;
}
.btn-publish:hover:not(:disabled) {
  background: #d4b06a;
  border-color: #d4b06a;
}
.btn-publish:disabled {
  opacity: 0.35;
  cursor: default;
}

/* Shared states */
.loading-state {
  display: flex;
  justify-content: center;
  padding: 60px 0;
}
.empty-state {
  text-align: center;
  padding: 40px 20px;
  color: rgba(245,240,232,0.35);
  font-size: 14px;
}
/* Copyright Modal */
.copyright-overlay {
  position: fixed; inset: 0; z-index: 1000;
  background: rgba(0,0,0,0.7);
  display: flex; align-items: center; justify-content: center;
  padding: 20px;
}
.copyright-modal {
  background: #1a1a1a; border: 1px solid #333; border-radius: 12px;
  padding: 28px; max-width: 460px; width: 100%;
}
.copyright-modal h3 { color: #C8A45C; margin: 0 0 16px; font-size: 18px; }
.copyright-body { margin-bottom: 20px; }
.copyright-body p { color: rgba(245,240,232,0.8); margin: 0 0 12px; font-size: 14px; line-height: 1.5; }
.copyright-body ul { margin: 0; padding-left: 20px; }
.copyright-body li { color: rgba(245,240,232,0.7); font-size: 13px; line-height: 1.6; }
.copyright-check { display: flex; align-items: flex-start; gap: 8px; margin-bottom: 16px; cursor: pointer; }
.copyright-check input { margin-top: 3px; }
.copyright-check span { font-size: 13px; color: rgba(245,240,232,0.7); }
.copyright-btns { display: flex; gap: 12px; justify-content: flex-end; }
</style>
