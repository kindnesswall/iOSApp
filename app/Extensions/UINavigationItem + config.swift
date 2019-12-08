//
//  UINavigationItem + config.swift
//  app
//
//  Created by AmirHossein on 3/22/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

extension UINavigationItem {

    static func getNavigationItem(target: AnyObject, action: Selector?, text: String, font: UIFont=AppFont.get(.iranSansRegular, size: 14), color: UIColor=AppColor.Tint) -> UIBarButtonItem {

        let btn = UIBarButtonItem()

        btn.target=target
        btn.action=action

        btn.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color], for: .normal)
        btn.setTitleTextAttributes([NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: color], for: .highlighted)

        btn.title=text

        return btn

    }

    static func getBackNavigationItem(target: AnyObject, action: Selector?, color: UIColor=AppColor.Tint) -> UIBarButtonItem {
        let backBtn=UINavigationItem.getNavigationItem(target: target, action: action, text: "\u{e946}", font: AppFont.get(.icomoon, size: 25), color: color)
        return backBtn
    }

    static func getCloseNavigationItem(target: AnyObject, action: Selector?, color: UIColor=AppColor.Tint) -> UIBarButtonItem {
        let closeBtn=UINavigationItem.getNavigationItem(target: target, action: action, text: "\u{e900}", font: AppFont.get(.icomoon, size: 25), color: color)
        return closeBtn
    }

    func setRightBtn(target: AnyObject, action: Selector?, text: String, font: UIFont=AppFont.get(.iranSansRegular, size: 14), color: UIColor=AppColor.Tint) {

        let btn=UINavigationItem.getNavigationItem(target: target, action: action, text: text, font: font, color: color)

        self.rightBarButtonItems=[btn]
    }

    func setLeftBtn(target: AnyObject, action: Selector?, text: String, font: UIFont=AppFont.get(.iranSansRegular, size: 14), color: UIColor=AppColor.Tint) {

        let btn=UINavigationItem.getNavigationItem(target: target, action: action, text: text, font: font, color: color)

        self.leftBarButtonItems=[btn]
    }

    func removeDefaultBackBtn() {
        let btn=UIBarButtonItem()
        btn.title=""
        self.leftBarButtonItems=[btn]
    }

}
