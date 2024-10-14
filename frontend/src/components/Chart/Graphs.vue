<script setup>
import Chart from 'chart.js/auto'
import { onMounted, ref } from 'vue'
import { workingTimeService } from '../../service/workingTimeService'

const lineChart = ref(null)
const pieChart = ref(null)
const radarChart = ref(null)
const timeWorked = ref(0)
const timeBreak = ref(0)

const props = defineProps({
    all: {
        type: Boolean,
        required: true,
    },
})

const userId = 1

const formatTime = (minutes) => {
    const hours = Math.floor(minutes / 60)
    const mins = Math.floor(minutes % 60)
    return hours > 0 ? `${hours}h ${mins}m` : `${mins}m`
}

const getDailyWorkingTimes = (workingTimes) => {
    const today = new Date()
    today.setHours(0, 0, 0, 0)

    const filteredWorkingTimes = workingTimes.filter((wt) => {
        const start = new Date(wt.start)
        start.setHours(0, 0, 0, 0)
        return start.getTime() === today.getTime()
    })

    const totalWorkingMinutes = filteredWorkingTimes.reduce((acc, wt) => {
        const start = new Date(wt.start)
        const end = new Date(wt.end)
        if (isNaN(start) || isNaN(end)) {
            console.error('Invalid date:', wt)
            return acc
        }
        const minutes = (end - start) / (1000 * 60)
        return acc + minutes
    }, 0)

    const totalMinutesInDay = 8 * 60
    const workingMinutes = Math.min(totalWorkingMinutes, totalMinutesInDay)
    const breakMinutes = totalMinutesInDay - workingMinutes

    timeWorked.value = workingMinutes
    timeBreak.value = breakMinutes

    return { workingMinutes, breakMinutes }
}

const getWeeklyWorkingTimes = (workingTimes) => {
    const today = new Date()
    today.setHours(0, 0, 0, 0)

    const startOfWeek = new Date(today)
    startOfWeek.setDate(today.getDate() - today.getDay() + 1)

    const endOfWeek = new Date(startOfWeek)
    endOfWeek.setDate(startOfWeek.getDate() + 6)

    const filteredWorkingTimes = workingTimes.filter((wt) => {
        const start = new Date(wt.start)
        return start >= startOfWeek && start <= endOfWeek
    })

    const dailyWorkingMinutes = Array(7).fill(0)

    filteredWorkingTimes.forEach((wt) => {
        const start = new Date(wt.start)
        const end = new Date(wt.end)
        if (!isNaN(start) && !isNaN(end)) {
            const dayIndex = (start.getDay() + 6) % 7
            const minutes = (end - start) / (1000 * 60)
            dailyWorkingMinutes[dayIndex] += minutes
        }
    })

    return dailyWorkingMinutes.map((minutes) => Math.min(minutes, 8 * 60))
}

onMounted(async () => {
    try {
        const response = await workingTimeService.getWorkingTimeByUserId(userId)
        const workingTimes = response.data || []

        const { workingMinutes, breakMinutes } = getDailyWorkingTimes(workingTimes)

        const pieCtx = document.getElementById('pieChart').getContext('2d')
        pieChart.value = new Chart(pieCtx, {
            type: 'doughnut',
            data: {
                labels: ['Working Hours', 'Break Hours'],
                datasets: [
                    {
                        label: 'Time Distribution',
                        data: [workingMinutes, breakMinutes],
                        backgroundColor: ['#C026D3', '#FAE8FF'],
                        borderColor: ['#FAE8FF', '#C026D3'],
                        borderWidth: 0,
                        hoverOffset: 4,
                        radius: '85%',
                        borderRadius: [2, 2],
                        spacing: -5,
                    },
                ],
            },
            options: {
                cutout: '85%',
                plugins: {
                    title: {
                        display: true,
                        text: 'Daily Work Time Distribution',
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                const value = context.raw
                                return `${context.label}: ${formatTime(value)}`
                            },
                        },
                    },
                },
            },
        })

        const weeklyWorkingMinutes = getWeeklyWorkingTimes(workingTimes)

        const lineCtx = document.getElementById('lineChart').getContext('2d')
        const gradient = lineCtx.createLinearGradient(0, 0, 0, 400)
        gradient.addColorStop(0, '#C026D3')
        gradient.addColorStop(1, 'rgba(255, 255, 255, 0)')

        lineChart.value = new Chart(lineCtx, {
            type: 'line',
            data: {
                labels: ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'],
                datasets: [
                    {
                        label: 'Working Hours',
                        data: weeklyWorkingMinutes,
                        backgroundColor: gradient,
                        borderColor: '#C026D3',
                        borderWidth: 2,
                        tension: 0.47,
                        fill: true,
                        pointRadius: 2,
                    },
                ],
            },
            options: {
                plugins: {
                    title: {
                        display: true,
                        text: 'Weekly Work Time',
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                const value = context.raw
                                return `${context.label}: ${formatTime(value)}`
                            },
                        },
                    },
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 8 * 60,
                        ticks: {
                            stepSize: 60,
                            callback: function (value) {
                                return formatTime(value).replace('0m', '\n')
                            },
                        },
                    },
                },
            },
        })

        const radarCtx = document.getElementById('radarChart').getContext('2d')
        radarChart.value = new Chart(radarCtx, {
            type: 'radar',
            data: {
                labels: ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'],
                datasets: [
                    {
                        label: 'Working Hours',
                        data: weeklyWorkingMinutes,
                        backgroundColor: ['rgba(153, 102, 255, 0.2)', 'rgba(153, 102, 255, 0.2)'],
                        borderColor: 'rgba(153, 102, 255, 1)',
                        borderWidth: 1,
                    },
                ],
            },
            options: {
                plugins: {
                    title: {
                        display: true,
                        text: 'Weekly Work Time',
                    },
                    tooltip: {
                        callbacks: {
                            label: function (context) {
                                const value = context.raw
                                return `${context.label}: ${formatTime(value)}`
                            },
                        },
                    },
                },
                scales: {
                    r: {
                        beginAtZero: true,
                        max: 7 * 60,
                        ticks: {
                            stepSize: 60,
                            callback: function (value) {
                                return formatTime(value).replace('0m', '\n')
                            },
                        },
                    },
                },
            },
        })
    } catch (error) {
        console.error('Failed to fetch working times:', error)
    }
})
</script>

<template>
    <div class="flex flex-wrap items-center gap-6">
        <div class="p-5 bg-[#FEFFEE] rounded-lg">
            <canvas id="lineChart" width="420" height="425"></canvas>
        </div>
        <div class="p-5 bg-[#FEFFEE] rounded-lg">
            <canvas id="pieChart" width="400" height="400"></canvas>
            <div class="flex space-x-4 justify-between">
                <p><strong>Working Time:</strong> {{ formatTime(timeWorked?.valueOf()) }}</p>
                <p><strong>Break Time:</strong> {{ formatTime(timeBreak?.valueOf()) }}</p>
            </div>
        </div>
        <div v-if="all" class="p-5 bg-[#FEFFEE] rounded-lg">
            <canvas id="radarChart" width="400" height="400"></canvas>
        </div>
    </div>
</template>
