<template>
    <div class="flex items-center justify-center min-h-screen bg-gray-100">
        <div class="w-full max-w-md p-8 space-y-6 bg-white rounded-lg shadow-md">
            <h1 class="text-2xl font-bold text-center">Create your account</h1>
            <form @submit.prevent="login" class="space-y-6">
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
