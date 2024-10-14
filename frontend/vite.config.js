// vite.config.js
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    host: '0.0.0.0', // Seulement en sudo ( sudo npm run dev )
    port: 80,
    open: true
  }
})
