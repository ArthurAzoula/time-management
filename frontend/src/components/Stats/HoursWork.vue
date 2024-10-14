<template>
    <div class="flex justify-center items-center">
        <div class="p-6 max-w-sm mx-auto bg-white rounded-xl flex items-center space-x-4 transform transition duration-500 hover:scale-105 border">
            <div class="flex items-center">
                <svg class="h-12 w-12 text-button-200" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 28 28" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6 0a9 9 0 11-18 0 9 9 0 0118 0z" />
                </svg>
            </div>
            <div>
                <div class="text-xl font-medium text-black">Total Hours Worked</div>
                <p class="text-gray-500">{{ totalHours }} hours</p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { defineProps, ref, watch } from 'vue';
import { getDifferenceInhours } from '../../utils/DateUtils';

const props = defineProps({
    workingTimes: {
        type: Array,
        required: true,
    },
})

const workingTimes = ref(props.workingTimes);
const totalHours = ref(0);

const calculateTotalHours = () => {
    totalHours.value = 0;
    workingTimes.value.forEach(wt => {
        totalHours.value += getDifferenceInhours(wt.start, wt.end);
    });
};

watch(workingTimes, calculateTotalHours, { immediate: true });

calculateTotalHours();
</script>