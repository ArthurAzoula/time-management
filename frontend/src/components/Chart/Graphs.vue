<script setup>
import Chart from 'chart.js/auto'
import { onMounted, ref } from 'vue'
import { workingTimeService } from '../../service/workingTimeService'

const lineChart = ref(null)
const pieChart = ref(null)
const radarChart = ref(null)

const userId = 1

const formatTime = (minutes) => {
    const hours = Math.floor(minutes / 60)
    const mins = Math.floor(minutes % 60)
    if (hours > 0) {
        return `${hours}h ${mins}m`
    } else {
        return `${mins}m`
    }
}

const getDailyWorkingTimes = (workingTimes) => {
    const today = new Date()
    today.setHours(0, 0, 0, 0) // Réinitialiser l'heure à 00:00:00

    const filteredWorkingTimes = workingTimes.filter((wt) => {
        const start = new Date(wt.start)
        start.setHours(0, 0, 0, 0) // Réinitialiser l'heure de début à 00:00:00
        return start.getTime() === today.getTime() // Comparer uniquement les dates
    })

    const totalWorkingMinutes = filteredWorkingTimes.reduce((acc, wt) => {
        const start = new Date(wt.start)
        const end = new Date(wt.end)
        if (isNaN(start) || isNaN(end)) {
            console.error('Invalid date:', wt)
            return acc
        }
        const minutes = (end - start) / (1000 * 60) // Durée en minutes
        return acc + minutes
    }, 0)

    const totalMinutesInDay = 7 * 60
    const workingMinutes = Math.min(totalWorkingMinutes, totalMinutesInDay)
    const breakMinutes = totalMinutesInDay - workingMinutes

    return { workingMinutes, breakMinutes }
}

const getWeeklyWorkingTimes = (workingTimes) => {
    const today = new Date()
    today.setHours(0, 0, 0, 0) // Réinitialiser l'heure à 00:00:00

    // Obtenir le début de la semaine (lundi)
    const startOfWeek = new Date(today)
    startOfWeek.setDate(today.getDate() - today.getDay() + 1)

    // Obtenir la fin de la semaine (dimanche)
    const endOfWeek = new Date(startOfWeek)
    endOfWeek.setDate(startOfWeek.getDate() + 6)

    // Filtrer les entrées de temps de travail pour la semaine en cours
    const filteredWorkingTimes = workingTimes.filter((wt) => {
        const start = new Date(wt.start)
        return start >= startOfWeek && start <= endOfWeek
    })

    // Initialiser un tableau pour stocker les heures de travail par jour
    const dailyWorkingMinutes = Array(7).fill(0)

    // Calculer les heures de travail pour chaque jour de la semaine
    filteredWorkingTimes.forEach((wt) => {
        const start = new Date(wt.start)
        const end = new Date(wt.end)
        if (!isNaN(start) && !isNaN(end)) {
            const dayIndex = (start.getDay() + 6) % 7 // Convertir dimanche (0) en dernier jour (6)
            const minutes = (end - start) / (1000 * 60) // Durée en minutes
            dailyWorkingMinutes[dayIndex] += minutes
        }
    })

    return dailyWorkingMinutes.map((minutes) => Math.min(minutes, 7 * 60)) // Limiter à 7 heures par jour
}

onMounted(async () => {
    try {
        const response = await workingTimeService.getWorkingTimeByUserId(userId)

        const workingTimes = response.data || []

        workingTimes.map((wt) => console.log('Start:', wt.start, 'End:', wt.end))

        const { workingMinutes, breakMinutes } = getDailyWorkingTimes(workingTimes)

        const workingTimeFormatted = formatTime(workingMinutes)
        const breakTimeFormatted = formatTime(breakMinutes)

        const pieLabels = ['Working Hours', 'Break Hours']
        const pieData = [workingMinutes, breakMinutes]

        const pieCtx = document.getElementById('pieChart').getContext('2d')
        pieChart.value = new Chart(pieCtx, {
            type: 'doughnut',
            data: {
                labels: pieLabels,
                datasets: [{
                    label: 'Time Distribution',
                    data: [workingMinutes, breakMinutes], // Placer les heures de pause avant les heures de travail
                    backgroundColor: [
                    '#C026D3', // Couleur pour les heures de travail
                        '#FAE8FF',  // Couleur pour les heures de pause
                    ],
                    borderColor: [
                        '#FAE8FF',  // Couleur pour les heures de pause
                        '#C026D3', // Couleur pour les heures de travail
                    ],
                    borderWidth: 1,
                    hoverOffset: 4,
                    radius: '85%', // Réduire le rayon du cercle doughnut
                    borderRadius: [20, 2], // Ajouter un borderRadius uniquement à la partie C026D3
                    spacing: -5 // Réduire l'espace entre les segments
                }]
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
                                const index = context.dataIndex
                                const value = context.raw
                                return `${context.label}: ${formatTime(value)}`
                            },
                        },
                    },
                },
            },
        })

        // Obtenir les temps de travail hebdomadaires
        const weeklyWorkingMinutes = getWeeklyWorkingTimes(workingTimes)

        // Préparer les labels pour les jours de la semaine
        const lineLabels = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche']

        const lineCtx = document.getElementById('lineChart').getContext('2d')
        const gradient = lineCtx.createLinearGradient(0, 0, 0, 400)
        gradient.addColorStop(0, '#C026D3')
        gradient.addColorStop(1, 'rgba(255, 255, 255, 0)')

        lineChart.value = new Chart(lineCtx, {
            type: 'line',
            data: {
                labels: lineLabels,
                datasets: [{
                    label: 'Working Hours',
                    data: weeklyWorkingMinutes,
                    backgroundColor: gradient,
                    borderColor: '#C026D3',
                    borderWidth: 2,
                    tension: 0.47,
                    fill: true,
                    pointRadius: 2
                    
                }]
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
                                const index = context.dataIndex
                                const value = context.raw
                                return `${context.label}: ${formatTime(value)}`
                            },
                        },
                    },
                },
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 8 * 60, // Limiter à 7 heures par jour
                        ticks: {
                            stepSize: 60, // Afficher les étiquettes par incréments de 1 heure
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
                labels: lineLabels,
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
                                const index = context.dataIndex
                                const value = context.raw
                                return `${context.label}: ${formatTime(value)}`
                            },
                        },
                    },
                },
                scales: {
                    r: {
                        beginAtZero: true,
                        max: 7 * 60, // Limiter à 7 heures par jour
                        ticks: {
                            stepSize: 60, // Afficher les étiquettes par incréments de 1 heure
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
            <canvas id="lineChart" width="400" height="400"></canvas>
        </div>
        <div class="p-5 bg-[#FEFFEE] rounded-lg">
            <canvas id="pieChart" width="400" height="400"></canvas>
        </div>
        <div class="p-5 bg-[#FEFFEE] rounded-lg">
            <canvas id="radarChart" width="400" height="400"></canvas>
        </div>
    </div>
</template>
