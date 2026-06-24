import { ref, computed } from 'vue'
import { defineStore } from 'pinia'

export const useCartStore = defineStore('cart', () => {
  const items = ref(JSON.parse(localStorage.getItem('cart') || '[]'))

  const itemCount = computed(() => items.value.reduce((s, i) => s + (i.qty || 1), 0))
  const totalCents = computed(() => items.value.reduce((s, i) => s + (i.price || 0) * (i.qty || 1), 0))
  const totalStr = computed(() => '$' + (totalCents.value / 100).toFixed(2))

  function addItem(product) {
    const idx = items.value.findIndex(i => i.id === product.id)
    if (idx >= 0) {
      items.value[idx].qty = (items.value[idx].qty || 1) + 1
    } else {
      items.value.push({ id: product.id, name: product.name, price: product.price_cents, image: product.images?.[0], qty: 1 })
    }
    save()
  }

  function updateQty(id, qty) {
    const idx = items.value.findIndex(i => i.id === id)
    if (idx >= 0) {
      if (qty <= 0) items.value.splice(idx, 1)
      else items.value[idx].qty = qty
    }
    save()
  }

  function removeItem(id) {
    const idx = items.value.findIndex(i => i.id === id)
    if (idx >= 0) items.value.splice(idx, 1)
    save()
  }

  function clear() {
    items.value = []
    save()
  }

  function save() {
    localStorage.setItem('cart', JSON.stringify(items.value))
  }

  return { items, itemCount, totalCents, totalStr, addItem, updateQty, removeItem, clear }
})
