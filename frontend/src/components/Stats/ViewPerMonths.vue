<template>
    <div class="p-6 py-4 rounded-md h-full bg-background-100">
        <canvas id="fullWidthGraph"></canvas>
    </div>
</template>

<script setup>
import Chart from 'chart.js/auto'
import { onMounted, ref } from 'vue'
import { getDifferenceInhours } from '../../utils/DateUtils'

const props = defineProps({
    workingTimes: {
        type: Array,
        required: true,
    },
})

const workingTimes = ref(props.workingTimes)

const workingTimesPerMonth = ref([])
const totalHoursPerMonth = ref([])
const months = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12']

months.forEach((month) => {
    workingTimesPerMonth.value.push({
        month: month,
        workingTimes: workingTimes.value.filter((wt) => new Date(wt.start).getMonth() + 1 === parseInt(month)),
    })
})

workingTimesPerMonth.value.forEach((month) => {
    let totalHours = 0
    month.workingTimes.forEach((wt) => {
        totalHours += getDifferenceInhours(wt.start, wt.end)
    })

    totalHoursPerMonth.value.push({
        month: month.month,
        totalHours: totalHours,
    })
})

onMounted(() => {
    const ctx = document.getElementById('fullWidthGraph').getContext('2d')
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: [
                'January',
                'February',
                'March',
                'April',
                'May',
                'June',
                'July',
                'August',
                'September',
                'October',
                'November',
                'December',
            ],
            datasets: [
                {
                    label: 'Working Hours',
                    data: totalHoursPerMonth.value.map((month) => month.totalHours),
                    backgroundColor: ['rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)'],
                    borderColor: '#C026D3',
                    borderWidth: 2,
                    tension: 0.47,
                    fill: true,
                    pointRadius: 2,
                },
            ],
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                title: {
                    display: true,
                    text: 'Monthly Work Time',
                },
                tooltip: {
                    callbacks: {
                        label: function (context) {
                            const value = context.raw
                            return `${context.label}: ${value} hours`
                        },
                    },
                },
            },
            scales: {
                x: {
                    beginAtZero: true,
                },
                y: {
                    beginAtZero: true,
                },
            },
        },
    })
})
</script>

<style scoped>
.p-6 {
    height: calc(100vh - 15rem);
    width: calc(100vw - 22rem);
}
</style>
