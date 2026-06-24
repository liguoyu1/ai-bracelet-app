import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import api from '../api'

export const useFavoriteStore = defineStore('favorites', () => {
  const ids = ref(JSON.parse(localStorage.getItem('favs') || '[]'))

  function toggle(id) {
    const idx = ids.value.indexOf(id)
    if (idx >= 0) ids.value.splice(idx, 1)
    else ids.value.push(id)
    localStorage.setItem('favs', JSON.stringify(ids.value))
  }

  function isFav(id) {
    return ids.value.includes(id)
  }

  return { ids, toggle, isFav }
})
