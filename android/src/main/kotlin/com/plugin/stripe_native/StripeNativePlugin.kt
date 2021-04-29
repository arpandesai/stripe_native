package com.plugin.stripe_native

import android.app.Activity
import android.app.ProgressDialog
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.os.PersistableBundle
import android.util.Log
import android.widget.Toast
import androidx.activity.ComponentActivity

import androidx.annotation.NonNull
import androidx.core.view.KeyEventDispatcher
import com.stripe.android.*
import com.stripe.android.model.ConfirmPaymentIntentParams
import com.stripe.android.model.PaymentMethod

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import java.io.IOException
import java.util.*
import kotlin.collections.HashMap

/** StripeNativePlugin */
class StripeNativePlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private lateinit var activity: Activity
    private lateinit var publishableKey: String
    private lateinit var clientSecret: String
    
    companion object {
        @JvmStatic lateinit var resultInterface:Result
    }
    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {

        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "stripe_native")
        channel.setMethodCallHandler(this)
        context = flutterPluginBinding.applicationContext

    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        resultInterface=result
        
        when (call.method) {
            "lunch_stripe" -> {
                startStripeFlow(result, call.arguments());
            }
            else -> {
                result.notImplemented()
            }
        }
    }


    private fun startStripeFlow(result: Result, arguments: HashMap<String, Any>) {
        clientSecret = arguments["clientSecret"].toString()
        publishableKey = arguments["publishableKey"].toString()
        val ephemeralResponse: String = arguments["ephemeralKey"].toString()

        if (clientSecret.isEmpty()) {
            result.error("client_key_not_found", "Please provide client secret key", null)
        }
        //Getting all the info form flutter
        try {
            PaymentConfiguration.init(context, publishableKey)
            CustomerSession.initCustomerSession(context, object : EphemeralKeyProvider {
                override fun createEphemeralKey(apiVersion: String, keyUpdateListener: EphemeralKeyUpdateListener) {
                    try {
                        keyUpdateListener.onKeyUpdate(ephemeralResponse);
                    } catch (e: IOException) {
                        keyUpdateListener
                                .onKeyUpdateFailure(0, e.message ?: "")
                    }
                }
            })
        } catch (e: Exception) {
            result.error(e.cause.toString(), e.localizedMessage.toString(), e.stackTrace);

        }
        val intent = Intent(context, HostActivity::class.java)
        intent.putExtra("publishableKey", publishableKey)
        intent.putExtra("clientSecret", clientSecret)
        intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
        context.startActivity(intent)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onDetachedFromActivity() {

    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {

    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity

    }

    override fun onDetachedFromActivityForConfigChanges() {

    }


}
