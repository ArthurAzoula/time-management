import  api from "@/api/api";
import { WorkingTimeType } from "@/types/workingTimeType";
import { AxiosResponse } from "axios";

export const workingTimeService = {
    async getWorkingTimeByUserId(userId: WorkingTimeType['userId'], params: Record<string, string>): Promise<{ data: WorkingTimeType[] }> {
        try {
            const response: AxiosResponse<{ data: WorkingTimeType[] }> = await api.get(`workingtime/${userId}`, { params });
            return response.data;  // Return the data object
        } catch (error: any) {
            throw new Error(error);
        }
    },

    async getWorkingTimeByUserAndById(userId: WorkingTimeType['userId'], id: WorkingTimeType['id']): Promise<WorkingTimeType> {
        try {
            const response: AxiosResponse<WorkingTimeType> = await api.get(`workingtime/${userId}/${id}`)
            return response.data
        } catch (error: any) {
            throw new Error(error)
        }
    },

    async createWorkingTime(userId: WorkingTimeType['userId'], data: Partial<WorkingTimeType>): Promise<WorkingTimeType> {
        try {
            const response: AxiosResponse<WorkingTimeType> = await api.post(`workingtime/${userId}`, data)
            return response.data
        } catch (error: any) {
            throw new Error(error)
        }
    },

    async updateWorkingTime(id: WorkingTimeType['id'], data: Partial<WorkingTimeType>): Promise<WorkingTimeType> {
        try {
            const response: AxiosResponse<WorkingTimeType> = await api.put(`workingtime/${id}`, data)
            return response.data
        } catch (error: any) {
            throw new Error(error)
        }
    },

    async deleteWorkingTime(id: WorkingTimeType['id']): Promise<AxiosResponse> {
        try {
            const response: AxiosResponse<WorkingTimeType> = await api.delete(`workingtime/${id}`)
            return response
        } catch (error: any) {
            throw new Error(error)
        }
    },
}
