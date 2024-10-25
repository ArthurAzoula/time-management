<template>
    <v-container fluid>
        <v-row>
            <v-col cols="12">
                <h1 class="text-2xl animated-title">Welcome back to admin dashboard ! 👋</h1>
            </v-col>
            <v-col cols="12">
                <v-alert outlined color="primary" icon="mdi-information" border="left" elevation="2">
                    Last connection : {{ lastConnection }}
                </v-alert>
            </v-col>
        </v-row>
        <v-row>
            <v-col cols="12" md="4">
                <v-card>
                    <v-card-title>
                        <v-icon left>mdi-account</v-icon>
                        Users
                    </v-card-title>
                    <v-card-text>
                        <v-row class="py-4 px-1">
                            <v-col>
                                <v-statistic title="Total Users" :value="totalUsers.length" color="primary"
                                    >{{ totalUsers.length }} User(s) register</v-statistic
                                >
                            </v-col>
                        </v-row>
                    </v-card-text>
                </v-card>
            </v-col>

            <v-col cols="12" md="4">
                <v-card>
                    <v-card-title>
                        <v-icon left>mdi-account-group</v-icon>
                        Teams
                    </v-card-title>
                    <v-card-text>
                        <v-row class="py-4 px-1">
                            <v-col cols="6">
                                <v-statistic title="Total Teams" :value="totalTeams.length" color="primary"
                                    >{{ totalTeams.length }} Team(s) created</v-statistic
                                >
                            </v-col>
                        </v-row>
                    </v-card-text>
                </v-card>
            </v-col>

            <v-col cols="12" md="4">
                <v-card>
                    <v-card-title>
                        <v-icon left>mdi-clock</v-icon>
                        Working Times
                    </v-card-title>
                    <v-card-text>
                        <v-row class="py-4 px-1">
                            <v-col cols="6">
                                <v-statistic title="Total Hours" :value="totalHoursRef" color="primary"
                                    >{{ Math.trunc(totalHoursRef) }} total hours</v-statistic
                                >
                            </v-col>
                            <v-col cols="6">
                                <v-statistic title="Average Hours" :value="averageHours" color="success"
                                    >{{ Math.trunc(averageHours) }} hours on average
                                </v-statistic>
                            </v-col>
                        </v-row>
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>

        <v-row>
            <v-col cols="12">
                <v-card>
                    <v-card-title>
                        <v-icon left>mdi-chart-bar</v-icon>
                        Statistics
                    </v-card-title>
                    <v-card-text>
                        <BarChart :chartData="chartData" />
                    </v-card-text>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { userService } from '../service/userService'
import { teamService } from '../service/teamService'
import { workingTimeService } from '../service/workingTimeService'
import BarChart from '../components/Chart/BarChart.vue'
import format from 'date-fns/format'

const lastConnection = ref(localStorage.getItem('lastConnection'))

if (!lastConnection.value) {
    lastConnection.value = new Date().toLocaleString()
    localStorage.setItem('lastConnection', lastConnection.value)
}

const totalUsers = ref([])
const totalTeams = ref([])
const totalHoursRef = ref(0)
const averageHours = ref(0)

const chartData = ref({
    labels: totalUsers.value.map((user) => user.username),
    datasets: [
        {
            label: 'Total Hours per User',
            backgroundColor: '#42A5F5',
            data: [],
        },
    ],
})

onMounted(() => {
    userService.getUsers().then((response) => {
        if (!response.data) return
        totalUsers.value = response.data
        updateChartData()
    })

    teamService.getTeams().then((response) => {
        if (!response.data) return
        totalTeams.value = response.data
    })

    workingTimeService.getWorkingTimes().then((response) => {
        if (!response.data) return
        const totalHours = response.data.reduce((acc, workingTime) => {
            const start = new Date(workingTime.start)
            const end = new Date(workingTime.end)
            const diff = end - start
            const hours = diff / 1000 / 60 / 60
            return acc + hours
        }, 0)
        totalHoursRef.value = totalHours
        averageHours.value = totalHours / response.data.length
        updateChartData()
    })
})

const calculateTotalHours = (workingTimes) => {
    return workingTimes.reduce((acc, workingTime) => {
        const start = new Date(workingTime.start)
        const end = new Date(workingTime.end)
        const diff = end - start
        return acc + diff / 1000 / 60 / 60
    }, 0)
}

const updateChartData = async () => {
    try {
        const userHours = await Promise.all(
            totalUsers.value.map(async (user) => {
                try {
                    const response = await workingTimeService.getWorkingTimeByUserId(user.id)
                    if (!response || !response.data) return 0
                    return calculateTotalHours(response.data)
                } catch (error) {
                    console.error(`Failed to fetch working times for user ${user.id}`, error)
                    return 0 // Default to 0 hours if there's an error
                }
            }),
        )

        chartData.value.labels = totalUsers.value.map((user) => user.username)
        chartData.value.datasets[0].data = userHours.map((hours) => Math.trunc(hours))
    } catch (error) {
        console.error('Failed to update chart data', error)
    }
}
</script>

<style scoped>
h1 {
    text-align: center;
    margin-bottom: 20px;
}

.v-card-title {
    font-size: 18px;
    font-weight: bold;
}


.animated-title {
  animation: fadeInSlideIn 1s ease-in-out;
}

@keyframes fadeInSlideIn {
  0% {
    opacity: 0;
    transform: translateY(-20px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}


.v-card-text {
    padding: 16px;
}

.v-chart {
    height: 300px;
    width: 100%;
}

v-container {
    padding: 20px;
}
</style>
