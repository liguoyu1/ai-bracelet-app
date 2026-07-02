<template>
  <div class="page energy-page">
    <!-- FORM VIEW -->
    <div v-if="!_assessed" class="energy-form">
      <div class="form-header">
        <div class="form-icon">✦</div>
        <h1 class="form-title">{{ t('energy.discover') }}</h1>
        <p class="form-subtitle">{{ t('energy.subtitle') }}</p>
      </div>

      <!-- Birth Date -->
      <div class="field-wrap">
        <label class="field-label">{{ t('energy.birthDate') }}</label>
        <div class="input-with-icon">
          <span class="input-icon">📅</span>
          <input
            v-model="birthDate"
            type="text"
            class="energy-input"
            :placeholder="t('energy.birthDate')"
          />
        </div>
      </div>

      <!-- Zodiac Sign -->
      <div class="field-wrap">
        <label class="field-label">{{ t('energy.zodiac') }}</label>
        <div class="input-with-icon">
          <span class="input-icon">⭐</span>
          <select v-model="zodiac" class="energy-input energy-select">
            <option value="" disabled>{{ t('energy.zodiac') }}</option>
            <option v-for="s in zodiacSigns" :key="s" :value="s">{{ s }}</option>
          </select>
        </div>
      </div>

      <!-- Preferred Element -->
      <div class="field-wrap">
        <label class="field-label">{{ t('energy.element') }}</label>
        <div class="input-with-icon">
          <span class="input-icon">🔥</span>
          <select v-model="element" class="energy-input energy-select">
            <option value="" disabled>{{ t('energy.element') }}</option>
            <option v-for="e in elements" :key="e" :value="e">
              {{ e }}
            </option>
          </select>
        </div>
        <div class="element-dots">
          <div
            v-for="e in elements"
            :key="e"
            class="element-dot"
            :class="{ active: element === e }"
            @click="element = e"
          >
            <span class="dot" :style="{ background: elementColor(e) }"></span>
            <span class="dot-label">{{ e }}</span>
          </div>
        </div>
      </div>

      <!-- Concerns -->
      <div class="field-wrap">
        <label class="field-label">{{ t('energy.concerns') }}</label>
        <div class="input-with-icon">
          <span class="input-icon">🧠</span>
          <textarea
            v-model="concerns"
            class="energy-input energy-textarea"
            :placeholder="t('energy.concernsHint')"
            rows="3"
          ></textarea>
        </div>
      </div>

      <!-- Lifestyle -->
      <div class="field-wrap">
        <label class="field-label">{{ t('energy.lifestyle') }}</label>
        <div class="input-with-icon">
          <span class="input-icon">🚶</span>
          <textarea
            v-model="lifestyle"
            class="energy-input energy-textarea"
            :placeholder="t('energy.lifestyleHint')"
            rows="3"
          ></textarea>
        </div>
      </div>

      <button
        class="btn-start"
        :disabled="_loading"
        @click="assess"
      >
        <span v-if="_loading" class="spinner" style="width:22px;height:22px;border-width:2.5px;margin:0 auto"></span>
        <span v-else>{{ t('energy.start') }}</span>
      </button>

      <p v-if="_error" class="error-msg">{{ _error }}</p>
    </div>

    <!-- RESULTS VIEW -->
    <div v-else class="energy-results">
      <div class="results-header">
        <div class="form-icon">✦</div>
        <h1 class="form-title">{{ t('energy.profile') }}</h1>
        <p class="form-subtitle">{{ t('energy.profileSub') }}</p>
      </div>

      <div v-if="!_recommendations.length" class="no-results">
        <p>{{ t('energy.noResults') }}</p>
      </div>

      <div v-for="(rec, i) in _recommendations" :key="i" class="rec-card">
        <!-- Element Badge -->
        <div class="rec-badge">
          <span class="badge-dot" :style="{ background: elementColor(rec.element) }"></span>
          <span class="badge-name" :style="{ color: elementColor(rec.element) }">{{ rec.element?.toUpperCase() }}</span>
        </div>

        <!-- Explanation -->
        <p class="rec-explanation">{{ rec.explanation }}</p>

        <!-- Energy Focus -->
        <p v-if="rec.energy_focus" class="rec-focus">✦ {{ rec.energy_focus }} ✦</p>

        <!-- Colors -->
        <div v-if="rec.recommended_colors?.length" class="rec-section">
          <h4 class="rec-section-title">{{ t('energy.colors') }}</h4>
          <div class="color-chips">
            <div v-for="c in rec.recommended_colors" :key="c" class="color-chip">
              <span class="color-swatch" :style="{ background: parseColor(c) }"></span>
              <span class="color-label">{{ c }}</span>
            </div>
          </div>
        </div>

        <!-- Materials -->
        <div v-if="rec.recommended_materials?.length" class="rec-section">
          <h4 class="rec-section-title">{{ t('energy.materials') }}</h4>
          <div class="chip-wrap">
            <span v-for="m in rec.recommended_materials" :key="m" class="chip">{{ m }}</span>
          </div>
        </div>

        <!-- Crystals -->
        <div v-if="rec.crystal_suggestions?.length" class="rec-section">
          <h4 class="rec-section-title">{{ t('energy.crystals') }}</h4>
          <div class="chip-wrap">
            <span v-for="c in rec.crystal_suggestions" :key="c" class="chip chip-crystal">{{ c }}</span>
          </div>
        </div>
      </div>

      <button class="btn-try-again" @click="reset">{{ t('energy.tryAgain') }}</button>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useI18n } from '../composables/useI18n'
