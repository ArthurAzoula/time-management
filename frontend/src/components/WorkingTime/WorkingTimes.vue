<template>
    <div>
      <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6">
        <div v-for="time in workingTimes" :key="time.id" class="bg-white shadow-md rounded-lg p-6">
          <div class="flex justify-between items-center">
            <div>
              <h3 class="text-lg font-semibold text-gray-900">Time Slot</h3>
              <p class="text-gray-600">Start: {{ time.start }}</p>
              <p class="text-gray-600">End: {{ time.end }}</p>
            </div>
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
  </script>
