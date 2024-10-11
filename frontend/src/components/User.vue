<template>
    <div class="user-profile p-4 ">
      <h1 class="text-2xl font-bold mb-4">My Profil</h1>
      <div class="profile-info" v-if="user">
        <p><strong>Nom :</strong> {{console.log(user.data.username) }}</p>
        <p><strong>Email :</strong> {{ console.log(user.data.email) }}</p>
      </div>
    </div>
</template>
  
<script>
import { ref, onMounted } from 'vue';
import { userService } from '../service/userService';
export default {
  setup() {
    const user = ref([]);
    const userId = 1; 

    onMounted(async () => {
      try {
        const response = await userService.getUser(userId); 
        user.value = response; 
        console.log("Utilisateur récupéré:", user.value);
      } catch (error) {
        console.error("Erreur lors de la récupération de l'utilisateur :", error);
      }
    });

    return {
      user,
    };
  },
};
</script>
  
<style scoped>
</style>
  