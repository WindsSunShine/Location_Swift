//
//  ViewController.swift
//  location_Swift
//
//  Created by 张建军 on 16/9/12.
//  Copyright © 2016年 张建军. All rights reserved.
//

import UIKit
import CoreLocation
class ViewController: UIViewController, CLLocationManagerDelegate {

    let locationLable = UILabel()
    var locationButton = UIButton()
    
    var stopLocation = UIButton()
    
    // 创建位置管理器（定位用户的位置）
    let locationManager:CLLocationManager = CLLocationManager()
    let SCREEN_WIDTH = UIScreen.mainScreen().bounds.size.width
    let SCREEN_HEIGHT = UIScreen.mainScreen().bounds.size.height
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
      
      self.view.backgroundColor = UIColor.blueColor()
      self.CreatLablendButton()
   
    }
    
 
    
    
    func CreatLablendButton() {
    
        
        locationLable.frame = CGRectMake(20, 64, SCREEN_WIDTH -  40, 50)
        
        locationLable.textColor =  UIColor.yellowColor()
        
        self.view.addSubview(locationLable)
        
        
        locationButton =  UIButton.init(type: .Custom)
        locationButton.frame = CGRectMake(20, SCREEN_HEIGHT * 0.7, SCREEN_WIDTH - 40, 50)
        locationButton.addTarget(self, action: #selector(ViewController.myLocationButtonDidTouch), forControlEvents: .TouchUpInside)
        locationButton.setTitle("开始定位", forState: .Normal)
        locationButton.backgroundColor = UIColor.blackColor()
        self.view.addSubview(locationButton)
        
        stopLocation = UIButton.init(type:.Custom)
        stopLocation.frame = CGRectMake(20, SCREEN_HEIGHT * 0.7 + 60, SCREEN_WIDTH - 40, 30)
        
        stopLocation.addTarget(self, action: #selector(ViewController.stopLocationDidTouch), forControlEvents: .TouchUpInside)
        
        stopLocation.setTitle("停止定位", forState: .Normal)
        
        stopLocation.backgroundColor = UIColor.redColor()
        
        self.view.addSubview(stopLocation)
        
        
        
    }

    
    // 点击按钮触发
    func myLocationButtonDidTouch() {
        
        // 设置代理
       locationManager.delegate = self
     // 设置定位的精度
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        locationManager.requestAlwaysAuthorization()
        // 判断是否允许定位
        if (CLLocationManager.locationServicesEnabled()) {
            
            // 开启定位服务
            locationManager.startUpdatingLocation()
            //每个多少米定位一次（这里设置为任何的移动都会触发定位功能）locationManager.distanceFilter =1000.0f;
            locationManager.distanceFilter = kCLDistanceFilterNone
            
            
            print("定位开始")
            
        }else {
            
            print("不能定位用户的位置")
            
        }
        
        
    }
    
    
    // 关闭定位的方法
    
    
    func stopLocationDidTouch() {
        
        
        locationManager.stopUpdatingLocation()
        
        
    }
    
    
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        
        locationLable.text = "Error while updating location "  + error.localizedDescription
    
    }
    
     // 当调用了startUpdatingLocation 就不断获取用户的位置，会频繁的调用下面的方法
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
        
        //地理反编码
        CLGeocoder().reverseGeocodeLocation(manager.location!,completionHandler: { (placemarks, error) ->Void in
            if(error != nil){
                self.locationLable.text = "Reverse geocoder failed with error" + error!.localizedDescription
                return
            }
            if placemarks!.count > 0{
                let pm = placemarks![0]
                self.displayLocationInfo(pm)
                
            }else{
                self.locationLable.text = "Problem with the data received from geocoder"
            }
        })
    }
    
    //解析位置
    func displayLocationInfo(placemark: CLPlacemark?) {
        
        //CLPlacemark 坐标 封装详细的地理信息
        
        if let containsPlacemark = placemark {
            locationManager.stopUpdatingLocation()
            // 获取城市信息
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            
            // 邮政编码
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            
            // 省会
            let administrativeArea = (containsPlacemark.administrativeArea != nil) ? containsPlacemark.administrativeArea : ""
            
            // 国家
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""

            // 返回地址
            self.locationLable.text = locality! +  postalCode! +  administrativeArea! +  country!
        }
        
    }
    
    
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

