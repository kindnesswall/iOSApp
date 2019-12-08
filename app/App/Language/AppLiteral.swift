//
//  AppLiteral.swift
//  app
//
//  Created by Amir Hossein on 11/17/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class AppLiteral {

    static var back: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "بازگشت"
        case .english:
            return "Back"
        }
    }

    static var cancel: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "انصراف"
        case .english:
            return "Cancel"
        }
    }

    static var yes: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "بله"
        case .english:
            return "Yes"
        }
    }

    static var no: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "خیر"
        case .english:
            return "No"
        }
    }

    static var skip: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "بگذر"
        case .english:
            return "Skip"
        }
    }

    static var home: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "خانه"
        case .english:
            return "Home"
        }
    }

    static var myGifts: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "هدیه‌های من"
        case .english:
            return "My Gifts"
        }
    }

    static var registerGift: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ثبت هدیه"
        case .english:
            return "Gift Registering"
        }
    }

    static var edit: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ویرایش"
        case .english:
            return "Edit"
        }
    }

    static var editGift: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ویرایش هدیه"
        case .english:
            return "Gift Editing"
        }
    }

    static var request: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "درخواست"
        case .english:
            return "Request"
        }
    }

    static var remove: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "حذف"
        case .english:
            return "Remove"
        }
    }

    static var status: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "وضعیت"
        case .english:
            return "Status"
        }
    }

    static var address: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "آدرس"
        case .english:
            return "Address"
        }
    }

    static var allGifts: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "همه هدیه‌ها"
        case .english:
            return "All Gifts"
        }
    }

    static var allCities: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "همه شهر‌ها"
        case .english:
            return "All Cities"
        }
    }

    static var allRegions: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "همه منطقه‌ها"
        case .english:
            return "All Regions"
        }
    }

    static var category: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دسته بندی"
        case .english:
            return "Category"
        }
    }

    static var giftCategory: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دسته بندی هدیه"
        case .english:
            return "Gift Category"
        }
    }

    static var newOrSecondHand: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "نو یا دسته دو بودن"
        case .english:
            return "New or Secondhand"
        }
    }

    static var new: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "نو"
        case .english:
            return "New"
        }
    }

    static var secondHand: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دسته‌دو"
        case .english:
            return "Secondhand"
        }
    }

    static var placeOfTheGift: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "محل هدیه"
        case .english:
            return "Place of the Gift"
        }
    }

    static var registered: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ثبت شده"
        case .english:
            return "Registered"
        }
    }

    static var donated: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "اهدایی"
        case .english:
            return "Donated"
        }
    }

    static var clearPage: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "پاک کردن صفحه"
        case .english:
            return "Clear Page"
        }
    }

    static var saveDraft: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ذخیره پیش‌ نویس"
        case .english:
            return "Save Draft"
        }
    }

    static var select: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "انتخاب"
        case .english:
            return "Select"
        }
    }

    static var camera: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دوربین"
        case .english:
            return "Camera"
        }
    }

    static var gallery: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "گالری تصاویر"
        case .english:
            return "Gallery"
        }
    }

    static var title: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "عنوان"
        case .english:
            return "Title"
        }
    }

    static var description: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "توضیحات"
        case .english:
            return "Description"
        }
    }

    static var approximatePriceInToman: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ارزش تقریبی به تومان"
        case .english:
            return "Approximate Price in Toman"
        }
    }

    static var addImage: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "افزودن عکس"
        case .english:
            return "Add Image"
        }
    }

    static var login: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ورود"
        case .english:
            return "Login"
        }
    }

    static var logout: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "خروج"
        case .english:
            return "Logout"
        }
    }

    static var myWall: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دیوار من"
        case .english:
            return "My Wall"
        }
    }

    static var contactUs: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ارتباط با ما"
        case .english:
            return "Contact Us"
        }
    }

    static var bugReport: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "گزارش اشکالات برنامه"
        case .english:
            return "Bug Report"
        }
    }

    static var aboutKindnessWall: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "درباره دیوار مهربانی"
        case .english:
            return "About Kindness Wall"
        }
    }

    static var letsGoToTheApplication: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "بریم داخل اپلیکیشن!"
        case .english:
            return "Let's go to the application!"
        }
    }

    static var statistic: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "آمار"
        case .english:
            return "Statistic"
        }
    }

    static var activationCode: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "کد فعالسازی"
        case .english:
            return "Activation Code"
        }
    }

    static var sendingActivationCode: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ارسال کد فعال سازی"
        case .english:
            return "Send Activation Code"
        }
    }

    static var resendingActivationCode: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دریافت مجدد کد فعالسازی"
        case .english:
            return "Resend Activation Code"
        }
    }

    static var registeringActivationCode: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ثبت کد فعالسازی"
        case .english:
            return "Register Activation Code"
        }
    }

    static var kindnessWallCulture: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "فرهنگ دیوار مهربانی"
        case .english:
            return "Kindness Wall Culture"
        }
    }

    static var withDonateCollaboration: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "با همکاری دونِیت"
        case .english:
            return "With 2Nate Collaboration"
        }
    }

    static var alwaysFree: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "همیشه رایگان"
        case .english:
            return "Always Free"
        }
    }

    static var openSource: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "متن باز"
        case .english:
            return "Open Source"
        }
    }

}
