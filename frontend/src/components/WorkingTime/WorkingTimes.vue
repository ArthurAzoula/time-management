<template>
    <div>
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6 w-3/4">
            <div v-for="time in workingTimes" :key="time.id"
                class="bg-white border-2 border-text-color-100 rounded-lg p-4 h-48 w-80 flex flex-col justify-between">
                <div class="mb-4 flex justify-between bg-workingHeader-100 text-text-color-100 rounded-xl">
                    <h2 class="m-3">Total duration</h2>
                    <h2 class="font-bold m-3">{{ calculateDuration(time.start, time.end) }}</h2>
                </div>
                <div class="flex justify-between w-11/12 mx-auto text-text-color-100 font-bold">
                    <p>{{ formatTime(time.start) }}</p>
                    <p>{{ formatTime(time.end) }}</p>
                </div>
                <div class="mt-4 text-text-color-purple font-semibold flex justify-between">
                    <p class="bg-card-date rounded-lg p-3 text-sm">{{ formatDateRange(time.start, time.end) }}</p>
                    <div class="flex space-x-4">
                        <ModalDelete :workingTimeId="time.id" @workingTimeDeleted="removeWorkingTime" />
                        <ModalUpdate :workingTimeId="time.id" :initialStart="time.start" :initialEnd="time.end"
                            @workingTimeUpdated="updateWorkingTime" />
                    </div>
                </div>
            </div>
        </div>
        <ModalCreate @workingTimeCreated="addWorkingTime" />
    </div>
</template>

<script setup>
import { defineProps } from 'vue'
import ModalCreate from '../Modal/ModalCreate.vue'
import ModalDelete from '../Modal/ModalDelete.vue'
import ModalUpdate from '../Modal/ModalUpdate.vue'
import { useWorkingTimesStore } from '../../store/useWorkingTimesStore'

const props = defineProps({
    workingTimes: {
        type: Array,
        required: true
    }
})

const workingTimesStore = useWorkingTimesStore()

const addWorkingTime = (newWorkingTime) => {
    workingTimesStore.addWorkingTime(newWorkingTime)
}

const removeWorkingTime = (id) => {
    workingTimesStore.removeWorkingTime(id)
}

const updateWorkingTime = (updatedWorkingTime) => {
    workingTimesStore.updateWorkingTime(updatedWorkingTime)
}

const formatTime = (timeString) => {
    const date = new Date(timeString)
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
}

const calculateDuration = (start, end) => {
    const startDate = new Date(start)
    const endDate = new Date(end)

    const diffMs = endDate - startDate

    const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24))
    const diffHrs = Math.floor((diffMs % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60))
    const diffMins = Math.floor((diffMs % (1000 * 60 * 60)) / (1000 * 60))

    if (diffDays > 0) {
        return `${diffDays}d ${diffHrs}h ${diffMins}min`
    } else {
        return `${diffHrs}h ${diffMins}min`
    }
}

const formatDateRange = (start, end) => {
    const startDate = new Date(start)
    const endDate = new Date(end)

    const formattedEnd = endDate.toISOString().split('T')[0]
    return formattedEnd
}
</script>