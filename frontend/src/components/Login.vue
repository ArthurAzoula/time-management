<template>
    <div class="flex items-center justify-center min-h-screen bg-gray-100">
        <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">
            <h1 class="text-2xl font-bold text-center">Login</h1>
            <form @submit.prevent="login" class="space-y-6">
                <div class="space-y-1">
                    <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
                    <input v-model="email" type="email" id="email" placeholder="Enter your email" required
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500" />
                </div>
                <div class="space-y-1">
                    <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
                    <input v-model="password" type="password" id="password" placeholder="Enter your password" required
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-indigo-500 focus:border-indigo-500" />
                </div>
                <button type="submit"
                    class="w-full px-4 py-2 text-white bg-indigo-600 rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500">
                    Login
                </button>
            </form>
        </div>
    </div>
</template>

<script>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import { userService } from '../service/userService'
import { useUserStore } from '../store/useUserStore'


export default {
    setup() {
        const email = ref('')
        const password = ref('')
        const router = useRouter()
        const userStore = useUserStore()


        const login = async () => {
            try {
                const token = await userService.login({ email: email.value, password: password.value })
                localStorage.setItem('token', token)
                userStore.setToken(token)
                router.push('/')
            } catch (error) {
                toast.error('Login failed')
            }
        }

        return {
            email,
            password,
            login
        }
    }
}
</script>