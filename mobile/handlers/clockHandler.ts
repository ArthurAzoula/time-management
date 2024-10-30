import { clockService } from '@/services/clocksService';
import { workingTimeService } from '@/services/workingTimeService';
import { ClockType } from '@/types/clockType';

export const clockHandler = {
  async handleClock(userId: number): Promise<void> {
    try {
      // Fetch existing clocks for the user
      const clocks: ClockType[] = await clockService.getClocks(userId);
      const lastClock = clocks[0] || null;

      if (!lastClock || lastClock.status === false) {
        // Clock in: the user is not clocked in yet, or the last clock is clocked out
        const clockInBody: Partial<ClockType> = {
          clock : {
            time: new Date().toISOString(),
            status: true,  // Clocking in
          }
        };
        console.log('Clocking In:', clockInBody);
        const responseUpdateClock = await clockService.updateClock(userId, clockInBody);
        if (!responseUpdateClock) return;
        console.log('Clocked in successfully!');
      } else if (lastClock.status === true) {
        // Clock out: the user is currently clocked in, so we clock them out
        const clockOutBody: Partial<ClockType> = {
          clock: {
            time: new Date().toISOString(),
            status: false,  // Clocking out
          }
        };
        console.log('Clocking Out:', clockOutBody);
        const responseUpdateClock = await clockService.updateClock(lastClock.id, clockOutBody);
        if (!responseUpdateClock) return;
        console.log('Clocked out successfully!');

        // Record the working time from clock-in to clock-out
        const workingTimeBody = {
          start: lastClock.time,  // Start time is the last clock in
          end: new Date().toISOString(),  // End time is now (clock out)
        };
        console.log('Creating Working Time:', workingTimeBody);
        const responseCreateWorkingTime = await workingTimeService.createWorkingTime(userId, workingTimeBody);
        if (!responseCreateWorkingTime) return;
        console.log('Working time recorded successfully!');
      }
    } catch (error) {
      console.error('Failed to handle clocking:', error);
    }
  }
};