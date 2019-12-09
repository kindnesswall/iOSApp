//
//  AppLiteralForMessages.swift
//  app
//
//  Created by Amir Hossein on 11/17/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import Foundation

class AppLiteralForMessages {

    static var registeredSuccessfully: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "ثبت کالا با موفقیت انجام شد"
        case .english:
            return "The gift has registered successfully"
        }
    }

    static var editedSuccessfully: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "کالا با موفقیت ویرایش شد"
        case .english:
            return "The gift has edited successfully"
        }
    }

    static var draftSavedSuccessfully: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "پیش‌نویس با موفقیت ذخیره شد"
        case .english:
            return "The draft has saved successfully"
        }
    }

    static var uploadedSuccessfully: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "آپلود عکس با موفقیت انجام شد"
        case .english:
            return "The Image has uploaded successfully"
        }
    }

    static var gettingPriceReason: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return " (صرفا جهت برآورد و نمایش در قسمت آمار است و برای دیگران نمایش داده نمیشود) "
        case .english:
            return ""
        }
    }

    // MARK: Errors

    static var imageUploadingError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "آپلود عکس با مشکل روبه‌رو شد"
        case .english:
            return "An error has occurred in image uploading"
        }
    }

    static var titleError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا عنوان کالا را وارد نمایید"
        case .english:
            return "Please write the title of the gift"
        }
    }

    static var categoryError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا دسته‌بندی کالا را انتخاب نمایید"
        case .english:
            return "Please select the category of the gift"
        }
    }

    static var newOrSecondhandError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا وضعیت نو یا دسته دو بودن کالا را مشخص کنید."
        case .english:
            return "Please select one of the \"new or secondhand\" options"
        }
    }

    static var descriptionError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا توضیحات کالا را وارد نمایید"
        case .english:
            return "Please write the description of the gift"
        }
    }

    static var priceError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا قیمت کالا را وارد نمایید"
        case .english:
            return "Please write the price of the gift"
        }
    }

    static var addressError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا محل کالا را انتخاب نمایید"
        case .english:
            return "Please select the place of the gift"
        }
    }

    static var giftRemovingPrompt: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "آیا از حدف این هدیه اطمینان دارید؟"
        case .english:
            return "Are you sure that you want to remove the gift?"
        }
    }

    static var phoneNumberIncorrectError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "شماره موبایل صحیح نمی باشد."
        case .english:
            return "The phone number is not correct."
        }
    }
    static var phoneNumberTryAgainError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "شماره تلفن را مجدد وارد کنید"
        case .english:
            return "Please write the number again"
        }
    }

    static var activationCodeError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "لطفا کد فعالسازی را وارد نمایید."
        case .english:
            return "Please write the activation code."
        }
    }

    static var activationCodeIncorrectError: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "کد فعالسازی وارد شده صحیح نمی باشد."
        case .english:
            return "The activation code is not correct."
        }
    }

    static var guideOfSendingActivationCode: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "کد فعالسازی به شماره زیر ارسال می شود. درصورتی که شماره صحیح نیست آن را ویرایش کنید."
        case .english:
            return "The activation code will be sent to the following phone number. If the phone number is not correct, please edit it."
        }
    }

    static var guideOfRegiteringPart1: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "تا لحظاتی دیگر پیامی حاوی کد فعالسازی به شماره "
        case .english:
            return "After few seconds, the message containing activation code will be sent to the phone number "
        }
    }

    static var guideOfRegiteringPart2: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return " ارسال خواهد شد. در صورتیکه کد را دریافت نکردید می توانید پس از ۱ دقیقه مجددا سعی کنید."
        case .english:
            return ". If you didn't receive the message, you can resend the activation code after 1 minutes."
        }
    }

    static var kindnessWallCultureDescription: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "نیاز داری، بردار. نیاز نداری، بذار :)"
        case .english:
            return ""
        }
    }

    static var withDonateCollaborationDescription: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "دونِیت یک پلتفرم جذب سرمایه جمعی ایرانی است که در حال حاضر بر روی تامین سرمایه پروژه‌هایی که تاثیرات اجتماعی دارند، تمرکز کرده است."
        case .english:
            return ""
        }
    }

    static var alwaysFreeDescription: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "برنامه دیوار مهربانی برای همیشه رایگان خواهد ماند."
        case .english:
            return ""
        }
    }

    static var openSourceDescription: String {
        let language = AppLanguage.getLanguage()
        switch language {
        case .persian:
            return "کدهای برنامه همیشه در دسترس برنامه نویسان خواهد بود."
        case .english:
            return ""
        }
    }

}
