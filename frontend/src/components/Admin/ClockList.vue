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
      <v-btn color="primary" dark @click="openDialog('create')"> New Clock </v-btn>
    </v-container>
    <v-data-table :items="clocks" :headers="headers" class="elevation-1">
      <template v-slot:item.user="{ item }">
        <span>{{ getUserEmail(item.user) }}</span>
      </template>
      <template v-slot:item.actions="{ item }">
        <v-icon small class="mr-2" @click="openDialog('edit', item)">mdi-pencil</v-icon>
        <v-icon small @click="openDialog('delete', item)">mdi-delete</v-icon>
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
              <v-col cols="12" md="6">
                <v-text-field v-model="editedItem.status" label="Status"></v-text-field>
              </v-col>
              <v-col cols="12" md="6">
                <v-text-field v-model="editedItem.time" label="Clock in time"></v-text-field>
              </v-col>
              <v-col cols="12" md="6">
                <v-select
                  v-model="editedItem.user"
                  :items="users.map((user) => user.email)"
                  item-text="email"
                  item-value="id"
                  label="User"
                ></v-select>
              </v-col>
            </v-row>
          </v-container>
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue-darken-1" text @click="closeDialog">Cancel</v-btn>
          <v-btn color="blue-darken-1" text @click="saveClock">Save</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>

    <v-dialog v-model="deleteDialog" max-width="500px">
      <v-card>
        <v-card-title>
          <span class="text-h5">Confirm Deletion</span>
        </v-card-title>
        <v-card-text>
          Are you sure you want to delete this clock?
        </v-card-text>
        <v-card-actions>
          <v-spacer></v-spacer>
          <v-btn color="blue-darken-1" text @click="closeDeleteDialog">Cancel</v-btn>
          <v-btn color="blue-darken-1" text @click="confirmDelete">Delete</v-btn>
        </v-card-actions>
      </v-card>
    </v-dialog>
  </v-container>
</template>

<script setup>
import { ref, computed, watch } from 'vue'
import { useQuery } from '@tanstack/vue-query'
import { clockService } from '../../service/clockService'
import { userService } from '../../service/userService'

const { data, isLoading, error } = useQuery({
  queryKey: 'clocks',
  queryFn: clockService.getAllClocks,
})

const { data: userData } = useQuery({
  queryKey: 'users',
  queryFn: userService.getUsers,
})

const headers = ref([
  { title: 'ID', value: 'id', sortable: true },
  { title: 'Status', value: 'status', sortable: true },
  { title: 'Clock in time', value: 'time', sortable: true },
  { title: 'User', value: 'user', sortable: true },
  { title: 'Actions', value: 'actions', sortable: false },
])

const clocks = computed(() => data.value?.data || [])
const users = computed(() => userData.value?.data || [])

watch(data, (newData) => {
  if (newData) {
    clocks.value = newData.data.map((clock) => ({
      id: clock.id,
      status: clock.status,
      time: clock.time,
      user: clock.user,
    }))
  }
})

watch(userData, (newData) => {
  if (newData) {
    users.value = newData.data
  }
})

const getUserEmail = (userId) => {
  const user = users.value.find((u) => u.id === userId)
  return user ? user.email : ''
}

const dialog = ref(false)
const deleteDialog = ref(false)
const editedIndex = ref(-1)
const editedItem = ref({
  id: '',
  status: '',
  time: '',
  user: '',
})

const defaultItem = {
  id: '',
  status: '',
  time: '',
  user: '',
}

const formTitle = computed(() => (editedIndex.value === -1 ? 'New Clock' : 'Edit Clock'))

const openDialog = (type, item = null) => {
  if (type === 'create') {
    editedIndex.value = -1
    editedItem.value = { ...defaultItem }
    dialog.value = true
  } else if (type === 'edit') {
    editedIndex.value = clocks.value.indexOf(item)
    editedItem.value = { ...item }
    dialog.value = true
  } else if (type === 'delete') {
    editedIndex.value = clocks.value.indexOf(item)
    editedItem.value = { ...item }
    deleteDialog.value = true
  }
}

const closeDialog = () => {
  dialog.value = false
  setTimeout(() => {
    editedItem.value = { ...defaultItem }
    editedIndex.value = -1
  }, 300)
}

const closeDeleteDialog = () => {
  deleteDialog.value = false
  setTimeout(() => {
    editedItem.value = { ...defaultItem }
    editedIndex.value = -1
  }, 300)
}

const saveClock = () => {
  if (editedIndex.value > -1) {
    clockService.updateClock(editedItem.value).then(() => {
      Object.assign(clocks.value[editedIndex.value], editedItem.value)
      closeDialog()
    })
  } else {
    clockService.createClock(editedItem.value).then((response) => {
      clocks.value.push(response.data)
      closeDialog()
    })
  }
}

const confirmDelete = () => {
  clockService.deleteClock(editedItem.value.id).then(() => {
    clocks.value = clocks.value.filter((clock) => clock.id !== editedItem.value.id)
    closeDeleteDialog()
  })
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