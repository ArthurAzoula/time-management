import api from '../api/axios'

export const clockService = {
    async getAllClocks() {
        try {
            const response = await api.get('clocks')
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async getClocks(userId) {
        try {
            const response = await api.get(`clocks/${userId}`)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async createClock(userId, data) {
        try {
            const response = await api.post(`clocks/${userId}`, data)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async updateClock(id, data) {
        try {
            const response = await api.put(`clocks/${id}`, data)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },
}
