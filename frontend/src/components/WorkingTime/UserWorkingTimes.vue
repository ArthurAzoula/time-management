<template>
    <div class="p-6 py-12">
        <div v-if="filterByDate">
            <div>
                <h2 class="text-2xl font-bold">Working times of {{ username }}</h2>
                <div class="flex gap-2 items-center mt-6 mb-6">
                    <VDatePicker
                        v-model="range"
                        is-range
                        :select-attribute="selectDragAttribute"
                        :drag-attribute="selectDragAttribute"
                    >
                        <template #default="{ inputValue, inputEvents }">
                            <div class="flex items-center">
                                <input
                                    class="border border-button-200 rounded p-1 text-center"
                                    :value="inputValue.start"
                                    v-on="inputEvents.start"
                                    placeholder="Start date"
                                />
                                <MoveRight class="mx-2" />
                                <input
                                    class="border border-button-200 rounded p-1 text-center"
                                    :value="inputValue.end"
                                    v-on="inputEvents.end"
                                    placeholder="End date"
                                />
                            </div>
                        </template>
                    </VDatePicker>
                    <div
                        @click="searchByDate"
                        class="flex items-center gap-2 text-text-color-100 py-1 px-3 bg-button-300 border border-button-200 rounded ml-8 cursor-pointer"
                    >
                        <SearchIcon size="20" />
                        <p>Search</p>
                    </div>
                </div>
                <ModalCreate v-if="userRole !== 'employee'" @workingTimeCreated="addWorkingTime" />
            </div>
        </div>
        <div v-if="workingTimes.length === 0" class="text-center text-xl text-text-color-100 mt-6">
            No working times available at this date
        </div>
        <div v-else class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4 w-full mt-6">
            <div
                v-for="time in workingTimes"
                :key="time.id"
                class="bg-white border border-text-color-100 rounded-lg p-4 flex flex-col justify-between"
            >
                <div class="flex justify-between bg-workingHeader-100 text-text-color-100 rounded-xl">
                    <h2 class="m-3">Total duration</h2>
                    <h2 class="m-3">{{ calculateDuration(time.start, time.end) }}</h2>
                </div>
                <div class="flex justify-between w-11/12 my-2 mx-auto text-text-color-100 font-bold">
                    <p>{{ formatTime(time.start) }}</p>
                    <p>{{ formatTime(time.end) }}</p>
                </div>
                <div class="flex flex-col gap-2 my-2">
                    <p class="font-bold">Activity performed</p>
                    <p class="text-sm text-wrap text-ellipsis">
                        During this time, I did accounting, answered emails...
                    </p>
                </div>
                <div class="mt-4 text-text-color-purple font-semibold flex justify-between">
                    <div class="bg-card-date rounded px-6 flex justify-center items-center">
                        <p class="text-sm">{{ formatDateRange(time.start, time.end) }}</p>
                    </div>
                    <div class="flex space-x-3" v-if="userRole !== 'employee'">
                        <ModalDelete :workingTimeId="time.id" @workingTimeDeleted="removeWorkingTime" />
                        <ModalUpdate
                            :workingTimeId="time.id"
                            :initialStart="time.start"
                            :initialEnd="time.end"
                            @workingTimeUpdated="updateWorkingTime"
                        />
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import ModalCreate from '../Modal/ModalCreate.vue'
import ModalDelete from '../Modal/ModalDelete.vue'
import ModalUpdate from '../Modal/ModalUpdate.vue'
import { workingTimeService } from '../../service/workingTimeService'
import { MoveRight } from 'lucide-vue-next'
import { SearchIcon } from 'lucide-vue-next'
import { useUserStore } from '../../store/useUserStore'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'

const userStore = useUserStore()

const range = ref({ start: '', end: '' })

const route = useRoute()
const username = ref(route.params.username)
const id = ref(route.params.id)

const filterByDate = route.path !== '/'

const workingTimes = ref([])

const selectDragAttribute = computed(() => ({
    highlight: 'orange',
}))

onMounted(async () => {
    userStore.initializeFromLocalStorage()
    await fetchWorkingTimes()
})

const userRole = computed(() => userStore.role)

const fetchWorkingTimes = async () => {
    try {
        const response = await workingTimeService.getWorkingTimeByUserId(id.value)
        if (response && response.data) {
            workingTimes.value = response.data
        } else {
            toast.error('No data received from the server')
        }
    } catch (error) {
        toast.error('Failed to fetch working times:', error)
    }
}

const searchByDate = async () => {
    const { start, end } = range.value

    if (!start || !end) {
        toast.error('Please enter a valid date range')
        return
    }

    try {
        const response = await workingTimeService.getWorkingTimeByUserId(id.value, { start_date: start, end_date: end })
        if (response && response.data) {
            workingTimes.value = response.data
        } else {
            toast.error('No data received from the server')
        }
    } catch (error) {
        toast.error('Failed to fetch working times:', error)
    }
}

const addWorkingTime = (newWorkingTime) => {
    workingTimes.value.push(newWorkingTime)
}

const removeWorkingTime = (id) => {
    workingTimes.value = workingTimes.value.filter((time) => time.id !== id)
}

const updateWorkingTime = (updatedWorkingTime) => {
    const index = workingTimes.value.findIndex((time) => time.id === updatedWorkingTime.id)
    if (index !== -1) {
        workingTimes.value[index] = updatedWorkingTime
    }
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

    const day = String(endDate.getDate()).padStart(2, '0')
    const month = String(endDate.getMonth() + 1).padStart(2, '0')
    const year = endDate.getFullYear()

    const formattedEnd = `${month} / ${day} / ${year}`
    return formattedEnd
}
</script>
