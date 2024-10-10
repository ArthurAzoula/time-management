<script setup>
import { ref, onMounted } from 'vue'
import { userService } from './service/userService'
import Graphs from './components/Graphs.vue';

const users = ref([])

onMounted(() => {
  userService.getUsers().then((response) => {
    users.value = response.data
  })
})
</script>

<template>
  <div>
    <ul>
      <li v-for="user in users" :key="user.id">{{ user.email }}</li>
    </ul>
    <Graphs />
  </div>
</template>

<style scoped>

</style>