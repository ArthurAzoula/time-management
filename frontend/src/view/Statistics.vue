<template>
    <div>
        <div class="p-6 py-12 overflow-x-hidden">
            <h2 class="text-2xl font-bold">My Statistics</h2>
            <div class="flex justify-between py-6">
                <HoursWork :workingTimes="workingTimesStore.workingTimes" />
                <AverageHoursWork :workingTimes="workingTimesStore.workingTimes" />
                <MostProductiveDay :workingTimes="workingTimesStore.workingTimes" />
            </div>
            <ViewPerMonths :workingTimes="workingTimesStore.workingTimes" />
        </div>
    </div>
</template>

<script setup>
import { useWorkingTimesStore } from '../store/useWorkingTimesStore'
import HoursWork from '../components/Stats/HoursWork.vue'
import AverageHoursWork from '../components/Stats/AverageHoursWork.vue'
import MostProductiveDay from '../components/Stats/MostProductiveDay.vue'
import ViewPerMonths from '../components/Stats/ViewPerMonths.vue'

const workingTimesStore = useWorkingTimesStore()
</script>
