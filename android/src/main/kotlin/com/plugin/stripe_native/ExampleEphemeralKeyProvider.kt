package com.plugin.stripe_native
import androidx.annotation.Size
import com.stripe.android.EphemeralKeyProvider
import com.stripe.android.EphemeralKeyUpdateListener
import java.io.IOException


class ExampleEphemeralKeyProvider() : EphemeralKeyProvider {
    override fun createEphemeralKey(@Size(min=4) apiVersion: String, keyUpdateListener: EphemeralKeyUpdateListener) {

        val json = "{\n" +
                "    \"id\": \"ephkey_1IdwdzHXAQctbbyazvJ2tEB6\",\n" +
                "    \"object\": \"ephemeral_key\",\n" +
                "    \"associated_objects\": [\n" +
                "        {\n" +
                "            \"type\": \"customer\",\n" +
                "            \"id\": \"cus_JGRXAUJIFYFqX6\"\n" +
                "        }\n" +
                "    ],\n" +
                "    \"created\": 1617883651,\n" +
                "    \"expires\": 1617887251,\n" +
                "    \"livemode\": false,\n" +
                "    \"secret\": \"ek_test_YWNjdF8xQjdOaklIWEFRY3RiYnlhLDVqREtGOEs3OGxReEdzbkFCTkR4dFVDUXVGR3Z4elc_00jSZpXNEN\"\n" +
                "}"

        try {

            keyUpdateListener.onKeyUpdate(json);
        } catch (e: IOException) {
            keyUpdateListener
                    .onKeyUpdateFailure(0, e.message ?: "")
        }
    }

}