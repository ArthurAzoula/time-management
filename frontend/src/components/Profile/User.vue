<template>
    <div
        class="p-6 my-24 flex flex-col max-w-2xl mx-auto bg-button-200 bg-opacity-5 shadow-md rounded-lg justify-center"
    >
        <div class="flex justify-between mb-2 items-start">
            <h1 class="text-3xl font-bold mb-6 text-button-200">{{ user.username }}'s profile</h1>
            <button
                class="bg-neutral-200 text-neutral-600 py-2 px-4 rounded shadow transition"
                v-if="!isEditing"
                @click="userStore.logout"
            >
                Déconnexion
            </button>
        </div>
        <div class="profile-info" v-if="user">
            <div class="space-y-4">
                <div class="flex items-center justify-between">
                    <div>
                        <label for="username" class="block text-sm font-medium text-gray-700">Username</label>
                        <input
                            id="username"
                            type="text"
                            v-model="user.username"
                            :disabled="!isEditing"
                            class="mt-1 block w-full border border-gray-300 rounded-md p-3 shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                        />
                    </div>
                    <button @click="toggleEdit" class="ml-4 text-button-200 transition">
                        <svg
                            v-if="!isEditing"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke-width="2"
                            stroke="currentColor"
                            class="w-6 h-6"
                        >
                            <path
                                stroke-linecap="round"
                                stroke-linejoin="round"
                                d="M16 4l4 4-4 4-4-4 4-4zm0 0L4 16v4h4l12-12z"
                            />
                        </svg>
                        <svg
                            v-if="isEditing"
                            xmlns="http://www.w3.org/2000/svg"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke-width="2"
                            stroke="currentColor"
                            class="w-6 h-6"
                        >
                            <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12" />
                        </svg>
                    </button>
                </div>

                <div>
                    <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
                    <input
                        id="email"
                        type="email"
                        v-model="user.email"
                        :disabled="!isEditing"
                        class="mt-1 block w-full border border-gray-300 rounded-md p-3 shadow-sm focus:outline-none focus:ring-blue-500 focus:border-blue-500"
                    />
                </div>
            </div>

            <div class="mt-6 flex justify-end gap-4">
                <div class="space-x-4">
                    <button
                        @click="updateUser"
                        v-if="isEditing"
                        class="bg-button-200 text-white py-2 px-6 rounded shadow transition"
                    >
                        Update
                    </button>
                    <button
                        v-if="!isEditing && role !== 'admin'"
                        @click="deleteUser"
                        class="bg-red-500 text-white py-2 px-6 rounded shadow hover:bg-red-700 transition"
                    >
                        Delete my account
                    </button>
                </div>
                <ModalCreateUser
                    v-if="isModalVisible && !isEditing && role === 'admin'"
                    @close="closeModal"
                    @userCreated="onUserCreated"
                />
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { userService } from '../../service/userService'
import { useUserStore } from '../../store/useUserStore'
import { toast } from 'vue3-toastify'
import ModalCreateUser from '../Modal/ModalCreateUser.vue'

const userStore = useUserStore()
userStore.initializeFromLocalStorage()
const user = ref({})
const role = ref(userStore.role ?? '')
const userId = ref(userStore.id)
const isEditing = ref(false)
const isModalVisible = ref(true)

onMounted(async () => {
    try {
        const response = await userService.getUser(userId.value)
        user.value = response.data
    } catch (error) {
        toast.error("Erreur lors de la récupération de l'utilisateur :", error)
    }
})

const toggleEdit = () => {
    isEditing.value = !isEditing.value
}

const closeModal = () => {
    isModalVisible.value = false
}

const onUserCreated = (newUser) => {
    toast.success('User created successfully!')
    closeModal()
}

const updateUser = async () => {
    const dataUser = {
        user: {
            username: user.value.username,
            email: user.value.email,
        },
    }
    try {
        await userService.updateUser(userId.value, dataUser)
        toast.success('User updated successfully!')
        isEditing.value = false
    } catch (error) {
        toast.error("Erreur lors de la mise à jour de l'utilisateur :", error)
    }
}

const deleteUser = async () => {
    try {
        await userService.deleteUser(userId.value)
        toast.success('User deleted successfully!')
    } catch (error) {
        toast.error("Erreur lors de la suppression de l'utilisateur :", error)
    }
}
</script>

<style scoped>
.bg-white {
    background-color: #fff;
}

.shadow-md {
    box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
}

.text-gray-800 {
    color: #2d3748;
}

.text-blue-600 {
    color: #3182ce;
}

.text-blue-800 {
    color: #2c5282;
}
</style>
