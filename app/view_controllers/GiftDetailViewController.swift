//
//  GiftDetailViewController.swift
//  app
//
//  Created by Hamed.Gh on 12/1/17.
//  Copyright © 2017 Hamed.Gh. All rights reserved.
//

import UIKit
import ImageSlideshow

class GiftDetailViewController: UIViewController {

    var gift:Gift?
    var sdWebImageSource:[SDWebImageSource] = []
    var profileImages:[String] = []

    @IBOutlet var giftName: UILabel!
    @IBOutlet var slideshow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        giftName.text = gift?.title
        
        createSlideShow()
        
        guard let id = gift?.id else {
            return
        }
        
        ApiMethods.getGift(giftId: id) { (data) in
            
        }
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    func createSlideShow() {
        
        guard let images = gift?.giftImages
            else {
            return
        }
        // Do any additional setup after loading the view.
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 5.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.lightGray
        slideshow.pageControl.pageIndicatorTintColor = UIColor.black
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        
        
        for img in images {
            self.sdWebImageSource.append(
                SDWebImageSource(urlString: img)!
            )
        }
        
        self.slideshow.setImageInputs(self.sdWebImageSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(GiftDetailViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
        
    }
}
