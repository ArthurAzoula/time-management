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
                    <div class="mb-4">
                        <label for="start" class="block text-gray-700">Start</label>
                        <input
                            type="datetime-local"
                            id="start"
                            v-model="workingTime.start"
                            class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
                            required
                        />
                    </div>
                    <div class="mb-4">
                        <label for="end" class="block text-gray-700">End</label>
                        <input
                            type="datetime-local"
                            id="end"
                            v-model="workingTime.end"
                            class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
                            required
                        />
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
import { ref } from 'vue'
import { format } from 'date-fns'
import Modal from './Modal.vue'
import { workingTimeService } from '../../service/workingTimeService'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import { PlusIcon } from 'lucide-vue-next'

const emit = defineEmits(['workingTimeCreated'])

const isModalVisible = ref(false)
const workingTime = ref({
    start: '',
    end: '',
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
        const userId = 1
        const response = await workingTimeService.createWorkingTime(userId, data)
        emit('workingTimeCreated', response.data)
        closeModal()
    } catch (error) {
        console.error('Error creating working time:', error)
        toast.error('Failed to create working time')
    }
}
</script>
