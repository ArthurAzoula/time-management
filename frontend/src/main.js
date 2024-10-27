import { createApp } from 'vue'
import { createPinia } from 'pinia'
import './style.css'
import App from './App.vue'
import router from './router/router'
import VCalendar from 'v-calendar'
import 'v-calendar/style.css'
import 'vuetify/styles'
import * as components from 'vuetify/components'
import * as directives from 'vuetify/directives'
import { createVuetify } from 'vuetify'
import '@mdi/font/css/materialdesignicons.css'
import { aliases, mdi } from 'vuetify/iconsets/mdi'
import { VueQueryPlugin } from '@tanstack/vue-query'

const vuetify = createVuetify({
    components,
    directives,
    icons: {
        defaultSet: 'mdi',
        aliases,
        sets: {
            mdi,
        },
    },
})
const app = createApp(App)
const pinia = createPinia()

app.use(router)
app.use(VueQueryPlugin)
app.use(vuetify)
app.use(pinia)
app.use(VCalendar, {})
app.mount('#app')
