package com.sp.colorrain;

import sp.SpActivity;
import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import java.lang.System;

public class SpProjectPrototypeActivity extends SpActivity
{

    public boolean finishRenderingQML = false;
    Context context;

    //--------------------------------------------------------------------------
    @Override
    public void onCreate(Bundle savedInstanceState) {
        context = this.getApplicationContext();
        super.onCreate(savedInstanceState);
        logInfo("onCreate");
    }

    //--------------------------------------------------------------------------
    @Override
    public void onDestroy() {
        logInfo("onDestroy");
        super.onDestroy();
    }

    //--------------------------------------------------------------------------
    @Override
    public void onStop() {
        logInfo("onStop");
        super.onStop();
    }

    //--------------------------------------------------------------------------
    @Override
    public void onStart() {
        logInfo("onStart");
        super.onStart();
    }

    //--------------------------------------------------------------------------
    @Override
    protected void onResume() {
        logInfo("onResume");
        super.onResume();
    }

    //--------------------------------------------------------------------------
    @Override
    protected void onPause() {
        logInfo("onPause Activity finishRenderingQML = " + this.finishRenderingQML);
        if (!this.finishRenderingQML) {
            logInfo("завершаем приложение в onPause");
            System.exit(0);
        }

        super.onPause();
    }

    public void finishSplash() {
        this.finishRenderingQML = true;
        SplashActivity.splashScreen.finish();
    }

    public static native void logInfo(String text);
    public static native void logError(String text);
}

