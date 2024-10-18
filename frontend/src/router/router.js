import { createRouter, createWebHistory } from 'vue-router'
import WorkingTimeView from '../view/WorkingTimeView.vue'
import User from '../components/Profile/User.vue'
import Graphs from '../components/Chart/Graphs.vue'
import Dashboard from '../view/Dashboard.vue'
import Layout from '../components/Layout/Layout.vue'
import Statistics from '../view/Statistics.vue'
import Register from '../components/Register.vue'
import Login from '../components/Login.vue'

const routes = [
    {
        path: '/',
        component: Layout,
        children: [
            { path: '', component: Dashboard, meta: { requiresAuth: true } },
            { path: 'workingtimes', name: 'WorkingTimes', component: WorkingTimeView, meta: { requiresAuth: true } },
            { path: 'me', name: 'UserProfile', component: User, meta: { requiresAuth: true } },
            { path: 'graphs', name: 'Graphs', component: Graphs, meta: { requiresAuth: true } },
            { path: 'statistics', name: 'Statistics', component: Statistics, meta: { requiresAuth: true } },
        ],
    },
    { path: '/login', name: 'Login', component: Login },
    { path: '/register', name: 'Register', component: Register },
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes,
})

router.beforeEach((to, from, next) => {
    const isAuthenticated = !!localStorage.getItem('token')
    if (to.matched.some(record => record.meta.requiresAuth) && !isAuthenticated) {
        next({ name: 'Login' })
    } else {
        next()
    }
})

export default router