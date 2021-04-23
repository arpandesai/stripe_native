package com.plugin.stripe_native

import android.app.Activity
import android.app.AlertDialog
import android.app.ProgressDialog
import android.content.Intent
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.Toast
import androidx.activity.ComponentActivity
import com.stripe.android.*
import com.stripe.android.model.ConfirmPaymentIntentParams
import com.stripe.android.model.PaymentIntent
import com.stripe.android.model.PaymentMethod
import com.stripe.android.model.ShippingInformation
import java.util.*
import java.util.Arrays.asList

class HostActivity : ComponentActivity() {
    private lateinit var paymentSession: PaymentSession
    private lateinit var stripe: Stripe
    private lateinit var publishableKey: String
    private lateinit var clientSecret: String
    private lateinit var paymentDialog: ProgressDialog

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.host_activity)
        actionBar?.hide();
        paymentDialog = ProgressDialog(this);


        publishableKey = intent.getStringExtra("publishableKey")!!
        clientSecret = intent.getStringExtra("clientSecret")!!

        stripe = Stripe(this, publishableKey)
        paymentSession = PaymentSession(
                this,
                createPaymentSessionConfig())
        // Attach your listener
        paymentSession.init(createPaymentSessionListener())
        paymentSession.presentPaymentMethodSelection()

    }


    private fun createPaymentSessionListener(): PaymentSession.PaymentSessionListener {
        return object : PaymentSession.PaymentSessionListener {
            override fun onCommunicatingStateChanged(isCommunicating: Boolean) {
                Log.e("onCommunicatingState-->", isCommunicating.toString())
                if (isCommunicating)
                // update UI to indicate that network communication is in progress
                    showPaymentDialog();
                else
                // update UI to indicate that network communication has completed
                    hidePaymentDialog();

            }

            override fun onError(errorCode: Int, errorMessage: String) {
                Log.e("onError-->", errorMessage)
            }

            override fun onPaymentSessionDataChanged(data: PaymentSessionData) {

                Log.e("onPayment-->", data.toString())
                if (data.useGooglePay) {
                    // customer intends to pay with Google Pay
                } else {
                    data.paymentMethod?.let { paymentMethod ->
                    }
                }
                 if (data.isPaymentReadyToCharge) {
                    val paymentIntent = ConfirmPaymentIntentParams.createWithPaymentMethodId(data.paymentMethod?.id!!, clientSecret)
                    stripe.confirmPayment(this@HostActivity, paymentIntent)   //use payment intent
                    Log.e("isPaymentReady--> ", data.toString())
                } else {
                    Log.e("onPaymentSession--> ", data.toString())
                }

            }
        }
    }

    private fun createPaymentSessionConfig(): PaymentSessionConfig {
        return PaymentSessionConfig.Builder().setShippingInfoRequired(false)
                .setShippingMethodsRequired(false)
//                .setShouldShowGooglePay(true)
                // specify the payment method types that the customer can use;
                // defaults to PaymentMethod.Type.Card
                .setPaymentMethodTypes(Arrays.asList(PaymentMethod.Type.Card))
                .build()
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
//                    Toast.makeText(this@HostActivity, "onError +${e.localizedMessage}", Toast.LENGTH_LONG).show();
//                    Toast.makeText(this@HostActivity, "onError +${e.message}", Toast.LENGTH_LONG).show();

                    Log.d("onError --> ", e.localizedMessage)

                    StripeNativePlugin.resultInterface.success(e.localizedMessage)
                    this@HostActivity.finish()
                }

                override fun onSuccess(result: PaymentIntentResult) {
                    hidePaymentDialog();
                    Log.d("onSuccess --> ", result.toString())
                    StripeNativePlugin.resultInterface.success(result.toString());
                    this@HostActivity.finish()
                }

            })
        }else{
              StripeNativePlugin.resultInterface.error("payment_cancelled_by_user","User pressed back",null);
            this@HostActivity.finish()
        }
    }

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