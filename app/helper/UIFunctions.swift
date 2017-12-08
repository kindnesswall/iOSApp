
import Foundation
import UIKit


public class UIFunctions{
    public static func CastNumberToPersian(input:String)->String{
        
        var number=input
        
        number=number.replacingOccurrences(of: "0", with: "۰")
        number=number.replacingOccurrences(of: "1", with: "۱")
        number=number.replacingOccurrences(of: "2", with: "۲")
        number=number.replacingOccurrences(of: "3", with: "۳")
        number=number.replacingOccurrences(of: "4", with: "۴")
        number=number.replacingOccurrences(of: "5", with: "۵")
        number=number.replacingOccurrences(of: "6", with: "۶")
        number=number.replacingOccurrences(of: "7", with: "۷")
        number=number.replacingOccurrences(of: "8", with: "۸")
        number=number.replacingOccurrences(of: "9", with: "۹")
        
        return number
        
    }
    
    public static func CastNumberToPersian(input:Int)->String{
        
        var number=String(input)
        
        number=number.replacingOccurrences(of: "0", with: "۰")
        number=number.replacingOccurrences(of: "1", with: "۱")
        number=number.replacingOccurrences(of: "2", with: "۲")
        number=number.replacingOccurrences(of: "3", with: "۳")
        number=number.replacingOccurrences(of: "4", with: "۴")
        number=number.replacingOccurrences(of: "5", with: "۵")
        number=number.replacingOccurrences(of: "6", with: "۶")
        number=number.replacingOccurrences(of: "7", with: "۷")
        number=number.replacingOccurrences(of: "8", with: "۸")
        number=number.replacingOccurrences(of: "9", with: "۹")
        
        return number
        
    }

    public static func setPriceBtn(priceBtn:UIButton,price: String?,color:UIColor){

        if let price = price {
            let faPrice = self.CastNumberToPersian(input: price)
            if faPrice == "۰" {
                priceBtn.setTitle("رایگان", for: .normal)
            }else { priceBtn.setTitle(faPrice+" تومان", for: .normal)}
        }
        self.setBordersStyle(view: priceBtn, radius: 5, width: 1, color: color)
    }
    
    
    public static func setBordersStyle(view: UIView, radius: Int, width: Int?,color: UIColor?){
        
        if let borderWidth = width{
            view.layer.borderWidth = CGFloat(borderWidth)
        }else{
            view.layer.borderWidth = CGFloat(1)
        }
        
        view.layer.masksToBounds = false
        
        if let borderColor=color {
            view.layer.borderColor = borderColor.cgColor
        } else {
            view.layer.borderColor = UIColor(red: 181.0/255.0, green: 181.0/255.0, blue: 181.0/255.0, alpha: 1).cgColor
        }
        view.layer.cornerRadius = CGFloat(radius)
        view.clipsToBounds = true
    }
    
    public static func makeCircleView(borderWidth: Int, imageView: UIView){
        imageView.layer.borderWidth = CGFloat(borderWidth)
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor(red: 194.0/255.0, green: 194.0/255.0, blue: 194.0/255.0, alpha: 1).cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    }
    
    public static func makeCircleView(borderWidth: Int, imageView: UIView, borderColor: UIColor){
        imageView.layer.borderWidth = CGFloat(borderWidth)
        imageView.layer.masksToBounds = false
        if borderColor != nil {
          imageView.layer.borderColor = borderColor.cgColor
        } else {
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    }
    
    public static func makeCircleViewWithoutBorder(imageView: UIView){
        imageView.layer.masksToBounds = false
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.layer.cornerRadius = imageView.frame.height/2
        imageView.clipsToBounds = true
    }
    
    public static func makeCornerRadius(imageView: UIView,cornerRadius:CGFloat){
        
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = cornerRadius
        imageView.clipsToBounds = true
    }
    public static func castNumberToPersianLetter(input:String)->String{
        
        var number = input
        number=number.replacingOccurrences(of: "0", with: "اول")
        number=number.replacingOccurrences(of: "1", with: "دوم")
        number=number.replacingOccurrences(of: "2", with: "سوم")
        number=number.replacingOccurrences(of: "3", with: "چهارم")
        number=number.replacingOccurrences(of: "4", with: "پنجم")
        number=number.replacingOccurrences(of: "5", with: "ششم")
        number=number.replacingOccurrences(of: "6", with: "هفتم")
        number=number.replacingOccurrences(of: "7", with: "هشتم")
        number=number.replacingOccurrences(of: "8", with: "نهم")
        number=number.replacingOccurrences(of: "9", with: "دهم")
        
        return number
    }
    
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
}
