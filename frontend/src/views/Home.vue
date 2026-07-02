<template>
  <div class="home">
    <div class="home-scroll">
      <!-- HERO BANNER -->
      <section class="hero" :style="{ height: isShort ? '280px' : '400px' }">
        <div class="hero-deco">✦</div>
        <div class="hero-content">
          <h1 class="hero-title">{{ t('home.title') }}</h1>
          <p class="hero-tagline">{{ t('home.tagline') }}</p>
          <div class="hero-actions">
            <router-link to="/products" class="btn-gold">{{ t('home.shopCollection') }}</router-link>
            <router-link to="/designer" class="btn-outline-gold">{{ t('home.designYours') }}</router-link>
          </div>
        </div>
        <div class="hero-lang" @click.stop="showLang = !showLang">
          <span class="lang-btn"><span class="lang-icon">🌐</span> {{ flags[lang] }}</span>
          <div v-if="showLang" class="lang-dropdown-hero" @click.stop>
            <div v-for="l in locales" :key="l" class="lang-item" :class="{active: l===lang}" @click="setLanguage(l); showLang=false">
              {{ flags[l] }} {{ names[l] }}
            </div>
          </div>
        </div>
      </section>

      <!-- BESTSELLERS -->
      <section class="section">
        <div class="section-header">
          <h2 class="section-title">{{ t('home.bestsellers') }}</h2>
          <router-link to="/products" class="section-link">{{ t('home.viewAll') }}</router-link>
        </div>
        <div v-if="loadingFeatured" class="loading-state"><div class="spinner"></div></div>
        <div v-else class="hscroll-wrap">
          <div class="hscroll" ref="hscroll">
            <div v-for="p in featured" :key="p.id" class="hcard product-card" @click="$router.push('/products/' + p.id)">
              <div class="card-img">
                <img v-if="p.images?.[0]" :src="p.images[0]" :alt="p.name" @error="e => e.target.style.display='none'" />
                <div v-else class="no-img">✦</div>
                <div class="fav-btn" @click.stop="fav.toggle(p.id)">{{ fav.isFav(p.id) ? '❤️' : '🤍' }}</div>
              </div>
              <div class="card-body">
                <h3 class="card-name">{{ p.name }}</h3>
                <p class="card-price">{{ formatPrice(p.price_cents) }}</p>
              </div>
            </div>
          </div>
        </div>
      </section>

      <!-- CATEGORIES -->
      <section class="section">
        <div class="section-header">
          <h2 class="section-title">{{ t('home.categories') }}</h2>
        </div>
        <div class="hscroll-wrap">
          <div class="hscroll" ref="catScroll">
            <div v-for="cat in categories" :key="cat.key" class="cat-card" @click="$router.push('/products?cat=' + cat.key)">
              <span class="cat-icon">{{ cat.icon }}</span>
              <span class="cat-name">{{ cat.name }}</span>
            </div>
          </div>
        </div>
      </section>

      <!-- ENERGY CTA -->
      <section class="section">
        <div class="energy-cta" @click="$router.push('/energy')">
          <div class="energy-cta-content">
            <h3 class="energy-cta-title">{{ t('home.discoverEnergy') }}</h3>
            <p class="energy-cta-sub">{{ t('home.energySubtitle') }}</p>
            <span class="btn-energy">{{ t('home.startAssessment') }}</span>
          </div>
          <div class="energy-cta-deco">✦</div>
        </div>
      </section>

      <div style="height:20px"></div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { getProducts } from '../api'
import { useI18n } from '../composables/useI18n'
import { useFavoriteStore } from '../stores/favorites'
const { t, lang, setLanguage, locales, flags, names } = useI18n()
const fav = useFavoriteStore()

const featured = ref([])
const loadingFeatured = ref(true)
const showLang = ref(false)
const isShort = ref(false)

const categories = [
  { key: 'crystal', name: 'Crystal', icon: '💎' },
  { key: 'stone', name: 'Stone', icon: '⛰️' },
  { key: 'jade', name: 'Jade', icon: '🌿' },
  { key: 'pearl', name: 'Pearl', icon: '🦪' },
  { key: 'aromatherapy', name: 'Aromatherapy', icon: '🌸' },
  { key: 'wood', name: 'Wood', icon: '🪵' },
]

function formatPrice(cents) { return '$' + (cents / 100).toFixed(2) }
function onResize() { isShort.value = window.innerHeight < 700 }
function closeLang(e) { if (!e.target.closest('.hero-lang')) showLang.value = false }

onMounted(() => {
  onResize()
  window.addEventListener('resize', onResize)
  document.addEventListener('click', closeLang)
  getProducts({ limit: 8, sort: 'sales' }).then(r => {
    featured.value = r.data || []
  }).finally(() => loadingFeatured.value = false)
})
onUnmounted(() => {
  window.removeEventListener('resize', onResize)
  document.removeEventListener('click', closeLang)
})
</script>

