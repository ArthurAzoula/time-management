import api from '../api/axios'

export const teamService = {
    async getTeams(params) {
        try {
            const response = await api.get('teams', { params })
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async getTeam(id) {
        try {
            const response = await api.get(`teams/${id}`)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async createTeam(data) {
        try {
            const response = await api.post('teams', data)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async getUserOfTeam(userId) {
        try {
            const response = await api.get(`manager/${userId}/teams`)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async updateTeam(id, data) {
        try {
            const response = await api.put(`teams/${id}`, data)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async deleteTeam(id) {
        try {
            const response = await api.delete(`teams/${id}`)
            return response
        } catch (error) {
            throw new Error(error)
        }
    },
}
