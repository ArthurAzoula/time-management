export type WorkingTimeType = {
    workingtime: any;
    id: number;
    userId: number;
    start: string;
    end: string;
    createdAt: string | null;
    updatedAt: string | null;
};

export interface WorkingTimeListProps {
    workingTimes: WorkingTimeType[];
    cardBackgroundColor: string;
    textColor: string;
}