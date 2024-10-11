<template>
    <div class="flex h-full">
        <!-- Menu fixe à gauche -->
        <div
            class="menu-layout fixed top-0 left-0 bottom-0 m-6 rounded-lg bg-button-300 w-1/6 h-full flex flex-col items-start p-4"
        >
            <div class="flex flex-col items-center mb-8 w-full">
                <router-link to="/me" @click="setActive('myProfil')">
                    <img
                        class="rounded-full mb-6 mt-4 w-28 h-28"
                        src="https://randomuser.me/api/portraits/men/1.jpg"
                        alt="Profile Picture"
                    />
                    <p class="hover:underline">View my profile</p>
                </router-link>
            </div>
            <nav class="w-full">
                <ul class="flex flex-col space-y-4 ml-4 mr-4">
                    <router-link to="/" class="font-regular">
                        <li
                            class="flex items-center gap-4 w-full hover:bg-menu-100 cursor-pointer transition duration-200 ease-in-out p-2 transform hover:p-2 rounded"
                            @click="setActive('dashboard')"
                            :class="{ active: activeLink === 'dashboard' }"
                        >
                            <DashboardIcon />
                            <p>Dashboard</p>
                        </li>
                    </router-link>
                    <router-link to="/workingtimes" class="font-regular">
                        <li
                            class="flex items-center gap-4 w-full hover:bg-menu-100 cursor-pointer transition duration-200 ease-in-out p-2 transform hover:p-2 rounded"
                            @click="setActive('workingtimes')"
                            :class="{ active: activeLink === 'workingtimes' }"
                        >
                            <WorkingTimeIcon />
                            <p>Working time</p>
                        </li>
                    </router-link>
                    <router-link to="/statistics" class="font-regular">
                        <li
                            class="flex items-center gap-4 w-full hover:bg-menu-100 cursor-pointer transition duration-200 ease-in-out p-2 transform hover:p-2 rounded"
                            @click="setActive('statistics')"
                            :class="{ active: activeLink === 'statistics' }"
                        >
                            <ChartColumnBigIcon strokeWidth="1.5" />
                            <p>Statistics</p>
                        </li>
                    </router-link>
                </ul>
                <div v-if="activeLink" class="active-bar"></div>
            </nav>
        </div>

        <!-- Contenu principal à côté du menu fixe -->
        <div class="content flex-1 ml-[18%] px-6">
            <router-view></router-view>
        </div>
    </div>
</template>

<script setup>
import DashboardIcon from '../../icons/DashboardIcon.vue'
import WorkingTimeIcon from '../../icons/WorkingTimeIcon.vue'
import { ChartColumnBigIcon } from 'lucide-vue-next'
</script>

<script>
export default {
    name: 'Layout',
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

<style scoped>
.menu-layout {
    top: 0;
    left: 0;
    bottom: 0;
}

.active {
    background-color: #ffd4a2;
}
</style>
