import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  headers: { 'Content-Type': 'application/json' },
})

api.interceptors.request.use(config => {
  const token = localStorage.getItem('token')
  if (token) config.headers.Authorization = `Bearer ${token}`
  return config
})

api.interceptors.response.use(
  res => res.data,
  err => {
    const data = err.response?.data
    return Promise.reject(data || { error: err.message })
  }
)

export function login(email, password) {
  return api.post('/auth/login', { email, password })
}

export function register(email, password, displayName) {
  return api.post('/auth/register', { email, password, display_name: displayName })
}

export function getProfile() {
  return api.get('/auth/me')
}

export function updateProfile(data) {
  return api.put('/auth/me', data)
}

export function getProducts(params) {
  return api.get('/products', { params })
}

export function getProduct(id) {
  return api.get(`/products?limit=247`).then(res => {
    const products = res.data || []
    const found = products.find(p => p.id === id)
    if (found) return { data: found }
    // fallback: try fetching from specific ID (for after backend fix)
    return api.get(`/products/${id}`)
  })
}

export function getOrders() {
  return api.get('/orders')
}

export function getMyDesigns() {
  return api.get('/designs/mine')
}

export function getDesign(id) {
  return api.get(`/designs/${id}`)
}

export function createDesign(data) {
  return api.post('/designs', data)
}

export function updateDesign(id, data) {
  return api.put(`/designs/${id}`, data)
}

export function publishDesign(id) {
  return api.post(`/designs/${id}/publish`)
}

export function getElements() {
  return api.get('/elements')
}

export function energyAssess(data) {
  return api.post('/energy/assess', data)
}

export function getEnergyHistory() {
  return api.get('/energy/history')
}

export function createOrder(data) {
  return api.post('/orders', data)
}

export function getOrderPaymentIntent(orderId) {
  return api.post(`/orders/${orderId}/payment-intent`, {})
}

export function getEarnings() {
  return api.get('/earnings')
}

// Admin APIs
export function adminGetProducts() {
  return api.get('/admin/products')
}

export function adminCreateProduct(data) {
  return api.post('/admin/products', data)
}

export function adminUpdateProduct(id, data) {
  return api.put(`/admin/products/${id}`, data)
}

export function adminGetElements() {
  return api.get('/admin/elements')
}

export function adminCreateElement(data) {
  return api.post('/admin/elements', data)
}

export function adminUpdateElement(id, data) {
  return api.put(`/admin/elements/${id}`, data)
}

export default api
