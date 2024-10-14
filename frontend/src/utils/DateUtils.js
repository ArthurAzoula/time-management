import { format, isToday, isYesterday } from 'date-fns'

export const formatDateUtils = (date) => {
    const parsedDate = new Date(date)

    if (isToday(parsedDate)) {
        return `Today at ${format(parsedDate, 'p')}`
    } else if (isYesterday(parsedDate)) {
        return `Yesterday at ${format(parsedDate, 'p')}`
    } else {
        return `Last clock-in on ${format(parsedDate, 'PPpp')}`
    }
}

export const extractHourFromISO = (date) => {
    return new Date(date).getHours()
}

export const getDifferenceInhours = (date1, date2) => {
    return Math.abs(new Date(date1).getHours() - new Date(date2).getHours())
}
