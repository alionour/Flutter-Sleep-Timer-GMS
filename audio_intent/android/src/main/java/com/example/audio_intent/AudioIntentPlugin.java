package com.example.audio_intent;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.ContextWrapper;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.BatteryManager;
import android.os.Build.VERSION;
import android.os.Build.VERSION_CODES;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.EventChannel.StreamHandler;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.media.AudioManager;
import android.view.View.OnFocusChangeListener;

/** BatteryPlugin */
public class AudioIntentPlugin implements MethodCallHandler, StreamHandler, FlutterPlugin {

  private Context applicationContext;
  private BroadcastReceiver chargingStateChangeReceiver;
  private MethodChannel methodChannel;
  private EventChannel eventChannel;

  /** Plugin registration. */
  @SuppressWarnings("deprecation")
  public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
    final AudioIntentPlugin instance = new AudioIntentPlugin();
    instance.onAttachedToEngine(registrar.context(), registrar.messenger());
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
  }

  private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
    this.applicationContext = applicationContext;
    methodChannel = new MethodChannel(messenger, "com.example.audio_intent");
    eventChannel = new EventChannel(messenger, "com.example.audio_intent");
    eventChannel.setStreamHandler(this);
    methodChannel.setMethodCallHandler(this);
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    applicationContext = null;
    methodChannel.setMethodCallHandler(null);
    methodChannel = null;
    eventChannel.setStreamHandler(null);
    eventChannel = null;
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    if (call.method.equals("getBatteryLevel")) {
      int batteryLevel = getBatteryLevel();

      if (batteryLevel != -1) {
        result.success(batteryLevel);
      } else {
        result.error("UNAVAILABLE", "Battery level not available.", null);
      }
    } else {
      result.notImplemented();
    }
    if (call.method.equals("getAudioFocus")) {
      
            AudioManager am = (AudioManager)applicationContext.getSystemService(Context.AUDIO_SERVICE);
            AudioManager.OnAudioFocusChangeListener focusChangeListener;
      // Request audio focus for playback
      int rest = am.requestAudioFocus(null,
      // Use the music stream.
      AudioManager.STREAM_MUSIC,
      // Request permanent focus.
      AudioManager.AUDIOFOCUS_GAIN);
            // result.success("Android " + android.os.Build.VERSION.RELEASE);
          } else {
            result.notImplemented();
          }
  }
  
  @Override
  public void onListen(Object arguments, EventSink events) {
    chargingStateChangeReceiver = createChargingStateChangeReceiver(events);
    applicationContext.registerReceiver(
        chargingStateChangeReceiver, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
  }

  @Override
  public void onCancel(Object arguments) {
    applicationContext.unregisterReceiver(chargingStateChangeReceiver);
    chargingStateChangeReceiver = null;
  }

  private int getBatteryLevel() {
    int batteryLevel = -1;
    if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
      BatteryManager batteryManager =
          (BatteryManager) applicationContext.getSystemService(applicationContext.BATTERY_SERVICE);
      batteryLevel = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);
    } else {
      Intent intent =
          new ContextWrapper(applicationContext)
              .registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
      batteryLevel =
          (intent.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100)
              / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1);
    }

    return batteryLevel;
  }

  private BroadcastReceiver createChargingStateChangeReceiver(final EventSink events) {
    return new BroadcastReceiver() {
      @Override
      public void onReceive(Context context, Intent intent) {
        int status = intent.getIntExtra(BatteryManager.EXTRA_STATUS, -1);

        switch (status) {
          case BatteryManager.BATTERY_STATUS_CHARGING:
            events.success("charging");
            break;
          case BatteryManager.BATTERY_STATUS_FULL:
            events.success("full");
            break;
          case BatteryManager.BATTERY_STATUS_DISCHARGING:
            events.success("discharging");
            break;
          default:
            events.error("UNAVAILABLE", "Charging status unavailable", null);
            break;
        }
      }
    };
  }
}


// import androidx.annotation.NonNull;
// import android.content.Context; 
// import android.content.ContextWrapper;
// import android.content.Intent;
// import android.content.IntentFilter;
// import io.flutter.embedding.engine.plugins.FlutterPlugin;
// import io.flutter.plugin.common.MethodCall;
// import io.flutter.plugin.common.MethodChannel;
// import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
// import io.flutter.plugin.common.MethodChannel.Result;
// import io.flutter.plugin.common.PluginRegistry.Registrar;
// import android.media.AudioManager;
// import android.view.View.OnFocusChangeListener;
// import android.os.Bundle;
// import io.flutter.plugin.common.EventChannel;
// import io.flutter.plugin.common.EventChannel.EventSink;
// import io.flutter.plugin.common.EventChannel.StreamHandler;
// import io.flutter.plugin.common.BinaryMessenger;

// /** AudioIntentPlugin */
// public class AudioIntentPlugin implements FlutterPlugin, StreamHandler, MethodCallHandler {
//   /// The MethodChannel that will the communication between Flutter and native Android
//   ///
//   /// This local reference serves to register the plugin with the Flutter Engine and unregister it
//   /// when the Flutter Engine is detached from the Activity
//   private MethodChannel methodChannel;
//   private Context applicationContext;
//   private EventChannel eventChannel;

//   @Override
//   public void onAttachedToEngine(FlutterPluginBinding binding) {
//     onAttachedToEngine(binding.getApplicationContext(), binding.getBinaryMessenger());
//   }

//   private void onAttachedToEngine(Context applicationContext, BinaryMessenger messenger) {
//     this.applicationContext = applicationContext;
//     methodChannel = new MethodChannel(messenger, "plugins.flutter.io/battery");
//     eventChannel = new EventChannel(messenger, "plugins.flutter.io/charging");
//     eventChannel.setStreamHandler(this);
//     methodChannel.setMethodCallHandler(this);
//   }


//   @Override
//   public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
//     methodChannel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "audio_intent");
//     methodChannel.setMethodCallHandler(this);
//   }

//   @Override
//   public void onDetachedFromEngine(FlutterPluginBinding binding) {
//     applicationContext = null;
//     methodChannel.setMethodCallHandler(null);
//     methodChannel = null;
//     eventChannel.setStreamHandler(null);
//     eventChannel = null;
//   }
//   @SuppressWarnings("deprecation")
//   public static void registerWith(io.flutter.plugin.common.PluginRegistry.Registrar registrar) {
//     final AudioIntentPlugin instance = new AudioIntentPlugin();
//     instance.onAttachedToEngine(registrar.context(), registrar.messenger());
//   }

//   @Override
//   public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    
//     if (call.method.equals("getPlatformVersion")) {
//       result.success("Android " + android.os.Build.VERSION.RELEASE);
//     } else {
//       result.notImplemented();
//     }
//     if (call.method.equals("getAudioFocus")) {
      
//       AudioManager am = (AudioManager)applicationContext.getSystemService(Context.AUDIO_SERVICE);
//       AudioManager.OnAudioFocusChangeListener focusChangeListener;
// // Request audio focus for playback
// int rest = am.requestAudioFocus(focusChangeListener,
// // Use the music stream.
// AudioManager.STREAM_MUSIC,
// // Request permanent focus.
// AudioManager.AUDIOFOCUS_GAIN);
//       // result.success("Android " + android.os.Build.VERSION.RELEASE);
//     } else {
//       result.notImplemented();
//     }
//   }

//   @Override
//   public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
//     methodChannel.setMethodCallHandler(null);
//   }
// }
