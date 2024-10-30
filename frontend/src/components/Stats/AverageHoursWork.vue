<template>
    <div class="flex justify-center items-center">
        <div
            class="p-6 max-w-sm mx-auto bg-background-100 rounded-md flex items-center space-x-4 transform transition duration-500 hover:scale-105"
        >
            <div class="flex items-center">
                <ChartSplineIcon class="h-11 w-11 text-primary-100" />
            </div>
            <div>
                <div class="text-xl font-medium text-black">Average Hours Worked</div>
                <p class="text-gray-500">{{ averageHours.toFixed(2) }} hours/day</p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { defineProps, ref, watch } from 'vue'
import { getDifferenceInhours } from '../../utils/DateUtils'
import { ChartSplineIcon } from 'lucide-vue-next'

const props = defineProps({
    workingTimes: {
        type: Array,
        required: true,
        default: () => [],
    },
})

const workingTimes = ref(props.workingTimes)
const averageHours = ref(0)
const totalHours = ref(0)

const calculeAverage = () => {
    totalHours.value = 0
    workingTimes.value.forEach((wt) => {
        totalHours.value += getDifferenceInhours(wt.start, wt.end)
    })

    averageHours.value = workingTimes.value.length > 0 ? totalHours.value / workingTimes.value.length : 0
}

calculeAverage()

watch(workingTimes, calculeAverage, { immediate: true })
</script>
