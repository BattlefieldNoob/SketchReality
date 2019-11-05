package com.rexraphael.flutterunitywidgetexample;

import android.os.Bundle;
import io.flutter.app.FlutterApplication;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.PluginRegistry;

public class MyApplication extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback{
    @Override
    public void registerWith(PluginRegistry registry){
        GeneratedPluginRegistrant.registerWith(registry);
    }
}