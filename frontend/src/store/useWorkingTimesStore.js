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
    }
  }
})