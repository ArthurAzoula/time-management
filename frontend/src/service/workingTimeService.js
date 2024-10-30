import api from '../api/axios'

export const workingTimeService = {
    async getWorkingTimes(params) {
        try {
            const response = await api.get('workingtime', { params })
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async getWorkingTimeByUserId(userId, params) {
        try {
            const response = await api.get(`workingtime/${userId}`, { params })
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async getWorkingTimeByUserAndById(userId, id) {
        try {
            const response = await api.get(`workingtime/${userId}/${id}`)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async createWorkingTime(userId, data) {
        try {
            const response = await api.post(`workingtime/${userId}`, data)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async updateWorkingTime(id, data) {
        try {
            const response = await api.put(`workingtime/${id}`, data)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async deleteWorkingTime(id) {
        try {
            const response = await api.delete(`workingtime/${id}`)
            return response
        } catch (error) {
            throw new Error(error)
        }
    },
}
