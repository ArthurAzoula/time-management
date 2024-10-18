import api from '../api/axios'

export const userService = {
    async getUsers(params) {
        try {
            const response = await api.get('users', { params })
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async getUser(id) {
        try {
            const response = await api.get(`users/${id}`)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async createUser(data) {
        try {
            const response = await api.post('users', data)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async updateUser(id, data) {
        try {
            const response = await api.put(`users/${id}`, data)
            return response.data
        } catch (error) {
            throw new Error(error)
        }
    },

    async deleteUser(id) {
        try {
            const response = await api.delete(`users/${id}`)
            return response
        } catch (error) {
            throw new Error(error)
        }
    },

    async login(data) {
        console.log(data)
        try {
            const response = await api.post('/login', data)
            return response.data.token
        } catch (error) {
            throw new Error(error)
        }
    },

}
