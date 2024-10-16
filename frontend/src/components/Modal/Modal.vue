<template>
    <div
        v-if="isVisible"
        class="fixed inset-0 flex items-center justify-center bg-gray-800 bg-opacity-75 z-20"
        @click.self="closeModal"
    >
        <div class="bg-white rounded-lg shadow-lg w-11/12 md:w-1/2 lg:w-1/3">
            <header class="flex justify-between items-center p-4">
                <h2 class="text-xl font-semibold text-black">{{ title }}</h2>
                <button @click="closeModal" class="text-gray-500 hover:text-gray-700 text-3xl">&times;</button>            </header>
            <main class="p-4 mt-4">
                <slot></slot>
            </main>
            <footer class="flex justify-end p-4">
                <slot name="footer"></slot>
            </footer>
        </div>
    </div>
</template>

<script setup>
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
    isVisible: {
        type: Boolean,
        required: true,
    },
    title: {
        type: String,
        default: 'Modal Title',
    },
    confirmText: {
        type: String,
        default: 'Confirm',
    },
    cancelText: {
        type: String,
        default: 'Cancel',
    },
})

const emits = defineEmits(['close', 'confirm'])

const closeModal = () => {
    emits('close')
}

const confirmAction = () => {
    emits('confirm')
}
</script>

<style scoped>
/* Ajoutez votre style ici si nécessaire */
</style>
