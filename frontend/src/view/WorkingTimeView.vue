<template>
    <div>
        <WorkingTimes :workingTimes="workingTimesStore.workingTimes" />
    </div>
</template>

<script setup>
import WorkingTimes from '../components/WorkingTime/WorkingTimes.vue'
import { ref, onMounted } from 'vue'
import { userService } from '../service/userService'
import { workingTimeService } from '../service/workingTimeService'
import { useWorkingTimesStore } from '../store/useWorkingTimesStore'

const users = ref([])
const workingTimesStore = useWorkingTimesStore()

onMounted(() => {
    userService.getUsers().then((response) => {
        users.value = response.data
    })
    workingTimeService.getWorkingTimeByUserId(1).then((response) => {
        const workingTimes = response.data

        // sort by start date
        workingTimes.sort((a, b) => new Date(b.start) - new Date(a.start))

        workingTimesStore.setWorkingTimes(workingTimes  )
    })
})
</script>

<style scoped></style>
