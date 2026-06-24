import { createRouter, createWebHistory } from 'vue-router'

const routes = [
  { path: '/', name: 'home', component: () => import('../views/Home.vue') },
  { path: '/products', name: 'products', component: () => import('../views/Products.vue') },
  { path: '/products/:id', name: 'product-detail', component: () => import('../views/ProductDetail.vue') },
  { path: '/login', name: 'login', component: () => import('../views/Login.vue') },
  { path: '/cart', name: 'cart', component: () => import('../views/Cart.vue') },
  { path: '/profile', name: 'profile', component: () => import('../views/Profile.vue') },
  { path: '/designer', name: 'designer', component: () => import('../views/Designer.vue') },
  { path: '/energy', name: 'energy', component: () => import('../views/Energy.vue') },
  { path: '/order', name: 'order', component: () => import('../views/Order.vue') },
  { path: '/order-status', name: 'order-status', component: () => import('../views/OrderStatus.vue') },
  { path: '/admin', name: 'admin', component: () => import('../views/Admin.vue') },
]

export default createRouter({
  history: createWebHistory(),
  routes,
})
