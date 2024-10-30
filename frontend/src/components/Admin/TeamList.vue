<template>
    <v-container fluid>
      <v-container class="flex justify-end gap-4" style="margin-right: 0 !important">
        <v-btn
          :disabled="loading"
          append-icon="mdi-refresh"
          text="Refresh"
          variant="outlined"
          @click="onClick"
        ></v-btn>
        <v-btn color="primary" dark @click="openDialog"> Add Team </v-btn>
      </v-container>
      <v-data-table :items="teams" :headers="headers" class="elevation-1">
        <template v-slot:item.actions="{ item }">
          <v-icon small class="mr-2" @click="editTeam(item)">mdi-pencil</v-icon>
          <v-icon small @click="deleteTeam(item)">mdi-delete</v-icon>
        </template>
      </v-data-table>
      <div v-if="error" class="error-message">{{ error.message }}</div>
  
      <v-dialog v-model="dialog" max-width="500px">
        <v-card>
          <v-card-title>
            <span class="text-h5">{{ formTitle }}</span>
          </v-card-title>
          <v-card-text>
            <v-container>
              <v-row>
                <v-col cols="12">
                  <v-text-field v-model="editedItem.name" label="Team Name"></v-text-field>
                </v-col>
                <v-col cols="12">
                  <v-select
                    v-model="editedItem.manager_id"
                    :items="managers.map((manager) => manager.id)"
                    item-text="email"
                    item-value="id"
                    label="Manager"
                  ></v-select>
                </v-col>
              </v-row>
            </v-container>
          </v-card-text>
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="blue-darken-1" text @click="closeDialog">Cancel</v-btn>
            <v-btn color="blue-darken-1" text @click="saveTeam">Save</v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>
    </v-container>
  </template>
  
  <script setup>
  import { ref, watch, computed } from 'vue'
  import { useQuery } from '@tanstack/vue-query'
  import { teamService } from '../../service/teamService'
  import { userService } from '../../service/userService'
  
  const { data: teamData, isLoading, error } = useQuery({
    queryKey: ['teams'],
    queryFn: teamService.getTeams,
  })
  
  const { data: userData } = useQuery({
    queryKey: ['users'],
    queryFn: userService.getUsers,
  })
  
  const headers = ref([
    { title: 'ID', value: 'id', sortable: true },
    { title: 'Name', value: 'name', sortable: true },
    { title: 'Manager', value: 'manager.email', sortable: true },
    { title: 'Actions', value: 'actions', sortable: false },
  ])
  
  const teams = computed(() => teamData.value?.data || [])
  const managers = computed(() => userData.value?.data || [])
  
  watch(teamData, (newData) => {
    if (newData) {
      teams.value = newData.data.map((team) => ({
        id: team.id,
        name: team.name,
        manager: team.manager.email,
        manager_id: team.manager.id,
      }))
    } else {
      teams.value = []
    }
  })
  
  watch(userData, (newData) => {
    if (newData) {
      managers.value = newData.data
    }
  })
  
  const dialog = ref(false)
  const editedIndex = ref(-1)
  const editedItem = ref({
    id: '',
    name: '',
    manager_id: '',
  })
  
  const defaultItem = {
    id: '',
    name: '',
    manager_id: '',
  }
  
  const formTitle = computed(() => (editedIndex.value === -1 ? 'New Team' : 'Edit Team'))
  
  const openDialog = () => {
    editedIndex.value = -1
    editedItem.value = { ...defaultItem }
    dialog.value = true
  }
  
  const editTeam = (team) => {
    editedIndex.value = teams.value.indexOf(team)
    editedItem.value = { ...team }
    dialog.value = true
  }
  
  const deleteTeam = (team) => {
    if (confirm('Are you sure you want to delete this team: ' + team.name + '?')) {
      teamService.deleteTeam(team.id).then(() => {
        teams.value = teams.value.filter((t) => t.id !== team.id)
      })
    }
  }
  
  const closeDialog = () => {
    dialog.value = false
    setTimeout(() => {
      editedItem.value = { ...defaultItem }
      editedIndex.value = -1
    }, 300)
  }
  
  const saveTeam = () => {
    if (editedIndex.value > -1) {
      teamService.updateTeam(editedItem.value).then(() => {
        Object.assign(teams.value[editedIndex.value], editedItem.value)
        closeDialog()
      })
    } else {
      const body = {
        name: editedItem.value.name,
        manager_id: editedItem.value.manager_id,
      }
      teamService.createTeam(body).then((response) => {
        teams.value.push(response.data)
        closeDialog()
      })
    }
  }
  
  const onClick = () => {
    window.location.reload()
  }
  </script>
  
  <style scoped>
  .error-message {
    color: red;
    text-align: center;
    margin-top: 20px;
  }
  </style>