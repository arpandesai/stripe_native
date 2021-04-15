package com.plugin.stripe_native;

import android.app.Activity;
import android.app.Dialog;
import android.os.Bundle;
import android.view.Window;
import android.widget.Toast;

public class CustomDialogClass extends Dialog {

    public Activity c;

    public CustomDialogClass(Activity a) {
        super(a, android.R.style.Theme_Translucent);
        this.c = a;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.host_activity);
        Toast.makeText(c, "Init called", Toast.LENGTH_SHORT).show();

    }


}