<template>
    <div class="p-6">
        <div class="flex flex-col space-y-7">
            <div class="flex flex-col space-y-7">
                <h1 class="text-2xl font-bold">Dashboard</h1>
                <Clock />
            </div>
            <Graphs />
            <WorkingTimesDashboard />
        </div>
    </div>
</template>

<script setup>
import Clock from '../components/Clock/Clock.vue'
import Graphs from '../components/Chart/Graphs.vue'
import WorkingTimesDashboard from '../components/WorkingTime/WorkingTimesDashboard.vue'
</script>
