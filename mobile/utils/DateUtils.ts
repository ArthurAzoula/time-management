import { format, isToday, isYesterday } from 'date-fns'

export const formatDateUtils = (date: string | number | Date) => {
    const parsedDate = new Date(date)

    if (isToday(parsedDate)) {
        return `Today at ${format(parsedDate, 'p')}`
    } else if (isYesterday(parsedDate)) {
        return `Yesterday at ${format(parsedDate, 'p')}`
    } else {
        return `Last clock-in on ${format(parsedDate, 'PPpp')}`
    }
}

export const extractHourFromISO = (date: string | number | Date) => {
    return new Date(date).getHours()
}

export const getDifferenceInhours = (date1: string | number | Date, date2: string | number | Date) => {
    return Math.abs(new Date(date1).getHours() - new Date(date2).getHours())
}

// export const calculeTotalHoursPerDay = (workingTimes) => {}
