<script setup>
import { toast } from 'vue3-toastify'
import 'vue3-toastify/dist/index.css'
import { ref } from 'vue'
import { clockService } from '../../service/clockService'
import { workingTimeService } from '../../service/workingTimeService'


const userId = ref(1)
const loading = ref(false)


const handleClock = async () => {
    
    const response = await clockService.getClocks(userId.value)

    if (!response) return;

    const lastClock = response.data[0] || null

    if (!lastClock.status) {
        // le modifier et le passé à true (début de la journée)
        const body = {
            clock: {
                time: new Date().toISOString(),
                status: true
            }
        }

        const responseUpdateClock = await clockService.updateClock(lastClock.id, body)

        if (!responseUpdateClock) return;

        toast.success('Début de la journée enregistré avec succès !')
    } else {
        // le modifier et le passé à false (fin de la journée)
        const body = {
            clock: {
                time: new Date().toISOString(),
                status: false
            }
        }

        const responseUpdateClock = await clockService.updateClock(lastClock.id, body)

        console.log(responseUpdateClock)

        if (!responseUpdateClock) return;

        if (!lastClock) return;

        // crée un temps de travail
        const responseCreateWorkingTime = await workingTimeService.createWorkingTime(userId.value, {
            workingtime: {
                start: lastClock.time,
                end: new Date().toISOString()
            }
        })

        if (!responseCreateWorkingTime) return;

        toast.success('Fin de la journée enregistrée avec succès !')
    }
}

</script>

<template>
    <div class="flex justify-center items-center my-12">
        <button 
            class="bg-button-300 border border-button-200 px-4 py-2 rounded-md transition duration-200 ease-in-out hover:bg-button-400 disabled:opacity-50"
            :disabled="loading"
            @click="handleClock">
            <p class="text-button-100">{{ loading ? 'Chargement...' : 'Pointer' }}</p>
        </button>
    </div>
    <div v-if="loading" class="text-center mt-4">
        <p class="text-gray-500">Veuillez patienter pendant le traitement...</p>
    </div>
</template>
