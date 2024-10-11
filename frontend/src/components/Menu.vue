<template>
  <div class="menu-layout m-6 rounded-lg bg-button-300 w-1/4 h-screen">
    <div class="flex items-center space-x-4 mb-8">
      <img class="rounded-full mb-6 mt-10 w-24 h-24 ml-6" src="https://via.placeholder.com/50" alt="Profile Picture" />
      <router-link to="/myProfil" @click="setActive('myProfil')" :class="{ active: activeLink === 'myProfil' }" class="text-xl font-semibold">
        My Profil
      </router-link>
    </div>
    <nav class="w-full">
      <ul class="flex flex-col space-y-6 items-center">
        <li class="text-left relative">
          <router-link 
            to="/dashboard" 
            @click="setActive('dashboard')" 
            :class="{ active: activeLink === 'dashboard' }"
            class="relative z-10"
          >
            Dashboard
          </router-link>
          <!-- Barre de sélection pour Dashboard -->
          <div 
            v-if="activeLink === 'dashboard'" 
            class="bg-orange-400 h-12 w-48 rounded-md absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-4 z-0"
          ></div>
        </li>
        <li class="text-left relative">
          <router-link 
            to="/workingtime" 
            @click="setActive('clocks')" 
            :class="{ active: activeLink === 'clocks' }"
            class="relative z-10"
          >
            Temps de travail
          </router-link>
          <!-- Barre de sélection pour Temps de travail -->
          <div 
            v-if="activeLink === 'clocks'" 
            class="bg-orange-400 h-12 w-48 rounded-md absolute top-0 left-1/2 transform -translate-x-1/2 -translate-y-4 z-0"
          ></div>
        </li>
      </ul>
    </nav>
  </div>
</template>

<script>
export default {
  name: 'Menu',
  data() {
    return {
      activeLink: '',
    };
  },
  methods: {
    setActive(link) {
      this.activeLink = link;
    },
  },
};
</script>
