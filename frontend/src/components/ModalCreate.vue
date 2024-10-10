<template>
    <div>
      <button @click="showModal" class="bg-green-500 text-white px-4 py-2 rounded hover:bg-green-600">Create</button>
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
              <input type="datetime-local" id="start" v-model="workingTime.start" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50" required>
            </div>
            <div class="mb-4">
              <label for="end" class="block text-gray-700">End</label>
              <input type="datetime-local" id="end" v-model="workingTime.end" class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50" required>
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
  import { workingTimeService } from '../service/workingTimeService';

  const emit = defineEmits(['workingTimeCreated'])

  const isModalVisible = ref(false)
  const workingTime = ref({
    start: '',
    end: ''
  })
  
  const showModal = () => {
    isModalVisible.value = true
  }
  
  const closeModal = () => {
    isModalVisible.value = false
  }
  
  const handleConfirm = async () => {
    const formattedStart = format(new Date(workingTime.value.start), 'yyyy-MM-dd HH:mm:ss')
    const formattedEnd = format(new Date(workingTime.value.end), 'yyyy-MM-dd HH:mm:ss')
    const data = {
        workingtime:{
      start: formattedStart,
      end: formattedEnd
    }
    }
    try {
      const userId = 1
      const response = await workingTimeService.createWorkingTime(userId, data)
      emit('workingTimeCreated', response.data)
    } catch (error) {
      console.error('Error creating working time:', error)
    }
    closeModal()
  }
  </script>