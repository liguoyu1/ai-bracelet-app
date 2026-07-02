<template>
  <div id="app-root">
    <main :class="{ 'has-tabs': true }">
      <router-view />
    </main>
    <nav class="bottom-nav">
      <router-link to="/" class="tab" :class="{ active: $route.path === '/' }">
        <span class="tab-icon">✦</span>
        <span class="tab-label">{{ t('nav.shop') }}</span>
      </router-link>
      <router-link to="/designs" class="tab" :class="{ active: $route.path === '/designs' }">
        <span class="tab-icon">♢</span>
        <span class="tab-label">Community</span>
      </router-link>
      <router-link to="/designer" class="tab" :class="{ active: $route.path === '/designer' }">
        <span class="tab-icon">◇</span>
        <span class="tab-label">{{ t('nav.designStudio') }}</span>
      </router-link>
      <router-link to="/energy" class="tab" :class="{ active: $route.path === '/energy' }">
        <span class="tab-icon">◎</span>
        <span class="tab-label">{{ t('nav.energy') }}</span>
      </router-link>
      <router-link to="/cart" class="tab" :class="{ active: $route.path === '/cart' }">
        <span class="tab-icon">🛒</span>
        <span class="tab-label">{{ t('nav.cart') }}</span>
        <span v-if="cart.itemCount" class="tab-badge">{{ cart.itemCount }}</span>
      </router-link>
      <router-link to="/profile" class="tab" :class="{ active: $route.path === '/profile' }">
        <span class="tab-icon">◉</span>
        <span class="tab-label">{{ t('nav.profile') }}</span>
      </router-link>
    </nav>
  </div>
</template>

<script setup>
import { useI18n } from './composables/useI18n'
import { useCartStore } from './stores/cart'
const { t, lang, setLanguage, locales, flags, names } = useI18n()
const cart = useCartStore()
</script>

<style>
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  background: #0A0A0A; color: #F5F0E8;
  font-family: 'Helvetica', 'Arial', sans-serif;
  -webkit-font-smoothing: antialiased;
}
a { color: #C8A45C; text-decoration: none; }
button { cursor: pointer; border: none; font-family: inherit; }

main { padding-bottom: 70px; min-height: 100vh; }
.bottom-nav {
  position: fixed; bottom: 0; left: 0; right: 0; z-index: 100;
  display: flex; background: rgba(26,26,26,0.95);
  -webkit-backdrop-filter: blur(10px); backdrop-filter: blur(10px);
  border-top: 1px solid rgba(200,164,92,0.15);
  padding: 6px 0 env(safe-area-inset-bottom);
}
.tab {
  flex: 1; display: flex; flex-direction: column; align-items: center; gap: 2px;
  padding: 6px 0; color: rgba(245,240,232,0.4); text-decoration: none;
  font-size: 10px; letter-spacing: 0.5px; position: relative;
  transition: color .2s; cursor: pointer;
}
.tab.active, .tab:hover { color: #C8A45C; }
.tab-icon { font-size: 20px; line-height: 1; }
.tab-label { font-size: 10px; text-transform: uppercase; letter-spacing: 0.5px; }
.tab-badge {
  position: absolute; top: 0; right: 50%; transform: translateX(16px);
  background: #C8A45C; color: #0A0A0A; font-size: 9px; font-weight: 700;
  width: 16px; height: 16px; border-radius: 50%; display: flex;
  align-items: center; justify-content: center;
}

/* Global button styles */
.btn-gold {
  background: transparent; border: 1px solid #C8A45C; color: #C8A45C;
  padding: 12px 24px; border-radius: 12px; font-size: 14px; font-weight: 600;
  transition: all .2s; cursor: pointer; display: inline-flex; align-items: center; justify-content: center;
}
.btn-gold:hover { background: #C8A45C; color: #0A0A0A; }
.btn-gold:disabled { opacity: .4; cursor: default; }

.btn-gold-solid {
  background: #C8A45C; color: #0A0A0A; border: none;
  padding: 12px 24px; border-radius: 12px; font-size: 14px; font-weight: 600;
  transition: opacity .2s; cursor: pointer; display: inline-flex; align-items: center; justify-content: center;
}
.btn-gold-solid:hover { opacity: .9; }
.btn-gold-solid:disabled { opacity: .4; cursor: default; }

.spinner {
  width: 24px; height: 24px; border: 3px solid rgba(200,164,92,0.2);
  border-top-color: #C8A45C; border-radius: 50%; animation: spin .8s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

.loading-state { display: flex; justify-content: center; padding: 40px 0; }
.error-state { text-align: center; padding: 40px 20px; opacity: .6; font-size: 14px; }
.empty-state { text-align: center; padding: 60px 20px; opacity: .5; font-size: 14px; }

.fav-btn {
  position:absolute; top:8px; right:8px; width:32px; height:32px;
  background:rgba(10,10,10,0.5); border-radius:50%; display:flex;
  align-items:center; justify-content:center; font-size:15px;
  cursor:pointer; z-index:2; line-height:1; transition: background .2s;
}
.fav-btn:hover { background:rgba(10,10,10,0.7); }

.load-more { text-align: center; padding: 12px 0 40px; }

/* Flutter-style card */
.card {
  background: #1A1A1A; border-radius: 12px; overflow: hidden;
  border: 1px solid rgba(200,164,92,0.1);
}
</style>
