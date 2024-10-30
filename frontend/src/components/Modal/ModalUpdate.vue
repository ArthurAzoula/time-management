<template>
    <div>
        <button @click="showModal" class="text-text-color-100 p-2 rounded-full bg-button-300 border border-button-200">
            <PenLine stroke="#fa9115" size="20" />
        </button>
        <Modal
            :isVisible="isModalVisible"
            title="Update Working Time"
            confirmText="Update"
            cancelText="Cancel"
            @close="closeModal"
            @confirm="handleConfirm"
        >
            <template #default>
                <form @submit.prevent="handleConfirm">
                    <div class="flex justify-between mb-4">
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
                                        class="border border-button-200 rounded p-1 text-center w-11/12 text-black"
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
                                        class="border border-button-200 rounded p-1 text-center w-11/12 text-black"
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
                    <button @click="handleConfirm" class="bg-blue-500 text-white px-4 py-2 rounded">Update</button>
                </footer>
            </template>
        </Modal>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue'
import { format } from 'date-fns'
import Modal from './Modal.vue'
import { workingTimeService } from '../../service/workingTimeService'
import { toast } from 'vue3-toastify'
import { PenLine } from 'lucide-vue-next'
import 'vue3-toastify/dist/index.css'

const props = defineProps({
    workingTimeId: {
        type: Number,
        required: true,
    },
    initialStart: {
        type: String,
        required: true,
    },
    initialEnd: {
        type: String,
        required: true,
    },
})

const emit = defineEmits(['workingTimeUpdated'])

const isModalVisible = ref(false)
const workingTime = ref({
    start: new Date(props.initialStart),
    end: new Date(props.initialEnd),
})

const selectedColor = ref('orange')

watch(
    () => props.workingTimeId,
    () => {
        workingTime.value.start = new Date(props.initialStart)
        workingTime.value.end = new Date(props.initialEnd)
    },
)

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
        const response = await workingTimeService.updateWorkingTime(props.workingTimeId, data)
        emit('workingTimeUpdated', response.data)
        closeModal()
    } catch (error) {
        console.error('Error updating working time:', error)
        toast.error('Failed to update working time')
    }
}
</script>
