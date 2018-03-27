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
    
    init(completionHandler:(()->Void)?) {
        super.init()
        getCities(completionHandler: completionHandler)
    }
    
    init(cityId:Int,completionHandler:(()->Void)?) {
        super.init()
        getRegions(container_id: cityId, completionHandler: completionHandler)
    }
    
    func getCities(completionHandler:(()->Void)?) {
        let container_id=0
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
    
    func getRegions(container_id:Int,completionHandler:(()->Void)?) {
        
        APIRequest.requestTestJson(name: "latest") { (data) in
            if let jsonPlaces=APIRequest.readJsonData(data: data, outputType: PlaceResponse.self)?.places {
                
                for place in jsonPlaces {
                    self.rawPlaces.append(place)
                }
                
                let regions=self.getAllRegions(container_id: container_id)
                self.places.append(contentsOf: regions)
                completionHandler?()
            }
        }
        
    }
    
    func getAllRegions(container_id:Int)->[Place]{
        
        var partitions=[Place]()
        for place in rawPlaces {
            if place.container_id==container_id {
                partitions.append(place)
            }
        }
        var regions=[Place]()
        for partition in partitions {
            for place in rawPlaces {
                if place.container_id==partition.id {
                    regions.append(place)
                }
            }
        }
        
        return regions
    }
    
    func hasAnyRegion(container_id:Int)->Bool{
        let regions=self.getAllRegions(container_id: container_id)
        if regions.count>0 {
            return true
        } else {
            return false
        }
    }
    
    func setCell(cell:GenericOptionsTableViewCell,indexPath:IndexPath) {
        cell.setValue(name: places[indexPath.row].name)
    }
    func returnCellData(indexPath:IndexPath)->Place {
        return places[indexPath.row]
    }
    
    
}
