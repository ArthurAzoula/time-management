import { createRouter, createWebHistory } from 'vue-router'
import App from '../App.vue'
import WorkingTimeView from '../view/WorkingTimeView.vue'
import User from '../components/Profile/User.vue'
import Graphs from '../components/Chart/Graphs.vue'
import Dashboard from '../view/Dashboard.vue'
import Layout from '../components/Layout/Layout.vue'

const routes = [
    {
        path: '/',
        component: Layout,
        children: [
            { path: '', component: Dashboard },
            { path: 'workingtimes', name: 'WorkingTimes', component: WorkingTimeView },
            { path: 'myProfil', name: 'UserProfile', component: User },
            { path: 'graphs', name: 'Graphs', component: Graphs },
        ],
    },
]

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes,
})

export default router
