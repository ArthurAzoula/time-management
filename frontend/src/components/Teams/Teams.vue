<template>
    <div class="teams-container py-12 p-6">
        <h1 class="title text-2xl font-bold mb-6 text-gray-800">My Teams</h1>
        <div v-if="teams.length > 0" class="teams-list flex flex-wrap gap-6 py-6">
            <div v-for="team in teams" :key="team.id" class="team-card bg-white rounded-lg border p-6 max-w-xs w-full">
                <p class="team-name text-xl font-semibold mb-4 text-gray-700">{{ team.name }}</p>
                <ul class="team-members list-none p-0">
                    <li
                        v-for="member in team.members"
                        :key="member.user_id"
                        class="team-member rounded px-4 py-2 mb-2 bg-button-300 flex items-center"
                    >
                        <img
                            :src="`https://randomuser.me/api/portraits/men/${member.user_id}.jpg`"
                            alt="avatar"
                            class="rounded-full w-12 h-12 mr-4"
                        />
                        <router-link
                            :to="{
                                name: 'UserWorkingTimes',
                                params: { username: member.username, id: member.user_id },
                            }"
                            class="member-info text-base text-gray-800"
                        >
                            {{ member.username }}
                        </router-link>
                    </li>
                </ul>
            </div>
        </div>
        <div v-else class="no-data text-center text-xl text-gray-600">
            <p>No team data available.</p>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useUserStore } from '../../store/useUserStore'
import { teamService } from '../../service/teamService'

const teams = ref([])
const userStore = useUserStore()

onMounted(async () => {
    userStore.initializeFromLocalStorage()
    const userId = userStore.id
    if (userId) {
        try {
            const response = await teamService.getUserOfTeam(userId)
            if (response.data && response.data.length > 0) {
                teams.value = response.data.map((item) => item.team)
            } else {
                console.error('No team data received from the server')
            }
        } catch (error) {
            console.error('Failed to fetch team members:', error)
        }
    }
})
</script>

<style scoped>
.teams-container {
    padding: 24px;
}
</style>
