import api from '../api/api';
import { ClockType } from '@/types/clockType';
import { AxiosResponse } from 'axios';

export const clockService = {
    async getClocks(userId: ClockType['userId']): Promise<ClockType[]> {
        try {
            const response: AxiosResponse<ClockType[]> = await api.get(`clocks/${userId}`);
            return response.data;
        } catch (error: any) {
            throw new Error(error.message);
        }
    },

    async createClock(userId: ClockType['userId'], data: Partial<ClockType>): Promise<ClockType> {
        try {
            const response: AxiosResponse<ClockType> = await api.post(`clocks/${userId}`, data);
            return response.data;
        } catch (error: any) {
            throw new Error(error.message);
        }
    },

    async updateClock(id: ClockType['id'], data: Partial<ClockType>): Promise<ClockType> {
        try {
            const response: AxiosResponse<ClockType> = await api.put(`clocks/${id}`, data);
            return response.data;
        } catch (error: any) {
            console.error('Fail:', error);
            throw new Error(error.message);
        }
    },
};