package com.plugin.stripe_native

import android.app.ProgressDialog
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import android.util.Log
import androidx.activity.ComponentActivity
import androidx.lifecycle.lifecycleScope
import com.google.android.gms.common.api.ApiException
import com.google.android.gms.wallet.*
import com.stripe.android.*
import com.stripe.android.model.ConfirmPaymentIntentParams
import com.stripe.android.model.PaymentMethod
import com.stripe.android.model.PaymentMethodCreateParams
import com.stripe.android.paymentsheet.PaymentSheet
import kotlinx.coroutines.launch
import org.json.JSONArray
import org.json.JSONObject
import java.util.*


class HostActivity : ComponentActivity() {
    var TAG:String=HostActivity::class.java.simpleName
    private lateinit var paymentSession: PaymentSession
    private lateinit var stripe: Stripe
    // Instance of payment client
    private val paymentsClient: PaymentsClient by lazy {
        Wallet.getPaymentsClient(
                this,
                Wallet.WalletOptions.Builder()
                        .setEnvironment(WalletConstants.ENVIRONMENT_TEST)
                        .build()
        )
    }
    val LOAD_PAYMENT_DATA_REQUEST_CODE:Int=53
    private lateinit var publishableKey: String
    private lateinit var clientSecret: String
    private lateinit var paymentDialog: ProgressDialog

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.host_activity)
        actionBar?.hide()
        paymentDialog = ProgressDialog(this)


        publishableKey = intent.getStringExtra("publishableKey")!!
        clientSecret = intent.getStringExtra("clientSecret")!!
        stripe = Stripe(this, publishableKey)
        paymentSession = PaymentSession(
                this,
                createPaymentSessionConfig())
        // Attach your listener
        PaymentConfiguration.init(this,publishableKey)
        paymentSession.init(createPaymentSessionListener())
        paymentSession.presentPaymentMethodSelection()


        /*val googlePayConfig = PaymentSheet.GooglePayConfiguration(
                environment = PaymentSheet.GooglePayConfiguration.Environment.Test,
                countryCode = "US"
        )
        val configuration = PaymentSheet.Configuration(...)
        configuration.googlePay = googlePayConfiguration*/


        isReadyToPay()

    }

    private fun isReadyToPay() {
        paymentsClient.isReadyToPay(createIsReadyToPayRequest())
                .addOnCompleteListener { task ->
                    try {
                        if (task.isSuccessful) {
                            Log.wtf(TAG,"isReadyToPay: if : ${task.isSuccessful}")
                            // show Google Pay as payment option
                        } else {
                            Log.wtf(TAG,"isReadyToPay: Else : ${task.exception}")
                            // hide Google Pay as payment option
                        }
                    } catch (exception: ApiException) {
                    }
                }
    }

    /**
     * See https://developers.google.com/pay/api/android/reference/request-objects#example
     * for an example of the generated JSON.
     */
    private fun createIsReadyToPayRequest(): IsReadyToPayRequest {
        return IsReadyToPayRequest.fromJson(
                JSONObject()
                        .put("apiVersion", 2)
                        .put("apiVersionMinor", 0)
                        .put("allowedPaymentMethods",
                                JSONArray().put(JSONObject()
                                        .put("type", "CARD")
                                        .put("parameters",
                                                JSONObject().put("allowedAuthMethods", JSONArray()
                                                        .put("PAN_ONLY")
                                                        .put("CRYPTOGRAM_3DS")).put("allowedCardNetworks", JSONArray()
                                                        .put("AMEX")
                                                        .put("DISCOVER")
                                                        .put("MASTERCARD")
                                                        .put("VISA"))))).toString()
        )
    }

    private fun createPaymentSessionListener(): PaymentSession.PaymentSessionListener {
        return object : PaymentSession.PaymentSessionListener {
            override fun onCommunicatingStateChanged(isCommunicating: Boolean) {
                Log.e("onCommunicatingState-->", isCommunicating.toString())
                if (isCommunicating)
                // update UI to indicate that network communication is in progress
                    showPaymentDialog()
                else
                // update UI to indicate that network communication has completed
                    hidePaymentDialog()

            }

            override fun onError(errorCode: Int, errorMessage: String) {
                Log.e("onError-->", errorMessage)
            }

            override fun onPaymentSessionDataChanged(data: PaymentSessionData) {

                Log.e("onPayment-->", "PaymentInfo: $data : ${data.isPaymentReadyToCharge} : ${data.paymentMethod?.id} : $clientSecret")
                if (data.useGooglePay) {

                    Log.e(TAG,"Payment method: Use Google Pay Call")

                    AutoResolveHelper.resolveTask(
                    paymentsClient.loadPaymentData(createPaymentDataRequest()),this@HostActivity,LOAD_PAYMENT_DATA_REQUEST_CODE)


                    // customer intends to pay with Google Pay
                } else {
                    Log.e(TAG,"Payment method: Else Call")
                    data.paymentMethod?.let { paymentMethod ->
                    }
                }
                /*if (data.isPaymentReadyToCharge) {
                    val paymentIntent = ConfirmPaymentIntentParams.createWithPaymentMethodId(data.paymentMethod?.id!!, clientSecret)
                     stripe.confirmPayment(this@HostActivity, paymentIntent)   //use payment intent
                    Log.e("isPaymentReady--> ", data.toString())
                } else {
                    Log.e("onPaymentSession--> ", data.toString())
                }*/

            }
        }
    }

    private fun createPaymentSessionConfig(): PaymentSessionConfig {
        return PaymentSessionConfig.Builder().setShippingInfoRequired(false)
                .setShippingMethodsRequired(false)
//                .setShouldShowGooglePay(true)
                // specify the payment method types that the customer can use;
                // defaults to PaymentMethod.Type.Card
                .setPaymentMethodTypes(listOf(PaymentMethod.Type.Card))
                .setShouldShowGooglePay(true)
                .build()
    }


    private fun createPaymentDataRequest(): PaymentDataRequest {
        val tokenizationSpec: JSONObject = GooglePayConfig(this).tokenizationSpecification
        val cardPaymentMethod: JSONObject = JSONObject()
                .put("type", "CARD")
                .put(
                        "parameters",
                        JSONObject()
                                .put("allowedAuthMethods", JSONArray()
                                        .put("PAN_ONLY")
                                        .put("CRYPTOGRAM_3DS"))
                                .put("allowedCardNetworks",
                                        JSONArray()
                                                .put("AMEX")
                                                .put("DISCOVER")
                                                .put("MASTERCARD")
                                                .put("VISA")) // require billing address
                                .put("billingAddressRequired", true)
                                .put(
                                        "billingAddressParameters",
                                        JSONObject() // require full billing address
                                                .put("format", "MIN") // require phone number
                                                .put("phoneNumberRequired", true)
                                )
                )
                .put("tokenizationSpecification", tokenizationSpec)

        // create PaymentDataRequest

        val paymentDataRequest: String = JSONObject()
                .put("apiVersion", 2)
                .put("apiVersionMinor", 0)
                .put("allowedPaymentMethods",
                        JSONArray().put(cardPaymentMethod))
                .put("transactionInfo", JSONObject()
                        .put("totalPrice", "10.00")
                        .put("totalPriceStatus", "FINAL")
                        .put("currencyCode", "USD")
                )
                .put("merchantInfo", JSONObject()
                        .put("merchantName", "Example Merchant")) // require email address
                .put("emailRequired", true)
                .toString()
        return PaymentDataRequest.fromJson(paymentDataRequest)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        /// check if user click on cancel or back button then we should not start the payment processing
          if (data != null&&resultCode==-1) {
              showPaymentDialog();
            paymentSession.handlePaymentData(requestCode, resultCode, data)
            stripe.onPaymentResult(requestCode, data, object : ApiResultCallback<PaymentIntentResult> {
                override fun onError(e: Exception) {
                    hidePaymentDialog();

                    Log.d("onError --> ", e.localizedMessage)

                    StripeNativePlugin.resultInterface.success("Payment Error:"+e.localizedMessage)
                    this@HostActivity.finish()
                }

                override fun onSuccess(result: PaymentIntentResult) {
                    hidePaymentDialog();
                    Log.d("onSuccess --> ", result.toString())

                    StripeNativePlugin.resultInterface.success("Payment Success:$result");
                    this@HostActivity.finish()
                }

            })
        }else{
              StripeNativePlugin.resultInterface.error("payment_cancelled_by_user","User pressed back or Please try again later",null);
            this@HostActivity.finish()
        }
    }

    /*private fun onGooglePayResult(data: Intent) {
        val paymentData = PaymentData.getFromIntent(data) ?: return
        val paymentMethodCreateParams =
                PaymentMethodCreateParams.createFromGooglePay(
                        JSONObject(paymentData.toJson())
                )

        // now use the `paymentMethodCreateParams` object to create a PaymentMethod
        lifecycleScope.launch {
            runCatching {

                stripe.createPaymentMethod(paymentMethodCreateParams)
            }.fold(
                    onSuccess = { result ->
                        // See https://stripe.com/docs/payments/accept-a-payment?platform=android#android-create-payment-intent
                        // for how to create a PaymentIntent on your backend and use its client secret
                        // to confirm the payment on the client.
                        val confirmParams = ConfirmPaymentIntentParams
                                .createWithPaymentMethodId(
                                        paymentMethodId = result.toString(),
                                        clientSecret = "{{PAYMENT_INTENT_CLIENT_SECRET}}"
                                )
                        stripe.confirmPayment(
                                this@HostActivity,
                                confirmPaymentIntentParams = confirmParams
                        )
                    },
                    onFailure = {
                    }
            )
        }
    }*/

    //    ///class utils methods
    private fun hidePaymentDialog() {
        if (paymentDialog.isShowing)
            paymentDialog.dismiss();


    }

    private fun showPaymentDialog() {
        paymentDialog.setTitle("payment is processing")
        paymentDialog.show()
    }

    override fun onBackPressed() {
        finish();
    }

    override fun onDestroy() {
        hidePaymentDialog()
        super.onDestroy()
    
    }


}