<template>
  <div class="flex h-screen">
    <Menu />
    <div class="flex-1 p-6">
      <router-view></router-view>
    </div>
  </div>
</template>

<script setup>
import Menu from './components/Menu.vue'; // Import your Menu component
</script>

<style scoped></style>
