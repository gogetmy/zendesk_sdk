import Flutter
import UIKit
import SupportSDK
import ZendeskCoreSDK

public class SwiftZendeskSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "zendesk_sdk", binaryMessenger: registrar.messenger())
    let instance = SwiftZendeskSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {

    let arguments = call.arguments as? Dictionary<String, Any>

    switch call.method {
      case "getPlatformVersion":
        result("iOS " + UIDevice.current.systemVersion)

      case "init_sdk":
        let zendeskUrl = (arguments?["zendeskUrl"] ?? "") as? String
        let appId = (arguments?["applicationId"] ?? "") as? String
        let clientId = (arguments?["clientId"] ?? "") as? String

        if appId != nil && clientId != nil && zendeskUrl != nil {
          Zendesk.initialize(appId: appId!, clientId: clientId!, zendeskUrl: zendeskUrl!)
          Support.initialize(withZendesk: Zendesk.instance)
        }

        result("Init sdk successful!")

      case "set_identity":
        let token = arguments?["token"] as? String
        let name = arguments?["name"] as? String
        let email = arguments?["email"] as? String

        let identity: Identity = token != nil ?
          Identity.createJwt(token: token!) :
          Identity.createAnonymous(name: name, email: email)

        Zendesk.instance?.setIdentity(identity)
        result("Set identity successful!")

      case "init_support":
        result("Init support successful!")

      case "request":
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let viewController = RequestUi.buildRequestUi(with: [])
        rootViewController?.navigationBar.barTintColor = UIColor.white
        rootViewController?.pushViewController(viewController, animated: true)

      case "request_list":
        let teal = UIColor(red: 0.0, green: 0.71, blue: 0.68, alpha: 1)
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let config = RequestUiConfiguration()
        let viewController = RequestUi.buildRequestList(with: [config])
        rootViewController?.navigationBar.barTintColor = UIColor.white
        rootViewController?.pushViewController(viewController, animated: true)
        result("Launch request list successful!")

      case "help_center":
        let currentVC = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let hcConfig = HelpCenterUiConfiguration()
        hcConfig.showContactOptions = false
        let helpCenter = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [hcConfig])
        currentVC?.pushViewController(helpCenter, animated: true)
        result("iOS helpCenter UI:" + helpCenter.description + "   ")
      default:
        break
    }
  }
}
