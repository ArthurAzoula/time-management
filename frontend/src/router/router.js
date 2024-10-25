import { createRouter, createWebHistory } from 'vue-router'
import WorkingTimeView from '../view/WorkingTimeView.vue'
import User from '../components/Profile/User.vue'
import Graphs from '../components/Chart/Graphs.vue'
import Dashboard from '../view/Dashboard.vue'
import Layout from '../components/Layout/Layout.vue'
import Statistics from '../view/Statistics.vue'
import Register from '../components/Register.vue'
import Login from '../components/Login.vue'
import AdminLayout from '../components/Layout/AdminLayout.vue'
import UserList from '../components/Admin/UserList.vue'
import TeamList from '../components/Admin/TeamList.vue'
import WorkingTimeList from '../components/Admin/WorkingTimeList.vue'
import { useUserStore } from '../store/useUserStore'
import ClockList from '../components/Admin/ClockList.vue'
import Admin from '../view/Admin.vue'

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
    {
        path: '/admin',
        component: AdminLayout,
        meta: { requiresAuth: true, requiresAdmin: true },
        children: [
            { path: '', component: Admin },
            { path: 'users', component: UserList },
            { path: 'teams', component: TeamList },
            { path: 'working-times', component: WorkingTimeList },
            { path: 'clocks', component: ClockList },
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
    const userStore = useUserStore()
    userStore.initializeFromLocalStorage()
    const role = userStore.role

    if (to.matched.some((record) => record.meta.requiresAuth) && !isAuthenticated) {
        next({ name: 'Login' })
    } else if (to.matched.some((record) => record.meta.requiresAdmin) && role !== 'admin' && isAuthenticated) {
        next({ name: 'Dashboard' })
    } else if (to.matched.some((record) => record.meta.requiresAdmin) && !isAuthenticated) {
        next({ name: 'Login' })
    } else {
        next()
    }
})

export default router
