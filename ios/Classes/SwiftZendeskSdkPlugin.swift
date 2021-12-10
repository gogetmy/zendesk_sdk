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

      case "request_with_id":
        let requestId = arguments?["requestId"] as? String ?? ""

        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let viewController = RequestUi.buildRequestUi(requestId: requestId)

        rootViewController?.navigationBar.barTintColor = UIColor.white
        rootViewController?.pushViewController(viewController, animated: true)
        result("Launch request with id successful!")

      case "request_list":
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let config = RequestUiConfiguration()
        let viewController = RequestUi.buildRequestList(with: [config])

        rootViewController?.navigationBar.barTintColor = UIColor.white
        rootViewController?.pushViewController(viewController, animated: true)
        result("Launch request list successful!")

      case "help_center":
        // TODO: handle retrieving dynamic list of articles category ids
        //let articlesForCategoryIds = arguments?["articlesForCategoryIds"] as? Array<NSNumber> ?? []
        let categoriesCollapsed = arguments?["categoriesCollapsed"] as? Bool ?? false
        let contactUsButtonVisible = arguments?["contactUsButtonVisible"] as? Bool ?? true
        let showConversationsMenuButton = arguments?["showConversationsMenuButton"] as? Bool ?? true

        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let hcConfig = HelpCenterUiConfiguration()
        hcConfig.showContactOptions = contactUsButtonVisible

        // Filter articles by category ids
        hcConfig.groupType = .category
        // TODO: handle retrieving dynamic list of articles
        hcConfig.groupIds = [201732367]

        let helpCenter = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [hcConfig])

        rootViewController?.pushViewController(helpCenter, animated: true)
        result("iOS helpCenter UI:" + helpCenter.description + "   ")

      case "help_center_with_section_ids":
        // TODO: handle retrieving dynamic list of articles section ids
        //let articlesForSectionIds = arguments?["articlesForSectionIds"] as? Array<NSNumber> ?? []
        let sectionName = arguments?["sectionName"] as? String ?? ""
        let categoriesCollapsed = arguments?["categoriesCollapsed"] as? Bool ?? false
        let contactUsButtonVisible = arguments?["contactUsButtonVisible"] as? Bool ?? true
        let showConversationsMenuButton = arguments?["showConversationsMenuButton"] as? Bool ?? true

        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let hcConfig = HelpCenterUiConfiguration()
        hcConfig.showContactOptions = contactUsButtonVisible

        // Filter articles by section ids
        hcConfig.groupType = .section
        // TODO: handle retrieving dynamic list of articles
        if (!sectionName.isEmpty) {
            switch sectionName {
                case "referral":
                    hcConfig.groupIds = [900000126563]
                case "insurance":
                    hcConfig.groupIds = [900000170586]
                default :
                    hcConfig.groupIds
            }
        }


        let helpCenter = HelpCenterUi.buildHelpCenterOverviewUi(withConfigs: [hcConfig])

        rootViewController?.pushViewController(helpCenter, animated: true)
        result("iOS helpCenter UI:" + helpCenter.description + "   ")

      case "article_with_id":
        let articleId = arguments?["articleId"] as? String ?? ""

        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        let viewController = HelpCenterUi.buildHelpCenterArticleUi(withArticleId: articleId, andConfigs: [])

        rootViewController?.navigationBar.barTintColor = UIColor.white
        rootViewController?.pushViewController(viewController, animated: true)
        result("Launch article with id successful!")

      case "changeNavigationBarVisibility":
        let rootViewController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController
        guard let dic = call.arguments as? Dictionary<String, Any> else { return }

        let isVisible = dic["isVisible"] as? Bool ?? false
        rootViewController?.setNavigationBarHidden(!isVisible, animated: false)
        result("rootViewController?.isNavigationBarHidden = isVisible >>>>>")

      default:
        break
    }
  }
}
