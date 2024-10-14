<template>
    <div class="flex flex-col md:flex-row h-full">
        <button
            class="fixed top-4 left-4 z-50 md:hidden"
            @click="toggleMenu"
        >
            <svg class="w-8 h-8 text-gray-800" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7"></path>
            </svg>
        </button>

          <div
            :class="['menu-layout fixed md:top-0 md:left-0 md:bottom-0 md:m-6 md:rounded-lg md:bg-button-300 md:w-1/6 md:h-full flex flex-col items-start p-4 transition-transform duration-300 z-10', { 'top-0 left-0 w-full h-auto bg-button-300': isMenuOpen, '-translate-y-full': !isMenuOpen && !isDesktop, 'translate-y-0': isMenuOpen || isDesktop }]"
        >
            <div class="flex flex-col items-center mb-8 w-full">
                <router-link to="/me" @click="setActive('myProfil')">
                    <img
                        class="rounded-full mb-6 mt-4 w-28 h-28 object-cover"
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

        <div :class="['content flex-1 px-6 transition-all duration-300', { 'ml-[18%]': isDesktop, 'ml-0': !isDesktop }]">
            <router-view></router-view>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import DashboardIcon from '../../icons/DashboardIcon.vue'
import WorkingTimeIcon from '../../icons/WorkingTimeIcon.vue'
import { ChartColumnBigIcon } from 'lucide-vue-next'

const isMenuOpen = ref(false)
const isDesktop = ref(false)

const toggleMenu = () => {
    isMenuOpen.value = !isMenuOpen.value
}

const setActive = (link) => {
    activeLink.value = link
}

const activeLink = ref('')

const handleResize = () => {
    isDesktop.value = window.innerWidth >= 768
    if (isDesktop.value) {
        isMenuOpen.value = true
    } else {
        isMenuOpen.value = false
    }
}

onMounted(() => {
    handleResize()
    window.addEventListener('resize', handleResize)
})

</script>

<style scoped>
.menu-layout {
    transition: transform 0.3s ease-in-out;
}

.active {
    background-color: #ffd4a2;
}

@media (min-width: 768px) {
    .menu-layout {
        transform: translateY(0);
    }
}
</style>