import UIKit
import Flutter
import CommonUISDK

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Override currentTheme color
    let teal = UIColor(red: 0.0, green: 0.71, blue: 0.68, alpha: 1)
    CommonTheme.currentTheme.primaryColor = teal

    GeneratedPluginRegistrant.register(with: self)

    //https://stackoverflow.com/questions/45645866/how-can-i-push-a-uiviewcontroller-from-flutterviewcontroller
    let flutterViewController: FlutterViewController = window?.rootViewController as! FlutterViewController
    let navigationController = UINavigationController(rootViewController: flutterViewController)

    if #available(iOS 13.0, *) {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = .white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.black]

        UINavigationBar.appearance().tintColor = UIColor.black
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.compactAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
    } else {
        navigationController.navigationBar.barTintColor = UIColor.white
    }

    navigationController.isNavigationBarHidden = true
    window?.rootViewController = navigationController
    window?.makeKeyAndVisible()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
