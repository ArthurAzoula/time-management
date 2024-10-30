<template>
    <v-app>
        <v-navigation-drawer app>
            <v-list-item-content class="flex justify-center border-b">
                <v-img :width="150" :height="150" src="/v-logo.svg"></v-img>
            </v-list-item-content>
            <v-list class="my-4">
                <v-list-item-group class="flex flex-col space-y-4 px-8 bg-op">
                    <v-list-item v-for="item in menuItems" :key="item.title" @click="navigate(item.route)">
                        <template v-slot:prepend>
                            <v-icon aria-hidden="false">{{ item.icon }}</v-icon>
                        </template>
                        <v-list-item-content>
                            <v-list-item-title>{{ item.title }}</v-list-item-title>
                        </v-list-item-content>
                    </v-list-item>
                </v-list-item-group>
            </v-list>
        </v-navigation-drawer>
        <v-app-bar
            style="
                background-color: #f6f6f6;
                box-shadow: none;
                display: flex;
                justify-content: space-between;
                padding: 0px 20px;
            "
            app
        >
            <v-toolbar-title
                >Connected as <span class="font-bold">{{ user?.email }}</span>
            </v-toolbar-title>
            <div class="flex items-center gap-2">
                <v-toolbar-title class="hover:underline underline-offset-2 cursor-pointer">{{
                    user?.username
                }}</v-toolbar-title>
                <v-avatar>
                    <v-img src="https://randomuser.me/api/portraits/men/1.jpg" />
                </v-avatar>
            </div>
        </v-app-bar>
        <v-main class="h-screen my-6 mx-8">
            <router-view />
        </v-main>
    </v-app>
</template>

<script setup>
import { onMounted, ref } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '../../store/useUserStore'
import { userService } from '../../service/userService'

const userStore = useUserStore()
userStore.initializeFromLocalStorage()
const user = ref(null)

onMounted(async () => {
    const response = await userService.getUser(userStore.id)

    if (!response) return

    user.value = response.data
})

const router = useRouter()
const menuItems = [
    { title: 'Home', route: '/', icon: 'mdi-home' },
    { title: 'Dashboard', route: '/admin', icon: 'mdi-view-dashboard' },
    { title: 'Users', route: '/admin/users', icon: 'mdi-account' },
    { title: 'Teams', route: '/admin/teams', icon: 'mdi-account-group' },
    { title: 'Working Times', route: '/admin/working-times', icon: 'mdi-clock' },
    { title: 'Clocks', route: '/admin/clocks', icon: 'mdi-timer' },
]

const navigate = (route) => {
    router.push(route)
}
</script>

<style scoped></style>
