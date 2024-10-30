<template>
    <v-container fluid class="flex flex-col">
        <v-container class="flex justify-end gap-4" style="margin-right: 0 !important">
            <v-btn
                :disabled="loading"
                append-icon="mdi-refresh"
                text="Refresh"
                variant="outlined"
                @click="onClick"
            ></v-btn>
            <v-btn color="primary" dark @click="openDialog"> New User </v-btn>
        </v-container>
        <v-data-table :items="users" :headers="headers" class="elevation-1">
            <template v-slot:item.actions="{ item }">
                <v-icon small class="mr-2" @click="editUser(item)">mdi-pencil</v-icon>
                <v-icon small @click="deleteUser(item)">mdi-delete</v-icon>
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
                                <v-text-field v-model="editedItem.username" label="Username"></v-text-field>
                            </v-col>
                            <v-col cols="12" md="6">
                                <v-text-field v-model="editedItem.email" label="Email"></v-text-field>
                            </v-col>
                          
                            <v-col cols="12" md="6">
                                <v-select
                                    v-model="editedItem.role"
                                    :items="RoleUtilsArray"
                                    item-text="role"
                                    item-value="id"
                                    label="Role"
                                ></v-select>
                            </v-col>
                        </v-row>
                    </v-container>
                </v-card-text>
                <v-card-actions>
                    <v-spacer></v-spacer>
                    <v-btn color="blue-darken-1" text @click="closeDialog">Cancel</v-btn>
                    <v-btn color="blue-darken-1" text @click="saveUser">Save</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </v-container>
</template>

<script setup>
import { ref, watch, computed } from 'vue'
import { useQuery } from '@tanstack/vue-query'
import { userService } from '../../service/userService'
import { RoleUtilsArray } from '../../utils/RoleUtils'

const { data, isLoading, error } = useQuery({
    queryKey: ['users'],
    queryFn: userService.getUsers,
})

const headers = ref([
    { title: 'ID', value: 'id', sortable: true },
    { title: 'Username', value: 'username', sortable: true },
    { title: 'Email', value: 'email', sortable: true },
    { title: 'Role', value: 'role', sortable: true },
    { title: 'Actions', value: 'actions', sortable: false },
])

const users = computed(() => data.value?.data || [])

watch(data, (newData) => {
    if (newData) {
        users.value = newData.data.map((user) => ({
            id: user.id,
            username: user.username,
            email: user.email,
            role: user.role,
        }))
    }
})

const dialog = ref(false)
const editedIndex = ref(-1)
const editedItem = ref({
    id: '',
    username: '',
    email: '',
    role: '',
})

const defaultItem = {
    id: '',
    username: '',
    email: '',
    role: '',
}

const formTitle = computed(() => (editedIndex.value === -1 ? 'New User' : 'Edit User'))

const openDialog = () => {
    editedIndex.value = -1
    editedItem.value = { ...defaultItem }
    dialog.value = true
}

const editUser = (item) => {
    editedIndex.value = users.value.indexOf(item)
    editedItem.value = { ...item }
    dialog.value = true
}

const deleteUser = (item) => {
    const index = users.value.indexOf(item)
    confirm('Are you sure you want to delete this item?') && users.value.splice(index, 1)
    userService.deleteUser(index)
}

const closeDialog = () => {
    dialog.value = false
    setTimeout(() => {
        editedItem.value = { ...defaultItem }
        editedIndex.value = -1
    }, 300)
}

const saveUser = () => {
    if (editedIndex.value > -1) {

        Object.assign(users.value[editedIndex.value], editedItem.value)
    } else {
        const body = {
            username: editedItem.value.username,
            email: editedItem.value.email,
            role: editedItem.value.role,
            password: editedItem.value.username,
            password_hash: editedItem.value.username,
        }
        userService.createUser(body).then((
            users.value.push({ ...editedItem.value })
        ))
    }
    closeDialog()
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
