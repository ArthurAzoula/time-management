import { defineStore } from 'pinia'
import {jwtDecode} from 'jwt-decode'

export const useUserStore = defineStore('user', {
  state: () => ({
    id: null,
    role: null,
    token: null,
  }),
  actions: {
    setToken(token) {
      this.token = token
      const decoded = jwtDecode(token)
      this.id = decoded.id
      this.role = decoded.role
    },
    clearToken() {
      this.token = null
      this.id = null
      this.role = null
      localStorage.removeItem('token')
    },
    initializeFromLocalStorage() {
      const token = localStorage.getItem('token')
      if (token) {
        this.setToken(token)
      }
    },
  },
})