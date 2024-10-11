<template>
    <div class="menu-layout m-6 rounded-lg bg-button-300 m2 w-1/4 h-screen">
        <div class="flex items-center space-x-4 mb-8">
            <img
                class="rounded-full mb-6 mt-10 w-24 h-24 ml-6"
                src="https://via.placeholder.com/50"
                alt="Profile Picture"
            />
            <router-link
                to="/myProfil"
                @click="setActive('myProfil')"
                :class="{ active: activeLink === 'myProfil' }"
                class="text-xl font-semibold"
            >
                My Profil
            </router-link>
        </div>
        <nav class="w-full">
            <ul class="flex flex-col space-y-6 items-center">
                <li class="text-left" @click="setActive('dashboard')" :class="{ active: activeLink === 'dashboard' }">
                    <router-link to="/dashboard">Dashboard</router-link>
                </li>
                <li class="text-left" @click="setActive('clocks')" :class="{ active: activeLink === 'clocks' }">
                    <router-link to="/workingtime">Temps de travail</router-link>
                </li>
            </ul>

            <!-- Barre de sélection -->
            <div v-if="activeLink" class="active-bar"></div>
        </nav>
    </div>
</template>

<script>
import { Camera } from 'lucide-vue-next'

export default {
    name: 'Menu',
    data() {
        return {
            activeLink: '',
        }
    },
    methods: {
        setActive(link) {
            this.activeLink = link
        },
    },
}
</script>

<style scoped></style>
