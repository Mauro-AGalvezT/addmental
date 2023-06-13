import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/settings/android_settings.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/material.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static const String _isolateName = "LocatorIsolate";
  static ReceivePort port = ReceivePort();

  static void callback(LocationDto locationDto) async {
    final SendPort? send = IsolateNameServer.lookupPortByName(_isolateName);
    send?.send(locationDto);
  }

  static void initCallback(dynamic _) {
    print('Plugin initialization');
  }

  static void notificationCallback() {
    print('User clicked on the notification');
  }

  static void startLocationService() {
    BackgroundLocator.registerLocationUpdate(
      callback,
      initCallback: initCallback,
      disposeCallback: null,
      autoStop: false,
      iosSettings: const IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: 0,
      ),
      androidSettings: const AndroidSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        interval: 10,
        wakeLockTime: 300,
        distanceFilter: 0,
        androidNotificationSettings: AndroidNotificationSettings(
          notificationChannelName: 'Location tracking',
          notificationTitle: 'Start Location Tracking',
          notificationMsg: 'Track location in background',
          notificationBigMsg:
          'Background location is on to keep the app up-to-date with your location. This is required for main features to work properly when the app is not running.',
          notificationIcon: '',
          notificationIconColor: Colors.grey,
          notificationTapCallback: notificationCallback,
        ),
      ),
    );
  }

  static void stopLocationService() {
    IsolateNameServer.removePortNameMapping(_isolateName);
    BackgroundLocator.unRegisterLocationUpdate();
  }
}
