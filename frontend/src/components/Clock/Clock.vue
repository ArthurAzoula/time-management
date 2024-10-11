<template>
    <div>
        <div class="flex items-center gap-4">
            <button
                class="bg-button-300 border border-button-200 px-4 py-2 rounded-md transition duration-200 ease-in-out hover:bg-button-400 disabled:opacity-50"
                @click="handleClock"
            >
                <p class="text-text-color-100 font-bold">Clock In</p>
            </button>
            <p class="text-text-color-100 text-sm">{{ message }}</p>
        </div>
    </div>
</template>

<script setup>
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import { onMounted, ref } from 'vue'
import { clockService } from '../../service/clockService'
import { workingTimeService } from '../../service/workingTimeService'
import { isToday, isYesterday, format } from 'date-fns'
import { formatDateUtils } from '../../utils/DateUtils'

const userId = ref(1)
const message = ref('')

const updateMessage = async () => {
    const response = await clockService.getClocks(userId.value)

    if (!response) return

    const lastClock = response.data[0] || null

    if (!lastClock) {
        message.value = 'Premier pointage de la journée'
        return
    }

    const lastClockDate = new Date(lastClock.time)

    // if the clock-in is from yesterday or earlier
    if (lastClock && new Date(lastClock.time).getDate() < new Date().getDate()) {
        message.value = 'No clock-in today'
    } else if (isYesterday(lastClockDate)) {
        message.value = 'First clock-in of the day'
    } else if (isToday(lastClockDate) && lastClock.status) {
        message.value = 'You are currently working'
    } else if (isToday(lastClockDate) && !lastClock.status) {
        message.value = `Last check : ${formatDateUtils(lastClockDate)}`
    }
}

const handleClock = async () => {
    const response = await clockService.getClocks(userId.value)

    if (!response) return

    const lastClock = response.data[0] || null

    if (!lastClock.status) {
        // le modifier et le passé à true (début de la journée)
        const body = {
            clock: {
                time: new Date().toISOString(),
                status: true,
            },
        }

        const responseUpdateClock = await clockService.updateClock(lastClock.id, body)

        if (!responseUpdateClock) return

        toast.success('Début de la journée enregistré avec succès !')
    } else {
        // le modifier et le passé à false (fin de la journée)
        const body = {
            clock: {
                time: new Date().toISOString(),
                status: false,
            },
        }

        const responseUpdateClock = await clockService.updateClock(lastClock.id, body)

        console.log(responseUpdateClock)

        if (!responseUpdateClock) return

        if (!lastClock) return

        // crée un temps de travail
        const responseCreateWorkingTime = await workingTimeService.createWorkingTime(userId.value, {
            workingtime: {
                start: lastClock.time,
                end: new Date().toISOString(),
            },
        })

        if (!responseCreateWorkingTime) return

        toast.success('Fin de la journée enregistrée avec succès !')
    }

    updateMessage()
}

onMounted(() => {
    updateMessage()
})
</script>
