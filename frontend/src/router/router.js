import { createRouter, createWebHistory } from 'vue-router'
import {jwtDecode} from 'jwt-decode'
import WorkingTimeView from '../view/WorkingTimeView.vue'
import User from '../components/Profile/User.vue'
import Graphs from '../components/Chart/Graphs.vue'
import Dashboard from '../view/Dashboard.vue'
import Layout from '../components/Layout/Layout.vue'
import Statistics from '../view/Statistics.vue'
import Register from '../components/Register.vue'
import Login from '../components/Login.vue'
import Teams from '../components/Teams/Teams.vue'
import UserWorkingTimes from '../components/WorkingTime/UserWorkingTimes.vue'

const routes = [
    {
        path: '/',
        component: Layout,
        children: [
            { path: '', name: 'Home', component: Dashboard, meta: { requiresAuth: true } },
            { path: 'workingtimes', name: 'WorkingTimes', component: WorkingTimeView, meta: { requiresAuth: true } },
            { path: 'workingtimes/:username/:id', name: 'UserWorkingTimes', component: UserWorkingTimes, meta: { requiresAuth: true, roles: ['manager', 'admin'] } },
            { path: 'me', name: 'UserProfile', component: User, meta: { requiresAuth: true } },
            { path: 'graphs', name: 'Graphs', component: Graphs, meta: { requiresAuth: true } },
            { path: 'statistics', name: 'Statistics', component: Statistics, meta: { requiresAuth: true } },
            { path: 'teams', name: 'Teams', component: Teams, meta: { requiresAuth: true, roles: ['manager', 'admin'] } },
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
    const token = localStorage.getItem('token')
    const isAuthenticated = !!token

    if (to.matched.some(record => record.meta.requiresAuth)) {
        if (!isAuthenticated) {
            next({ name: 'Login' })
        } else {
            const decodedToken = jwtDecode(token)
            const userRole = decodedToken.role

            if (to.matched.some(record => record.meta.roles)) {
                const requiredRoles = to.meta.roles
                if (requiredRoles.includes(userRole)) {
                    next()
                } else {
                    next({ name: 'Home' }) 
                }
            } else {
                next()
            }
        }
    } else {
        next()
    }
})

export default router