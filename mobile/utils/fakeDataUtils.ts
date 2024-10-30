import { WorkingTimeType } from '@/types/workingTimeType';
 
export const generateFakeWorkingTimes = (userId: number, count: number): WorkingTimeType[] => {
  const workingTimes: WorkingTimeType[] = [];
  const now = new Date();
 
  for (let i = 0; i < count; i++) {
    const start = new Date(now);
    start.setDate(now.getDate() - i);
    start.setHours(9, 0, 0, 0); 
 
    const end = new Date(start);
    end.setHours(17, 0, 0, 0); 
 
    workingTimes.push({
        id: i + 1,
        userId,
        start: start.toISOString(),
        end: end.toISOString(),
        createdAt: start.toISOString(),
        updatedAt: end.toISOString(),
        workingtime: undefined
    });
  }
 
  return workingTimes;
};
 
import { UserType } from '@/types/userType';
 
export const generateFakeUser = (): UserType => {
  return {
    id: 1,
    username: 'John',
    email: 'john.doe@example.com',
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
    data: null, 
    password: 'password123' 
  };
};
