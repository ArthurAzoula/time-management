<template>
    <div class="w-full bg-background-100 px-6 py-4">
        <div class="flex flex-col">
            <h1 class="text-xl font-bold">My last working time</h1>
            <div class="flex items-center">
                <WorkingTimes :workingTimes="latestWorkingTimes" />
            </div>
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
    props.workingTimes.sort((a, b) => new Date(b.start) - new Date(a.start))
    return props.workingTimes.slice(0, 3)
})

watch(
    () => props.workingTimes,
    (newVal) => {},
    { immediate: true },
)
</script>
