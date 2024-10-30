import { clockService } from "@/services/clocksService";
import { WorkingTimeType } from "@/types/workingTimeType";
import { workingTimeService } from "@/services/workingTimeService";
import { ClockType } from "@/types/clockType";

export const handleClock = async (userId: ClockType['userId']): Promise<void> => {
    try {
        const clocks: ClockType[] = await clockService.getClocks(userId);
        const lastClock = clocks[clocks.length - 1];

        if (!lastClock || lastClock.status === false) {
            const clockInBody: Partial<ClockType> = {
                clock: {
                    time: new Date().toISOString(),
                    status: true,
                }
            };

            const responseUpdateClock = await clockService.updateClock(userId, clockInBody);
            if (!responseUpdateClock) return;
        } else if (lastClock.status === true) {
            const clockOutBody: Partial<ClockType> = {
                clock: {
                    time: new Date().toISOString(),
                    status: false,
                }
            };

            const responseUpdateClock = await clockService.updateClock(lastClock.id, clockOutBody);
            if (!responseUpdateClock) return;

            const workingTimeBody = {
                workingtime: {
                    start : lastClock.time,
                    end : new Date().toISOString()
                }
            };

            const responseCreateWorkingTime = await workingTimeService.createWorkingTime(userId, workingTimeBody);
            if (!responseCreateWorkingTime) return;
            
        }
    } catch (error) {
        console.error('Failed to clocking:', error);
    }
}
