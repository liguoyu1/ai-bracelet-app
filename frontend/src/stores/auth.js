import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { login as apiLogin, register as apiRegister, getProfile } from '../api'

export const useAuthStore = defineStore('auth', () => {
  const token = ref(localStorage.getItem('token') || '')
  const user = ref(null)

  const isLoggedIn = computed(() => !!token.value)

  async function login(email, password) {
    const res = await apiLogin(email, password)
    const t = res.data?.token
    if (t) {
      token.value = t
      localStorage.setItem('token', t)
    }
    return res.data
  }

  async function register(email, password, name) {
    const res = await apiRegister(email, password, name)
    const t = res.data?.token
    if (t) {
      token.value = t
      localStorage.setItem('token', t)
    }
    return res.data
  }

  async function fetchProfile() {
    if (!token.value) return null
    try {
      const res = await getProfile()
      user.value = res.data || res
      return user.value
    } catch {
      logout()
      return null
    }
  }

  function logout() {
    token.value = ''
    user.value = null
    localStorage.removeItem('token')
  }

  return { token, user, isLoggedIn, login, register, fetchProfile, logout }
})
