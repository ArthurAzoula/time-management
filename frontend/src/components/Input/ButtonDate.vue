<template>
    <input type="text" :class="computedClass" :placeholder="props.customPlaceholder" />
</template>

<script setup>
import { computed } from 'vue'

const props = defineProps({
    customClass: {
        type: String,
        default: '',
    },
    customPlaceholder: {
        type: String,
        default: '',
    },
})

const computedClass = computed(() => {
    return `w-11 h-8 border border-button-200 rounded-lg text-center ${props.customClass}`
})
</script>
