<template>
    <div class="flex justify-center items-center">
        <div class="p-6 max-w-sm mx-auto bg-white rounded-xl flex items-center border space-x-4 transform transition duration-500 hover:scale-105">
            <div class="flex items-center">
                <CheckCheckIcon class="h-11 w-11 text-button-200" />
            </div>
            <div>
                <div class="text-xl font-medium text-black">Most Productive Day</div>
                <p class="text-gray-500" v-if="mostProductiveDay">{{ formattedMostProductiveDay }}: {{ mostProductiveDay.total }} hours</p>
                <p class="text-gray-500" v-else>No data available</p>
            </div>
        </div>
    </div>
</template>

<script setup>
import { defineProps, ref, watch, computed } from 'vue';
import { isSameDay, format } from 'date-fns';
import { getDifferenceInhours } from '../../utils/DateUtils';
import { CheckCheckIcon } from 'lucide-vue-next';

const props = defineProps({
    workingTimes: {
        type: Array,
        required: true,
    },
})

const workingTimes = ref(props.workingTimes);
const totalHoursPerDay = ref([]);
const mostProductiveDay = ref(null);

console.log(workingTimes.value);

const calculeTotalHoursPerDay = () => {
    const hoursMap = new Map();

    workingTimes.value.forEach((wt) => {
        const startDate = new Date(wt.start).toDateString();
        const endDate = new Date(wt.end).toDateString();

        console.log(startDate, endDate);

        if (!hoursMap.has(startDate)) {
            hoursMap.set(startDate, 0);
        }

        if (isSameDay(wt.start, wt.end)) {
            hoursMap.set(startDate, hoursMap.get(startDate) + getDifferenceInhours(wt.start, wt.end));
        }
    });

    totalHoursPerDay.value = Array.from(hoursMap, ([date, total]) => ({ date, total }));
}

const calculeMostProductiveDay = () => {
    if (totalHoursPerDay.value.length === 0) {
        mostProductiveDay.value = null;
        return;
    }

    let max = totalHoursPerDay.value[0];
    totalHoursPerDay.value.forEach((day) => {
        if (day.total > max.total) {
            max = day;
        }
    });
    mostProductiveDay.value = max;
}

const formattedMostProductiveDay = computed(() => {
    if (!mostProductiveDay.value) return '';
    return format(new Date(mostProductiveDay.value.date), 'EEEE dd MMM');
});

watch(workingTimes, () => {
    calculeTotalHoursPerDay();
    calculeMostProductiveDay();
}, { immediate: true });

calculeTotalHoursPerDay();
calculeMostProductiveDay();
</script>