<template>
    <div class="user-profile p-6 py-12">
        <h1 class="text-2xl font-bold mb-4">My Profil</h1>
        <div class="profile-info" v-if="user">
            <div class="flex items-center justify-between">
                <div>
                    <label for="username" class="block text-sm font-medium">Username:</label>
                    <input
                        id="username"
                        type="text"
                        v-model="user.username"
                        :disabled="!isEditing"
                        class="mt-1 block w-full border border-gray-300 rounded-md p-2"
                    />
                </div>
                <button @click="toggleEdit" class="ml-4 text-gray-500">
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
            <div class="mt-4">
                <label for="email" class="block text-sm font-medium">Email:</label>
                <input
                    id="email"
                    type="email"
                    v-model="user.email"
                    :disabled="!isEditing"
                    class="mt-1 block w-full border border-gray-300 rounded-md p-2"
                />
            </div>
            <div class="mt-4 flex space-x-4">
                <button @click="createUser" class="bg-blue-500 text-white py-2 px-4 rounded">Create user</button>
                <button @click="updateUser" v-if="isEditing" class="bg-blue-500 text-white py-2 px-4 rounded">
                    Update
                </button>
                <button @click="deleteUser" class="bg-red-500 text-white py-2 px-4 rounded">Delete</button>
            </div>
        </div>
    </div>
</template>

<script>
import { ref, onMounted } from 'vue'
import { userService } from '../../service/userService';
import { toast } from 'vue3-toastify'

export default {
    setup() {
        const user = ref({})
        const userId = 1
        const isEditing = ref(false)

        onMounted(async () => {
            try {
                const response = await userService.getUser(userId)
                user.value = response.data
            } catch (error) {
                toast.error("Erreur lors de la récupération de l'utilisateur :", error)
            }
        })

        const toggleEdit = () => {
            isEditing.value = !isEditing.value
        }

        const createUser = async () => {
            const dataUser = {
                user: {
                    username: user.value.username,
                    email: user.value.email,
                },
            }
            try {
                await userService.createUser(dataUser)
                toast.success('User created successfully !')
            } catch (error) {
                toast.error("Erreur lors de la mise à jour de l'utilisateur :", error)
            }
        }

        const updateUser = async () => {
            const dataUser = {
                user: {
                    username: user.value.username,
                    email: user.value.email,
                },
            }
            try {
                await userService.updateUser(userId, dataUser)
                toast.success('User updated successfully !')
                isEditing.value = false
            } catch (error) {
                toast.error("Erreur lors de la mise à jour de l'utilisateur :", error)
            }
        }

        const deleteUser = async () => {
            try {
                await userService.deleteUser(userId)
                toast.success('User deleted successfully !')
            } catch (error) {
                toast.error("Erreur lors de la suppression de l'utilisateur :", error)
            }
        }

        return {
            user,
            isEditing,
            toggleEdit,
            createUser,
            updateUser,
            deleteUser,
        }
    },
}
</script>

<style scoped></style>
