//
//  AppDelegate.swift
//  Flickr
//
//  Created by Дмитрий Вашлаев on 14.10.18.
//  Copyright © 2018 Дмитрий Вашлаев. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let flickrAPI = Flickr()
//        flickrAPI.camerasGetBrandModels(brand: "Apple") { [weak self] (camerasData) in
//            do {
//                guard let weakSelf = self else { return }
//                guard let data = camerasData else { return }
//                // Parsing JSON
//                let result = try JSONDecoder().decode(CamerasGetBrandModelsResponse.self, from: data)
//
//                if let cameras = result.cameras, let camerasList = cameras.camera {
//                    for item in camerasList {
//
//                    }
////                    completionHandler(goods)
////
////                    if page == 0 {
////                        weakSelf.offset = goods.count
////                        if goods.count > 0 {
////                            weakSelf.lastPage = total / weakSelf.offset + 1
////                        }
////                    }
//                }
//
//            } catch let jsonErr {
//                print("JSON serialization error:", jsonErr)
//            }
//        }
        
        flickrAPI.interestingnessGetList(page: 1) { [weak self] (interestingness) in
            do {
                guard let weakSelf = self else { return }
                guard let data = interestingness else { return }
                // Parsing JSON
                let result = try JSONDecoder().decode(InterestingnessResponse.self, from: data)
                
                if let photos = result.photos, let photosList = photos.photo {
                    for item in photosList {
                        
                    }
                    //                    completionHandler(goods)
                    //
                    //                    if page == 0 {
                    //                        weakSelf.offset = goods.count
                    //                        if goods.count > 0 {
                    //                            weakSelf.lastPage = total / weakSelf.offset + 1
                    //                        }
                    //                    }
                }
                
            } catch let jsonErr {
                print("JSON serialization error:", jsonErr)
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

