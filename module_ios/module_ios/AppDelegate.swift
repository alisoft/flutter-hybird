//
//  AppDelegate.swift
//  module_ios
//
//  Created by Ying Wang on 2022/3/23.
//

import UIKit
import Flutter
import FlutterPluginRegistrant

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var engine : FlutterEngine?
    var project: FlutterDartProject?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.project = FlutterDartProject.init()
        self.engine = FlutterEngine(name: "io.flutter", project: self.project)
        self.engine?.run(withEntrypoint: nil)
        GeneratedPluginRegistrant.register(with: self.engine!)
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        let flutterVC = FlutterViewController(engine: self.engine!, nibName: nil, bundle: nil)
        self.window?.rootViewController = flutterVC
        self.window?.makeKeyAndVisible()
        return true
    }


}

