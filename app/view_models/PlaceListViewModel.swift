//
//  PlaceListViewModel.swift
//  app
//
//  Created by AmirHossein on 2/16/18.
//  Copyright © 2018 Hamed.Gh. All rights reserved.
//

import UIKit

class PlaceListViewModel: NSObject {

    var places=[Place]()
    
    var rawPlaces=[Place]()
    
    init(container_id:Int,completionHandler:(()->Void)?) {
        super.init()
        getPlaces(container_id: container_id, completionHandler: completionHandler)
    }
    
    func getPlaces(container_id:Int,completionHandler:(()->Void)?) {
        
        APIRequest.requestTestJson(name: "latest") { (data) in
            if let jsonPlaces=APIRequest.readJsonData(data: data, outputType: PlaceResponse.self)?.places {
                for place in jsonPlaces {
                    self.rawPlaces.append(place)
                    if place.container_id==container_id {
                        self.places.append(place)
                        completionHandler?()
                    }
                }
            }
        }
        
    }
    
    
    func setCell(cell:GenericOptionsTableViewCell,indexPath:IndexPath) {
        cell.setValue(name: places[indexPath.row].name)
    }
    func returnCellData(indexPath:IndexPath)->Place {
        return places[indexPath.row]
    }
    
    func hasNestedOption(container_id:Int)->Bool{
        for place in rawPlaces {
            if place.container_id==container_id {
                return true
            }
        }
        return false
    }
    
}
