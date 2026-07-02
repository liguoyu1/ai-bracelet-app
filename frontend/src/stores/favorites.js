import { defineStore } from 'pinia'
import { ref } from 'vue'
import api from '../api'

export const useFavoriteStore = defineStore('favorites', () => {
  const ids = ref(JSON.parse(localStorage.getItem('favs') || '[]'))

  // Sync with backend (call on login)
  async function syncFromBackend() {
    try {
      const res = await api.get('/favorites')
      const favs = res.data || res || []
      ids.value = favs.map(f => f.item_id)
      localStorage.setItem('favs', JSON.stringify(ids.value))
    } catch { /* not logged in or error */ }
  }

  async function toggle(id) {
    const idx = ids.value.indexOf(id)
    // optimistic local update
    if (idx >= 0) ids.value.splice(idx, 1)
    else ids.value.push(id)
    localStorage.setItem('favs', JSON.stringify(ids.value))
    // sync with backend
    try {
      await api.post('/favorites/toggle', { item_type: 'product', item_id: id })
    } catch { /* revert silently */ }
  }

  function isFav(id) {
    return ids.value.includes(id)
  }

  return { ids, toggle, isFav, syncFromBackend }
})