<template>
    <div class="w-full bg-background-100 px-6 py-4">
        <div class="flex flex-col space-y-8">
            <h1 class="text-xl font-bold">My working hours</h1>
            <div class="flex items-center gap-2">
                <WorkingTimes :workingTimes="latestWorkingTimes" />
            </div>
            <button
                class="bg-button-300 border border-button-200 px-2 py-1 text-text-color-100 font-bold rounded-lg w-max"
            >
                See all my hours
            </button>
        </div>
    </div>
</template>

<script setup>
import { computed, watch } from 'vue'
import WorkingTimes from './WorkingTimes.vue'

const props = defineProps({
    workingTimes: {
        type: Array,
        required: true,
    },
})

const latestWorkingTimes = computed(() => {
    return props.workingTimes.slice(-4).reverse()
})

watch(
    () => props.workingTimes,
    (newVal) => {},
    { immediate: true },
)
</script>
