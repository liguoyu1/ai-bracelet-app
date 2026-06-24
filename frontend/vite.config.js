import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    proxy: {
      '/api': {
        target: 'https://backend-production-4e7f.up.railway.app',
        changeOrigin: true,
      }
    }
  }
})
