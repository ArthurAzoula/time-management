import { defineStore } from 'pinia'

export const useWorkingTimesStore = defineStore('workingTimes', {
  state: () => ({
    workingTimes: []
  }),
  actions: {
    setWorkingTimes(data) {
      this.workingTimes = data
    },
    addWorkingTime(data) {
      this.workingTimes.push(data)
    },
    removeWorkingTime(id) {
      this.workingTimes = this.workingTimes.filter(time => time.id !== id)
    },
    updateWorkingTime(updatedWorkingTime) {
      const index = this.workingTimes.findIndex(time => time.id === updatedWorkingTime.id)
      if (index !== -1) {
        this.workingTimes[index] = updatedWorkingTime
      }
    }
  }
})