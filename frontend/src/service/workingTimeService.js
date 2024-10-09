import api from "../api/axios"

export const workingTimeService = {

    async getWorkingTimeByUserId (userId, params) { 
        try {
            const response = await api.get(`workingtime/${userId}`, { params })
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    }   

}