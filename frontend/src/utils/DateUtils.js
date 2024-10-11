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