import { energyAssess, getEnergyHistory } from '../api'

const { t } = useI18n()

// State
const _loading = ref(false)
const _assessed = ref(false)
const _error = ref(null)
const _recommendations = ref([])

// Form
const birthDate = ref('')
const zodiac = ref('')
const element = ref('')
const concerns = ref('')
const lifestyle = ref('')

const zodiacSigns = [
  'Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo',
  'Libra', 'Scorpio', 'Sagittarius', 'Capricorn', 'Aquarius', 'Pisces',
]

const elements = ['Wood', 'Fire', 'Earth', 'Metal', 'Water']

function elementColor(el) {
  const map = {
    wood: '#4CAF50',
    fire: '#FF5722',
    earth: '#795548',
    metal: '#9E9E9E',
    water: '#2196F3',
  }
  return map[el?.toLowerCase()] || '#C8A45C'
}

function parseColor(name) {
  const map = {
    'deep blue': '#1a237e',
    'silver': '#bdbdbd',
    'aquamarine': '#7fffd4',
    'emerald green': '#2e7d32',
    'brown': '#5d4037',
    'gold': '#FFD700',
    'red': '#d32f2f',
    'orange': '#f57c00',
  }
  return map[name?.toLowerCase()] || '#9E9E9E'
}

async function assess() {
  if (!zodiac.value) {
    _error.value = t('energy.selectZodiac')
    return
  }
  if (!element.value) {
    _error.value = t('energy.selectElement')
    return
  }

  _loading.value = true
  _error.value = null

  try {
    const res = await energyAssess({
      birth_date: birthDate.value.trim(),
      zodiac_sign: zodiac.value,
      preferred_element: element.value,
      concerns: concerns.value.trim(),
      lifestyle: lifestyle.value.trim(),
    })
    _recommendations.value = res.data?.recommendations || res.recommendations || []
    _assessed.value = true
  } catch (err) {
    _error.value = err?.error || t('energy.failed')
  } finally {
    _loading.value = false
  }
}

function reset() {
  _assessed.value = false
  _recommendations.value = []
  _error.value = null
}
</script>

<style scoped>
.energy-page {
  max-width: 480px;
  margin: 0 auto;
  padding: 16px;
}

/* Header */
.form-header,
.results-header {
  text-align: center;
  margin-bottom: 28px;
}
.form-icon {
  font-size: 36px;
  color: var(--gold);
  margin-bottom: 8px;
}
.form-title {
  font-family: var(--serif);
  font-size: 22px;
  color: var(--cream);
  font-weight: bold;
  margin-bottom: 6px;
}
.form-subtitle {
  font-size: 14px;
  color: var(--cream);
  opacity: 0.6;
}

/* Fields */
.field-wrap {
  margin-bottom: 16px;
}
.field-label {
  display: block;
  font-size: 13px;
  color: var(--gold);
  opacity: 0.8;
  margin-bottom: 6px;
  font-weight: 500;
}
.input-with-icon {
  position: relative;
  display: flex;
  align-items: center;
}
.input-icon {
  position: absolute;
  left: 14px;
  font-size: 16px;
  opacity: 0.7;
  z-index: 1;
  pointer-events: none;
}
.energy-input {
  width: 100%;
  padding: 14px 14px 14px 44px;
  background: var(--surface);
  border: 1px solid rgba(139,111,71,0.3);
  border-radius: 12px;
  color: #fff;
  font-size: 14px;
  outline: none;
  transition: border-color 0.2s;
  font-family: var(--sans);
}
.energy-input:focus {
  border-color: var(--gold);
  border-width: 1.5px;
}
.energy-input::placeholder {
  color: rgba(245,240,232,0.3);
}
.energy-select {
  appearance: none;
  cursor: pointer;
  background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 24 24' fill='none' stroke='%23C8A45C' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3E%3Cpolyline points='6 9 12 15 18 9'%3E%3C/polyline%3E%3C/svg%3E");
  background-repeat: no-repeat;
  background-position: right 14px center;
  padding-right: 36px;
}
.energy-select option {
  background: var(--surface);
  color: #fff;
}
.energy-textarea {
  resize: none;
  min-height: 72px;
  padding-top: 12px;
}

