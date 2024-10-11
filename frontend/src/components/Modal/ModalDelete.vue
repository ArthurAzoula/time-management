<template>
    <div>
        <button @click="showModal" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-600">Delete</button>
        <Modal
            :isVisible="isModalVisible"
            title="Delete Working Time"
            confirmText="Delete"
            cancelText="Cancel"
            @close="closeModal"
            @confirm="handleConfirm"
        >
            <template #default>
                <p>Are you sure you want to delete this working time?</p>
            </template>
            <template #footer>
                <footer class="flex justify-end p-4">
                    <button @click="closeModal" class="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancel</button>
                    <button @click="handleConfirm" class="bg-red-500 text-white px-4 py-2 rounded">Delete</button>
                </footer>
            </template>
        </Modal>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import Modal from './Modal.vue'
import { workingTimeService } from '../../service/workingTimeService'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'

const props = defineProps({
    workingTimeId: {
        type: Number,
        required: true,
    },
})

const emit = defineEmits(['workingTimeDeleted'])

const isModalVisible = ref(false)

const showModal = () => {
    isModalVisible.value = true
}

const closeModal = () => {
    isModalVisible.value = false
}

const handleConfirm = async () => {
    try {
        await workingTimeService.deleteWorkingTime(props.workingTimeId)
        emit('workingTimeDeleted', props.workingTimeId)
        closeModal()
        toast.success('Working time deleted successfully')
    } catch (error) {
        console.error('Error deleting working time:', error)
        toast.error('Failed to delete working time')
    }
}
</script>
