import { userService } from '@/services/userService';
import { workingTimeService } from '@/services/workingTimeService';
import { clockService } from '@/services/clocksService';
import { UserType } from '@/types/userType';
import { WorkingTimeType } from '@/types/workingTimeType';
import { ClockType } from '@/types/clockType';

export const fetchClocks = async (userId: UserType['id']): Promise<ClockType[]> => {
    try {
        const clocks: ClockType[] = await clockService.getClocks(userId);
        return clocks;
    } catch (error: any) {
        console.error('Failed to fetch clocks:', error);
        throw new Error(error);
    }
}

export const fetchUserData = async (userId: UserType['id']): Promise<UserType> => {
    try {
        const user: UserType = await userService.getUser(userId);
        return user;
    } catch (error: any) {
        console.error('Failed to fetch user data:', error);
        throw new Error(error);
    }
}

export const fetchWorkingTimes = async (userId: UserType['id']): Promise<WorkingTimeType[]> => {
    try {
        const response = await workingTimeService.getWorkingTimeByUserId(userId, {});
        const workingTimes = response; // Accéder à la propriété data
        return workingTimes;
    } catch (error) {
      console.error('Failed to fetch working times:', error);
      throw error;
    }
};