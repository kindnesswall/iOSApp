
import Foundation
import  UIKit

public class DateHelper {
    
    public static func makeDate(birthdateYear:String,birthdayMonth:String,birthdayDay:String)->String{
        
        var birthdate=""
        var day = birthdayDay
        
        if(day.characters.count == 1){
            day = "0"+day
        }
        
        var month = birthdayMonth
        month=month.replacingOccurrences(of: "فروردین", with: "01")
        month=month.replacingOccurrences(of: "اردیبهشت", with: "02")
        month=month.replacingOccurrences(of: "خرداد", with: "03")
        month=month.replacingOccurrences(of: "تیر", with: "04")
        month=month.replacingOccurrences(of: "مرداد", with: "05")
        month=month.replacingOccurrences(of: "شهریور", with: "06")
        month=month.replacingOccurrences(of: "مهر", with: "07")
        month=month.replacingOccurrences(of: "آبان", with: "08")
        month=month.replacingOccurrences(of: "آذر", with: "09")
        month=month.replacingOccurrences(of: "دی", with: "10")
        month=month.replacingOccurrences(of: "بهمن", with: "11")
        month=month.replacingOccurrences(of: "اسفند", with: "12")
        
        birthdate = birthdateYear+"/"+month+"/"+day
        return birthdate
    }
    
    
    public static func persionMonth(persionMonth:String)->String{
        
        var number = persionMonth
        number=number.replacingOccurrences(of: "۰۱", with: "فروردین")
        number=number.replacingOccurrences(of: "۰۲", with: "اردیبهشت")
        number=number.replacingOccurrences(of: "۰۳", with: "خرداد")
        number=number.replacingOccurrences(of: "۰۴", with: "تیر")
        number=number.replacingOccurrences(of: "۰۵", with: "مرداد")
        number=number.replacingOccurrences(of: "۰۶", with: "شهریور")
        number=number.replacingOccurrences(of: "۰۷", with: "مهر")
        number=number.replacingOccurrences(of: "۰۸", with: "آبان")
        number=number.replacingOccurrences(of: "۰۹", with: "آذر")
        number=number.replacingOccurrences(of: "۱۰", with: "دی")
        number=number.replacingOccurrences(of: "۱۱", with: "بهمن")
        number=number.replacingOccurrences(of: "۱۲", with: "اسفند")
        
        return number
        
    }
    
    public static func getPersianWeekDayName(weekDay:String)->String {
        switch weekDay {
        case "Saturday":
            return "شنبه"
        case "Sunday":
            return "یک‌‌‌‍ شنبه"
        case "Monday":
            return "دو شنبه"
        case "Tuesday":
            return "سه شنبه"
        case "Wednesday":
            return "چهار شنبه"
        case "Thursday":
            return "پنج شنبه"
        case "Friday":
            return "جمعه"
            
        default:
            return ""
        }
    }
    
    public static func getFaTime(faDate: String)->String{
        
        
        let startIndex = faDate.index(faDate.startIndex, offsetBy: 10)
        let endIndex = faDate.index(faDate.startIndex, offsetBy: 15)
        var timeStr = String(faDate[startIndex...endIndex])
        
        timeStr=timeStr.replacingOccurrences(of: ":", with: " : ")
        
        timeStr = UIFunctions.CastNumberToPersian(input: timeStr)
        
        return timeStr
    }
    
    
    public static func getTime(faDate: String)->String{
        
        let startIndex = faDate.index(faDate.startIndex, offsetBy: 10)
        let endIndex = faDate.index(faDate.startIndex, offsetBy: 18)
        let timeStr = String(faDate[startIndex...endIndex])
        
        return timeStr
    }
    
    public static func getFaDate(faDate: String)->String{
        let startIndex = faDate.index(faDate.startIndex, offsetBy: 5)
        let endIndex = faDate.index(faDate.startIndex, offsetBy: 9)
        var timeStr = String(faDate[startIndex...endIndex])
        
        timeStr = UIFunctions.CastNumberToPersian(input:timeStr)
        
        timeStr=timeStr.replacingOccurrences(of: "۰۱", with: "۱")
        timeStr=timeStr.replacingOccurrences(of: "۰۲", with: "۲")
        timeStr=timeStr.replacingOccurrences(of: "۰۳", with: "۳")
        timeStr=timeStr.replacingOccurrences(of: "۰۴", with: "۴")
        timeStr=timeStr.replacingOccurrences(of: "۰۵", with: "۵")
        timeStr=timeStr.replacingOccurrences(of: "۰۶", with: "۶")
        timeStr=timeStr.replacingOccurrences(of: "۰۷", with: "۷")
        timeStr=timeStr.replacingOccurrences(of: "۰۸", with: "۸")
        timeStr=timeStr.replacingOccurrences(of: "۰۹", with: "۹")
        
        return timeStr
    }
    
    public static func getFaDateWithYear(faDate: String)->String{
        let startIndex = faDate.index(faDate.startIndex, offsetBy: 0)
        let endIndex = faDate.index(faDate.startIndex, offsetBy: 9)
        var timeStr = String(faDate[startIndex...endIndex])
        
        timeStr = UIFunctions.CastNumberToPersian(input:timeStr)
        
        timeStr=timeStr.replacingOccurrences(of: "۰۱", with: "۱")
        timeStr=timeStr.replacingOccurrences(of: "۰۲", with: "۲")
        timeStr=timeStr.replacingOccurrences(of: "۰۳", with: "۳")
        timeStr=timeStr.replacingOccurrences(of: "۰۴", with: "۴")
        timeStr=timeStr.replacingOccurrences(of: "۰۵", with: "۵")
        timeStr=timeStr.replacingOccurrences(of: "۰۶", with: "۶")
        timeStr=timeStr.replacingOccurrences(of: "۰۷", with: "۷")
        timeStr=timeStr.replacingOccurrences(of: "۰۸", with: "۸")
        timeStr=timeStr.replacingOccurrences(of: "۰۹", with: "۹")
        
        return timeStr
    }
    
    public static func getHour(time: String)->Int{
        let startIndex = time.index(time.startIndex, offsetBy: 1)
        let endIndex = time.index(time.startIndex, offsetBy: 2)
        let hour = time[startIndex...endIndex]
        
        return Int(hour)!
    }
    
    public static func getMinute(time: String)->Int{
        let startIndex = time.index(time.startIndex, offsetBy: 4)
        let endIndex = time.index(time.startIndex, offsetBy: 5)
        let minute = time[startIndex...endIndex]
        
        return Int(minute)!
    }
    
    public static func getSecond(time: String)->Int{
        let startIndex = time.index(time.startIndex, offsetBy: 7)
        let endIndex = time.index(time.startIndex, offsetBy: 8)
        let second = time[startIndex...endIndex]
        
        return Int(second)!
    }
    
    public static func timeDifferenceCalculator(startTime: String, endTime: String)-> Int{
        
        let hoursDiff = getHour(time: endTime)-getHour(time:startTime)
        let minDiff = getMinute(time:endTime)-getMinute(time:startTime)
        let secDiff = getSecond(time: endTime)-getSecond(time:startTime)
        
        let totalDiffOnSeconds = (hoursDiff*3600)+(minDiff*60)+secDiff
        let totalDiffOnMinute = totalDiffOnSeconds/60
        
        return totalDiffOnMinute
    }
    
    static func isToday(currentTime:Time,startTime:Time)->Bool{
        let current_time = self.getFaDate(faDate: currentTime.fa_date!)
        let start_time = self.getFaDate(faDate: startTime.fa_date!)
        
        if(current_time == start_time) {
            return true
        }
        return false
    }
}

