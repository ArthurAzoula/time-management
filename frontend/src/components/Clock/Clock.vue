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
import { onMounted, ref, watch } from 'vue'
import { clockService } from '../../service/clockService'
import { workingTimeService } from '../../service/workingTimeService'
import { isToday, isYesterday, format } from 'date-fns'
import { formatDateUtils } from '../../utils/DateUtils'

const props = defineProps({
    userId: {
        type: Number,
        required: true,
    },
})

console.log(props.userId, 'araraazraz')
const message = ref('')

const updateMessage = async () => {
    const response = await clockService.getClocks(props.userId)

    if (!response) return

    const lastClock = response.data[0] || null

    if (!lastClock) {
        message.value = 'Premier pointage de la journée'
        return
    }

    const lastClockDate = new Date(lastClock.time)

    if (lastClock && new Date(lastClock.time).getDate() < new Date().getDate()) {
        message.value = 'No clock-in today'
    } else if (isYesterday(lastClockDate)) {
        message.value = 'First clock-in of the day'
    } else if (isToday(lastClockDate) && lastClock.status) {
        message.value = 'You are currently working since ' + format(lastClockDate, 'hh:mm a')
    } else if (isToday(lastClockDate) && !lastClock.status) {
        message.value = `Last check : ${formatDateUtils(lastClockDate)}`
    }
}

const handleClock = async () => {
    const response = await clockService.getClocks(props.userId)

    if (!response) return

    const lastClock = response.data[0] || null

    if (!lastClock.status) {
        const body = {
            clock: {
                time: new Date().toISOString(),
                status: true,
            },
        }

        const responseUpdateClock = await clockService.updateClock(lastClock.id, body)

        if (!responseUpdateClock) return

        toast.success('Activity started successfully!')
    } else {
        const body = {
            clock: {
                time: new Date().toISOString(),
                status: false,
            },
        }

        const responseUpdateClock = await clockService.updateClock(lastClock.id, body)

        if (!responseUpdateClock) return

        if (!lastClock) return

        const responseCreateWorkingTime = await workingTimeService.createWorkingTime(props.userId, {
            workingtime: {
                start: lastClock.time,
                end: new Date().toISOString(),
            },
        })

        if (!responseCreateWorkingTime) return

        toast.success('End of work period')
    }

    updateMessage()
}

onMounted(() => {
    updateMessage()
})
</script>
