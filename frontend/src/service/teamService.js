import api from '../api/axios'

export const teamService = {

    async getUserOfTeam(userId) {
        try {
            const response = await api.get(`manager/${userId}/teams`)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },
}