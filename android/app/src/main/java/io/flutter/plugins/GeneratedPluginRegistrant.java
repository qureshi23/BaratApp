package io.flutter.plugins;

import androidx.annotation.Keep;
import androidx.annotation.NonNull;
import io.flutter.Log;

import io.flutter.embedding.engine.FlutterEngine;

/**
 * Generated file. Do not edit.
 * This file is generated by the Flutter tool based on the
 * plugins that support the Android platform.
 */
@Keep
public final class GeneratedPluginRegistrant {
  private static final String TAG = "GeneratedPluginRegistrant";
  public static void registerWith(@NonNull FlutterEngine flutterEngine) {
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.firestore.FlutterFirebaseFirestorePlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin cloud_firestore, io.flutter.plugins.firebase.firestore.FlutterFirebaseFirestorePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin firebase_auth, io.flutter.plugins.firebase.auth.FlutterFirebaseAuthPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin firebase_core, io.flutter.plugins.firebase.core.FlutterFirebaseCorePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.database.FirebaseDatabasePlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin firebase_database, io.flutter.plugins.firebase.database.FirebaseDatabasePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.dynamiclinks.FlutterFirebaseDynamicLinksPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin firebase_dynamic_links, io.flutter.plugins.firebase.dynamiclinks.FlutterFirebaseDynamicLinksPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin firebase_messaging, io.flutter.plugins.firebase.messaging.FlutterFirebaseMessagingPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.firebase.storage.FlutterFirebaseStoragePlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin firebase_storage, io.flutter.plugins.firebase.storage.FlutterFirebaseStoragePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new app.meedu.flutter_facebook_auth.FlutterFacebookAuthPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin flutter_facebook_auth, app.meedu.flutter_facebook_auth.FlutterFacebookAuthPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin flutter_local_notifications, com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin flutter_plugin_android_lifecycle, io.flutter.plugins.flutter_plugin_android_lifecycle.FlutterAndroidLifecyclePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.baseflow.geocoding.GeocodingPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin geocoding, com.baseflow.geocoding.GeocodingPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.baseflow.geolocator.GeolocatorPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin geolocator_android, com.baseflow.geolocator.GeolocatorPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.github.zeshuaro.google_api_headers.GoogleApiHeadersPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin google_api_headers, io.github.zeshuaro.google_api_headers.GoogleApiHeadersPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.googlemaps.GoogleMapsPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin google_maps_flutter, io.flutter.plugins.googlemaps.GoogleMapsPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.googlesignin.GoogleSignInPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin google_sign_in_android, io.flutter.plugins.googlesignin.GoogleSignInPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.imagepicker.ImagePickerPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin image_picker_android, io.flutter.plugins.imagepicker.ImagePickerPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.lyokone.location.LocationPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin location, com.lyokone.location.LocationPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin package_info_plus, dev.fluttercommunity.plus.packageinfo.PackageInfoPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new io.flutter.plugins.pathprovider.PathProviderPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin path_provider_android, io.flutter.plugins.pathprovider.PathProviderPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.aboutyou.dart_packages.sign_in_with_apple.SignInWithApplePlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin sign_in_with_apple, com.aboutyou.dart_packages.sign_in_with_apple.SignInWithApplePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.tekartik.sqflite.SqflitePlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin sqflite, com.tekartik.sqflite.SqflitePlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.flutter.stripe.StripeAndroidPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin stripe_android, com.flutter.stripe.StripeAndroidPlugin", e);
    }
    try {
      flutterEngine.getPlugins().add(new com.maru.twitter_login.TwitterLoginPlugin());
    } catch(Exception e) {
      Log.e(TAG, "Error registering plugin twitter_login, com.maru.twitter_login.TwitterLoginPlugin", e);
    }
  }
}