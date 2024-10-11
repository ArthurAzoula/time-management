import { createRouter, createWebHistory } from 'vue-router'
import App from '../App.vue'
import WorkingTimeView from '../view/WorkingTimeView.vue'
import User from '../components/Profile/User.vue'
import Graphs from '../components/Chart/Graphs.vue'
import Dashboard from '../view/Dashboard.vue'
import Layout from '../components/Layout/Layout.vue'
import Statistics from '../view/Statistics.vue'

const routes = [
    {
        path: '/',
        component: Layout,
        children: [
            { path: '', component: Dashboard },
            { path: 'workingtimes', name: 'WorkingTimes', component: WorkingTimeView },
            { path: 'me', name: 'UserProfile', component: User },
            { path: 'graphs', name: 'Graphs', component: Graphs },
            { path: 'statistics', name: 'Statistics', component: Statistics },
        ],
    },
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes,
})

export default router
