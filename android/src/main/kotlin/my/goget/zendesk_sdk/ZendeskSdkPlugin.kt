package my.goget.zendesk_sdk

import android.app.Activity
import androidx.annotation.NonNull

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import zendesk.configurations.Configuration
import zendesk.core.AnonymousIdentity
import zendesk.core.Identity
import zendesk.core.JwtIdentity
import zendesk.core.Zendesk
import zendesk.support.Support
import zendesk.support.guide.HelpCenterActivity
import zendesk.support.request.RequestActivity
import zendesk.support.requestlist.RequestListActivity

/** ZendeskSdkPlugin */
class ZendeskSdkPlugin : ActivityAware, FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var activity: Activity

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "zendesk_sdk")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {

        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "init_sdk" -> {
                val zendeskUrl = call.argument<String>("zendeskUrl")!!
                val applicationId = call.argument<String>("applicationId")!!
                val clientId = call.argument<String>("clientId")!!

                Zendesk.INSTANCE.init(activity,
                        zendeskUrl,
                        applicationId,
                        clientId)
                result.success("Init sdk successful!")
            }
            "set_identity" -> {
                val token = call.argument<String>("token")
                val name = call.argument<String>("name")
                val email = call.argument<String>("email")

                val identity: Identity =
                        if (token != null) {
                            JwtIdentity(token)
                        } else {
                            val builder = AnonymousIdentity.Builder()
                            if (name != null) builder.withNameIdentifier(name)
                            if (email != null) builder.withEmailIdentifier(email)
                            builder.build()
                        }
                Zendesk.INSTANCE.setIdentity(identity)
                result.success("Set identity successful!")
            }
            "init_support" -> {
                Support.INSTANCE.init(Zendesk.INSTANCE)
                result.success("Init support successful!")
            }
            "request" -> {
                RequestActivity.builder()
                        .show(activity);
                result.success("Launch request successful!")
            }
            "request_with_id" -> {
                val requestId = call.argument<String>("requestId")!!

                RequestActivity.builder()
                        .withRequestId(requestId)
                        .show(activity);
                result.success("Launch request successful!")
            }
            "request_list" -> {
                RequestListActivity.builder()
                        .show(activity);
                result.success("Launch request list successful!")
            }
            "help_center" -> {
                val articlesForCategoryIds = call.argument<List<Long>>("articlesForCategoryIds") ?: mutableListOf()
                val categoriesCollapsed = call.argument<Boolean>("categoriesCollapsed") ?: false
                val contactUsButtonVisible = call.argument<Boolean>("contactUsButtonVisible")
                        ?: true
                val showConversationsMenuButton = call.argument<Boolean>("showConversationsMenuButton")
                        ?: true
                val helpCenterConfig: Configuration = HelpCenterActivity.builder()
                        .withArticlesForCategoryIds(articlesForCategoryIds) //201732367L
                        .withCategoriesCollapsed(categoriesCollapsed)
                        .withContactUsButtonVisible(contactUsButtonVisible)
                        .withShowConversationsMenuButton(showConversationsMenuButton)
                        .config()
                HelpCenterActivity.builder()
                        .show(activity, helpCenterConfig)
                result.success("Launch request list successful!")
            }
            "changeNavigationBarVisibility" -> {
                // Not implemented for Android
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }
}
