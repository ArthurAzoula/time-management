<template>
    <div>
        <div class="p-6 py-12">
            <div class="flex flex-col space-y-7">
                <div class="flex flex-col space-y-7">
                    <h1 class="text-2xl font-bold">Dashboard</h1>
                    <Clock v-if="userId" :userId="userId" />
                </div>
                <Graphs v-if="userId" :userId="userId" />
                <WorkingTimesDashboard :workingTimes="workingTimesStore.workingTimes" />
            </div>
        </div>
    </div>
</template>

<script setup>
import Clock from '../components/Clock/Clock.vue'
import Graphs from '../components/Chart/Graphs.vue'
import WorkingTimesDashboard from '../components/WorkingTime/WorkingTimesDashboard.vue'

import { ref, onMounted } from 'vue'
import { workingTimeService } from '../service/workingTimeService'
import { useWorkingTimesStore } from '../store/useWorkingTimesStore'
import { useUserStore } from '../store/useUserStore'

const workingTimesStore = useWorkingTimesStore()
const userStore = useUserStore()

const userId = ref(null)

onMounted(() => {
    userStore.initializeFromLocalStorage()

    if (userStore.id) {
        userId.value = userStore.id
        workingTimeService.getWorkingTimeByUserId(userStore.id).then((response) => {
            workingTimesStore.setWorkingTimes(response.data)
        })
    }
})
</script>
