<template>
    <div class="flex flex-col h-screen">
        <div class="flex flex-col items-center p-4 bg-gray-200">
            <img src="https://via.placeholder.com/250" alt="Profile" class="rounded-full mb-2" />
            <p class="text-lg font-semibold">Voir mon profil</p>
        </div>
        <div class="flex-1 bg-gray-100 p-4">
            <ul>
                <li v-for="item in items" :key="item.id" class="mb-4">
                    <router-link :to="item.to" class="flex items-center p-2 rounded hover:bg-gray-300">
                        <component :is="item.icon" class="w-6 h-6 mr-2" />
                        <span class="text-lg">{{ item.title }}</span>
                    </router-link>
                </li>
            </ul>
        </div>
    </div>
</template>

<script setup>
import { Dashboard, User } from 'lucide-vue-next'

const items = [
    { id: 1, title: 'Dashboard', icon: Dashboard, to: '/' },
    { id: 2, title: 'Temps de travail', icon: User, to: '/workingtime' },
]
</script>
