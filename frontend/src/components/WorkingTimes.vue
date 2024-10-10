<template>
    <div>
      <h2>Working Times</h2>
      <ul>
        <li v-for="time in workingTimes" :key="time.id">
          Start: {{ time.start }}, End: {{ time.end }}
        </li>
      </ul>
      <ModalCreate @workingTimeCreated="addWorkingTime" />
    </div>
  </template>
  
  <script setup>
  import { defineProps } from 'vue'
  import ModalCreate from './ModalCreate.vue'
  import { useWorkingTimesStore } from '../store/useWorkingTimesStore'
  
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
  </script>