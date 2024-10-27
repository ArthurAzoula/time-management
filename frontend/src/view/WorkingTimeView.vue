<template>
    <div>
        <WorkingTimes :workingTimes="workingTimesStore.workingTimes" />
    </div>
</template>

<script setup>
import WorkingTimes from '../components/WorkingTime/WorkingTimes.vue'
import { ref, onMounted, computed } from 'vue'
import { userService } from '../service/userService'
import { workingTimeService } from '../service/workingTimeService'
import { useWorkingTimesStore } from '../store/useWorkingTimesStore'
import { useUserStore } from '../store/useUserStore'

const users = ref([])
const workingTimesStore = useWorkingTimesStore()
const userStore = useUserStore()

const userId = computed(() => userStore.id)
const userRole = computed(() => userStore.role)

onMounted(() => {
    userService.getUsers().then((response) => {
        users.value = response.data
    })
    userStore.initializeFromLocalStorage()
    workingTimeService.getWorkingTimeByUserId(userId.value).then((response) => {
        const workingTimes = response.data

        workingTimes.sort((a, b) => new Date(b.start) - new Date(a.start))

        workingTimesStore.setWorkingTimes(workingTimes)
    })
})
</script>

<style scoped></style>