/* Element Dots */
.element-dots {
  display: flex;
  gap: 10px;
  margin-top: 10px;
  flex-wrap: wrap;
}
.element-dot {
  display: flex;
  align-items: center;
  gap: 6px;
  padding: 6px 12px;
  background: var(--surface);
  border: 1px solid rgba(200,164,92,0.15);
  border-radius: 20px;
  cursor: pointer;
  transition: all 0.2s;
  font-size: 12px;
  color: var(--cream);
}
.element-dot:hover,
.element-dot.active {
  border-color: var(--gold);
  background: rgba(200,164,92,0.1);
}
.dot {
  width: 12px;
  height: 12px;
  border-radius: 50%;
  flex-shrink: 0;
}
.dot-label {
  font-size: 12px;
}

/* Start Button */
.btn-start {
  width: 100%;
  height: 52px;
  background: var(--gold);
  color: #000;
  border: none;
  border-radius: 12px;
  font-size: 16px;
  font-weight: bold;
  cursor: pointer;
  transition: opacity 0.2s;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: var(--sans);
  margin-top: 12px;
}
.btn-start:hover {
  opacity: 0.9;
}
.btn-start:disabled {
  opacity: 0.5;
  cursor: default;
}

/* Error */
.error-msg {
  color: #ff5252;
  font-size: 13px;
  text-align: center;
  margin-top: 12px;
}

/* Results - No results */
.no-results {
  text-align: center;
  color: var(--cream);
  opacity: 0.6;
  padding: 40px 0;
}

/* Recommendation Cards */
.rec-card {
  background: var(--surface);
  border: 1px solid rgba(200,164,92,0.3);
  border-radius: 16px;
  padding: 20px;
  margin-bottom: 20px;
}

/* Badge */
.rec-badge {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 14px;
}
.badge-dot {
  width: 14px;
  height: 14px;
  border-radius: 50%;
  flex-shrink: 0;
}
.badge-name {
  font-size: 13px;
  font-weight: bold;
  letter-spacing: 1.2px;
}

/* Explanation */
.rec-explanation {
  color: var(--cream);
  font-size: 14px;
  line-height: 1.6;
  margin-bottom: 18px;
}

/* Energy Focus */
.rec-focus {
  color: var(--gold);
  font-family: var(--serif);
  font-style: italic;
  font-size: 16px;
  font-weight: 600;
  line-height: 1.5;
  text-align: center;
  margin-bottom: 18px;
}

/* Rec Sections */
.rec-section {
  margin-bottom: 16px;
}
.rec-section:last-child {
  margin-bottom: 0;
}
.rec-section-title {
  font-size: 13px;
  font-weight: 600;
  color: var(--cream);
  opacity: 0.7;
  margin-bottom: 8px;
}

/* Color Chips */
.color-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 14px;
}
.color-chip {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 4px;
}
.color-swatch {
  width: 24px;
  height: 24px;
  border-radius: 50%;
  border: 1px solid rgba(245,240,232,0.2);
}
.color-label {
  font-size: 11px;
  color: var(--cream);
  opacity: 0.6;
}

/* Material/Crystal Chips */
.chip-wrap {
  display: flex;
  flex-wrap: wrap;
  gap: 8px;
}
.chip {
  padding: 6px 12px;
  border-radius: 20px;
  border: 1px solid rgba(200,164,92,0.2);
  font-size: 12px;
  color: var(--cream);
  opacity: 0.8;
}
.chip-crystal {
  border-color: rgba(200,164,92,0.4);
  cursor: default;
}

/* Try Again Button */
.btn-try-again {
  width: 100%;
  height: 48px;
  background: transparent;
  border: 1px solid rgba(139,111,71,0.6);
  border-radius: 12px;
  color: var(--copper);
  font-size: 15px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.2s;
  font-family: var(--sans);
}
.btn-try-again:hover {
  background: rgba(139,111,71,0.1);
}
</style>
