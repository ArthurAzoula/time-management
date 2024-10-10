import { createRouter, createWebHistory } from 'vue-router'
import App from '../App.vue'
import Clock from '../components/Clock/Clock.vue'

const routes = [
    { path: '/', component: App },
    { path: '/dashboard', component: Clock },
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes,
})

export default router
