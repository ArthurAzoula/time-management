import { defineStore } from 'pinia'
import { jwtDecode } from 'jwt-decode'
import router from '../router/router'
import { toast } from 'vue3-toastify'

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
            localStorage.removeItem('lastConnection')
        },
        initializeFromLocalStorage() {
            const token = localStorage.getItem('token')
            if (token) {
                this.setToken(token)
            }
        },
        logout() {
            this.clearToken()
            router.push({ name: 'Login' })
        },
    },
})
