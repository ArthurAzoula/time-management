<script>
import Menu from './components/Menu.vue'; 

export default {
  name: 'App',
  components: {
    Menu,
  },
};
</script>
<template>
  <div class="flex h-screen">
    <Menu /> 
    <div class="flex-1 p-6"> 
      <router-view></router-view> 
    </div>
  </div>
</template>

<style scoped>
</style>
