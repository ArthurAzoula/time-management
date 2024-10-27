import api from '../api/api';
import { AxiosResponse } from 'axios';
import { UserType } from '@/types/userType';

// Utilitaire pour gérer les erreurs
const handleError = (error: any): never => {
    throw new Error(error.message || error);
};

export const userService = {
    async getUsers(params: Record<string, string>): Promise<UserType[]> {
        try {
            const response: AxiosResponse<UserType[]> = await api.get('users', { params });
            return response.data;
        } catch (error: any) {
            return handleError(error);
        }
    },

    async getUser(id: UserType['id']): Promise<UserType> {
        try {
            const response: AxiosResponse<UserType> = await api.get(`users/${id}`);
            return response.data;
        } catch (error: any) {
            return handleError(error);
        }
    },

    async createUser(data: Partial<UserType>): Promise<UserType> {
        try {
            const response: AxiosResponse<UserType> = await api.post('users', data);
            return response.data;
        } catch (error: any) {
            return handleError(error);
        }
    },

    async updateUser(id: UserType['id'], data: Partial<UserType>): Promise<UserType> {
        try {
            const response: AxiosResponse<UserType> = await api.put(`users/${id}`, data);
            return response.data;
        } catch (error: any) {
            return handleError(error);
        }
    },

    async deleteUser(id: UserType['id']): Promise<void> {
        try {
            await api.delete(`users/${id}`);
        } catch (error: any) {
            return handleError(error);
        }
    },
};