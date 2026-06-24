<template>
  <div class="login-page">
    <div class="login-card">
      <h1 class="login-title">AURA</h1>
      <p class="login-sub">{{ isRegister ? 'Create Account' : 'Sign In' }}</p>
      <form @submit.prevent="submit">
        <div class="input-group">
          <input v-model="email" type="email" placeholder="Email" required />
        </div>
        <div class="input-group" v-if="isRegister">
          <input v-model="displayName" type="text" placeholder="Display Name" />
        </div>
        <div class="input-group">
          <input v-model="password" type="password" placeholder="Password" required />
        </div>
        <p v-if="err" class="error-msg">{{ err }}</p>
        <button type="submit" class="btn-gold btn-full" :disabled="loading">
          <span v-if="loading" class="spinner" style="width:18px;height:18px;border-width:2px"></span>
          <span v-else>{{ isRegister ? 'Register' : 'Sign In' }}</span>
        </button>
      </form>
      <p class="switch" @click="isRegister = !isRegister">
        {{ isRegister ? 'Already have an account?' : "Don't have an account?" }}
        <span class="switch-link">{{ isRegister ? 'Sign In' : 'Register' }}</span>
      </p>
    </div>
  </div>
</template>

<script setup>
import { useI18n } from '../composables/useI18n'
const { t } = useI18n()
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { useAuthStore } from '../stores/auth'

const router = useRouter()
const auth = useAuthStore()
const isRegister = ref(false)
const email = ref('')
const password = ref('')
const displayName = ref('')
const err = ref('')
const loading = ref(false)

async function submit() {
  err.value = ''
  loading.value = true
  try {
    if (isRegister.value) {
      await auth.register(email.value, password.value, displayName.value || email.value.split('@')[0])
    } else {
      await auth.login(email.value, password.value)
    }
    router.push('/')
  } catch (e) {
    err.value = e?.error || e?.message || 'Something went wrong'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.login-page {
  min-height: 100vh; display: flex; align-items: center; justify-content: center;
  background: var(--bg); padding: 24px;
}
.login-card {
  width: 100%; max-width: 360px; text-align: center;
}
.login-title {
  font-family: var(--serif); font-size: 48px; color: var(--gold);
  letter-spacing: 8px; margin-bottom: 4px;
}
.login-sub { color: var(--cream); opacity: .5; font-size: 14px; margin-bottom: 32px; letter-spacing: 1px; }
.input-group { margin-bottom: 12px; }
.error-msg { color: #e74c3c; font-size: 13px; margin: 8px 0; }
.btn-full { width: 100%; margin-top: 8px; min-height: 44px; }
.switch { margin-top: 24px; font-size: 13px; color: var(--cream); opacity: .6; cursor: pointer; }
.switch-link { color: var(--gold); text-decoration: underline; }
</style>