<style scoped>
.hero {
  width: 100%; display: flex; flex-direction: column; align-items: center; justify-content: center;
  background: linear-gradient(180deg, #0A0A0A 0%, #1A1A1A 100%);
  text-align: center; position: relative; overflow: hidden;
}
.hero-deco {
  position: absolute; font-size: 200px; color: var(--gold); opacity: .06;
  top: -40px; right: -40px; pointer-events: none; font-family: var(--serif);
}
.hero-content { position: relative; z-index: 1; padding: 0 28px; width: 100%; max-width: 500px; margin: 0 auto; }
.hero-title {
  font-family: var(--serif); font-size: clamp(40px, 10vw, 56px);
  color: var(--gold); letter-spacing: 8px; margin-bottom: 12px;
}
.hero-tagline {
  color: var(--cream); opacity: .5; font-size: 14px;
  letter-spacing: 2px; font-weight: 300; margin-bottom: 32px;
}
.hero-actions { display: flex; gap: 12px; justify-content: center; flex-wrap: wrap; }
.hero-lang {
  position: absolute; right: 16px; top: 8px; z-index: 10;
}
.lang-btn {
  display: inline-flex; align-items: center; gap: 4px; padding: 4px 10px;
  background: rgba(200,164,92,0.15); border-radius: 20px;
  border: 1px solid rgba(200,164,92,0.3); cursor: pointer; font-size: 14px; line-height: 1;
}
.lang-icon { font-size: 14px; }
.lang-dropdown-hero {
  position: absolute; top: 100%; right: 0; margin-top: 4px;
  background: var(--surface); border: 1px solid rgba(200,164,92,0.2);
  border-radius: 8px; padding: 4px; min-width: 140px; z-index: 200;
}
.lang-item { padding: 6px 10px; border-radius: 6px; font-size: 13px; cursor: pointer; color: var(--cream); white-space: nowrap; }
.lang-item:hover { background: rgba(200,164,92,0.1); }
.lang-item.active { color: var(--gold); }

.section { padding: 0 0 24px; }
.section-header { display: flex; justify-content: space-between; align-items: center; padding: 0 20px; margin-bottom: 16px; }
.section-title {
  font-family: var(--serif); font-size: 22px; color: var(--gold); letter-spacing: 2px;
}
.section-link { color: var(--gold); font-size: 13px; letter-spacing: 1px; opacity: .8; text-decoration: none; }
.section-link:hover { opacity: 1; }

/* Horizontal scroll */
.hscroll-wrap { overflow-x: auto; -webkit-overflow-scrolling: touch; padding: 0 16px; }
.hscroll-wrap::-webkit-scrollbar { display: none; }
.hscroll { display: flex; gap: 12px; }
.hcard { min-width: 180px; max-width: 180px; cursor: pointer; transition: transform .2s, border-color .2s; }
.hcard:hover { transform: translateY(-4px); border-color: rgba(200,164,92,0.3); }

.product-card {
  background: var(--surface); border-radius: 12px; overflow: hidden;
  border: 1px solid rgba(200,164,92,0.1);
}
.card-img { height: 180px; background: var(--card); position: relative; overflow: hidden; }
.card-img img { width: 100%; height: 100%; object-fit: cover; }
.card-body { padding: 10px 12px 12px; }
.card-name { font-family: var(--serif); font-size: 15px; color: var(--cream); font-weight: 600; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.card-price { font-size: 15px; color: var(--gold); font-weight: 700; }
.no-img { display: flex; align-items: center; justify-content: center; height: 100%; color: var(--gold); opacity: .3; font-size: 32px; }

/* Category cards - horizontal */
.cat-card {
  min-width: 120px; height: 120px; display: flex; flex-direction: column;
  align-items: center; justify-content: center; gap: 8px;
  background: var(--surface); border: 1px solid rgba(200,164,92,0.1);
  border-radius: 12px; cursor: pointer; transition: all .2s;
}
.cat-card:hover { border-color: rgba(200,164,92,0.3); transform: translateY(-2px); }
.cat-icon { font-size: 24px; }
.cat-name { font-family: var(--serif); color: var(--cream); font-size: 14px; letter-spacing: 1px; }

/* Energy CTA */
.energy-cta {
  margin: 0 16px; padding: 28px; border-radius: 16px;
  background: linear-gradient(135deg, #C8A45C, #8B7355);
  position: relative; overflow: hidden; cursor: pointer;
}
.energy-cta-content { position: relative; z-index: 1; }
.energy-cta-deco {
  position: absolute; right: -10px; bottom: -10px; font-size: 100px; opacity: .08; pointer-events: none;
  color: #000;
}
.energy-cta-title {
  font-family: var(--serif); font-size: 24px; color: #000; font-weight: 500; margin-bottom: 8px;
}
.energy-cta-sub {
  font-size: 13px; color: rgba(0,0,0,0.7); margin-bottom: 20px;
}
.btn-energy {
  display: inline-block; padding: 10px 24px; border-radius: 8px;
  background: #0A0A0A; color: #C8A45C; font-size: 14px; font-weight: 600; letter-spacing: 1px;
}
.btn-outline-gold {
  display: inline-flex; align-items: center; padding: 12px 24px; border-radius: 12px;
  border: 1px solid var(--gold); color: var(--gold); font-size: 14px; font-weight: 600;
  background: transparent; text-decoration: none; transition: all .2s;
}
.btn-outline-gold:hover { background: var(--gold); color: var(--bg); }

/* General */
.loading-state { display: flex; justify-content: center; padding: 40px 0; }
.fav-btn { position:absolute; top:8px; right:8px; width:32px; height:32px;
  background:rgba(10,10,10,0.5); border-radius:50%; display:flex;
  align-items:center; justify-content:center; font-size:15px;
  cursor:pointer; z-index:2; line-height:1;
}
</style>