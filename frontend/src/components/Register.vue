<template>
    <div class="flex items-center justify-center min-h-screen bg-gray-100">
        <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">
            <h1 class="text-2xl font-bold text-center">Create your account</h1>
            <form @submit.prevent="register" class="space-y-6">
                <div class="space-y-1">
                    <label for="email" class="block text-sm font-medium text-gray-700">Email</label>
                    <input v-model="email" type="email" id="email" placeholder="Enter your email" required
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:border-button-200" />
                </div>
                <div class="space-y-1">
                    <label for="username" class="block text-sm font-medium text-gray-700">Username</label>
                    <input v-model="username" type="text" id="username" placeholder="Enter your username" required
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:border-button-200" />
                </div>
                <div class="space-y-1">
                    <label for="password" class="block text-sm font-medium text-gray-700">Password</label>
                    <input v-model="password" type="password" id="password" placeholder="Enter your password" required
                        class="w-full px-3 py-2 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:border-button-200" />
                </div>
                <button type="submit"
                    class="w-full px-4 py-2 text-white bg-button-200 rounded-md focus:outline-none focus:ring-2 focus:ring-offset-2">
                    Create Account  
                </button>
            </form>
            <div class="flex justify-end items-center">
                <router-link to="/login" class="text-sm text-button-200 hover:underline">Already have an account?</router-link>

            </div>
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
        const username =ref('')
        const password = ref('')
        const router = useRouter()
        const userStore = useUserStore()


        const register = async () => {
            try {
                const user = await userService.register({ email: email.value, username:username.value ,password: password.value })
                localStorage.setItem('registrationSuccess', 'true')
                router.push('/login')
            } catch (error) {
                console.error('Registration error:', error);
                toast.error('register failed')
            }
        }

        return {
            email,
            username,
            password,
            register
        }
    }
}
</script>