<template>
    <div class="flex justify-end">
        <button
            @click="showModal"
            class="bg-button-200 text-white p-2 rounded-full hover:scale-105 transform ease-in-out duration-200 flex items-center"
        >
            <PlusIcon class="mr-2" />
            Create a User
        </button>
        <Modal
            :isVisible="isModalVisible"
            title="Create User"
            confirmText="Create"
            cancelText="Cancel"
            @close="closeModal"
            @confirm="handleConfirm"
        >
            <template #default>
                <form @submit.prevent="handleConfirm">
                    <div class="mb-4">
                        <label for="username" class="block text-gray-700">Username</label>
                        <input
                            type="text"
                            id="username"
                            v-model="user.username"
                            class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
                            required
                        />
                    </div>
                    <div class="mb-4">
                        <label for="email" class="block text-gray-700">Email</label>
                        <input
                            type="email"
                            id="email"
                            v-model="user.email"
                            class="mt-1 block w-full border-gray-300 rounded-md shadow-sm focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50"
                            required
                        />
                    </div>
                </form>
            </template>
            <template #footer>
                <footer class="flex justify-end p-4">
                    <button @click="closeModal" class="bg-gray-500 text-white px-4 py-2 rounded mr-2">Cancel</button>
                    <button @click="handleConfirm" class="bg-green-500 text-white px-4 py-2 rounded">Confirm</button>
                </footer>
            </template>
        </Modal>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import Modal from './Modal.vue'
import { userService } from '../../service/userService'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import { PlusIcon } from 'lucide-vue-next'

const emit = defineEmits(['userCreated'])

const isModalVisible = ref(false)
const user = ref({
    username: '',
    email: '',
})

const showModal = () => {
    isModalVisible.value = true
}

const closeModal = () => {
    isModalVisible.value = false
}

const handleConfirm = async () => {
    if (!user.value.username || !user.value.email) {
        toast.error('All fields are required')
        return
    }

    const dataUser = {
        user: {
            username: user.value.username,
            email: user.value.email,
        },
    }

    try {
        const response = await userService.createUser(dataUser)
        emit('userCreated', response.data) // Emit the userCreated event with the newly created user data
        toast.success('User created successfully!')
        closeModal()
    } catch (error) {
        console.error('Error creating user:', error)
        toast.error('Failed to create user')
    }
}
</script>
