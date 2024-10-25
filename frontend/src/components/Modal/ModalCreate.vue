<template>
    <div class="flex justify-end">
        <button
            @click="showModal"
            class="bg-button-200 text-white p-2 rounded-full hover:scale-105 transform ease-in-out duration-200"
        >
            <PlusIcon />
        </button>
        <Modal
            :isVisible="isModalVisible"
            title="Create Working Time"
            confirmText="Create"
            cancelText="Cancel"
            @close="closeModal"
            @confirm="handleConfirm"
        >
            <template #default>
                <form @submit.prevent="handleConfirm">
                    <div class="flex justify-between mb-4 font-semibold">
                        <div class="w-1/2">
                            <label for="start" class="block text-gray-700">Start</label>
                            <VDatePicker
                                v-model="workingTime.start"
                                :format="'YYYY-MM-DD HH:mm:ss'"
                                mode="datetime"
                                :color="selectedColor"
                            >
                                <template #default="{ inputValue, inputEvents }">
                                    <input
                                        :value="inputValue"
                                        v-on="inputEvents"
                                        class="border border-button-200 rounded p-1 text-center w-11/12"
                                    />
                                </template>
                            </VDatePicker>
                        </div>
                        <div class="w-1/2 text-right">
                            <label for="end" class="block text-gray-700">End</label>
                            <VDatePicker
                                v-model="workingTime.end"
                                :format="'YYYY-MM-DD HH:mm:ss'"
                                mode="datetime"
                                :color="selectedColor"
                            >
                                <template #default="{ inputValue, inputEvents }">
                                    <input
                                        :value="inputValue"
                                        v-on="inputEvents"
                                        class="border border-button-200 rounded p-1 text-center w-11/12"
                                    />
                                </template>
                            </VDatePicker>
                        </div>
                    </div>
                </form>
            </template>
            <template #footer>
                <footer class="flex justify-end p-4">
                    <button @click="closeModal" class="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancel</button>
                    <button @click="handleConfirm" class="bg-green-500 text-white px-4 py-2 rounded">Confirm</button>
                </footer>
            </template>
        </Modal>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { format } from 'date-fns'
import Modal from './Modal.vue'
import { workingTimeService } from '../../service/workingTimeService'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import { PlusIcon } from 'lucide-vue-next'
import { useUserStore } from '../../store/useUserStore'
import { useRoute } from 'vue-router'

const userStore = useUserStore()
const route = useRoute()
const username = ref(route.params.username)
const id = ref(route.params.id)

const emit = defineEmits(['workingTimeCreated'])
const isModalVisible = ref(false)

const workingTime = ref({
    start: new Date(),
    end: new Date(),
})

const selectedColor = ref('orange')

onMounted(async () => {
    userStore.initializeFromLocalStorage()
})

const showModal = () => {
    isModalVisible.value = true
}

const closeModal = () => {
    isModalVisible.value = false
}

const handleConfirm = async () => {
    if (!workingTime.value.start || !workingTime.value.end) {
        toast.error('All fields are required')
        return
    }

    const startDate = new Date(workingTime.value.start)
    const endDate = new Date(workingTime.value.end)

    if (startDate >= endDate) {
        toast.error('Start date must be earlier than end date')
        return
    }

    const formattedStart = format(startDate, 'yyyy-MM-dd HH:mm:ss')
    const formattedEnd = format(endDate, 'yyyy-MM-dd HH:mm:ss')
    const data = {
        workingtime: {
            start: formattedStart,
            end: formattedEnd,
        },
    }

    try {
        const userId = id.value || userStore.id
        const response = await workingTimeService.createWorkingTime(userId, data)
        toast.success('Working time created successfully!')
        emit('workingTimeCreated', response.data)
        closeModal()
    } catch (error) {
        console.error('Error creating working time:', error)
        toast.error('Failed to create working time')
    }
}
</script>