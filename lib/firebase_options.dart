// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC94CXrawkWS70qX5MQgROBylrpY5eoFFI',
    appId: '1:371550894219:web:4e9b2acad686c08e457c8e',
    messagingSenderId: '371550894219',
    projectId: 'chat-application-56a40',
    authDomain: 'chat-application-56a40.firebaseapp.com',
    storageBucket: 'chat-application-56a40.appspot.com',
    measurementId: 'G-T2MB2TFXQ9',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD5CVPFjB6f__x_Gu53e-fvLnamsgAzlcQ',
    appId: '1:371550894219:android:a915c5053e2bed56457c8e',
    messagingSenderId: '371550894219',
    projectId: 'chat-application-56a40',
    storageBucket: 'chat-application-56a40.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCUQdpFka2pOthvEVYQ51HtsY3UN9BgWKg',
    appId: '1:371550894219:ios:1fcf0a55eef6d261457c8e',
    messagingSenderId: '371550894219',
    projectId: 'chat-application-56a40',
    storageBucket: 'chat-application-56a40.appspot.com',
    iosClientId: '371550894219-71n1rqs591dludb6plu780rko7td674m.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApplication',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCUQdpFka2pOthvEVYQ51HtsY3UN9BgWKg',
    appId: '1:371550894219:ios:1fcf0a55eef6d261457c8e',
    messagingSenderId: '371550894219',
    projectId: 'chat-application-56a40',
    storageBucket: 'chat-application-56a40.appspot.com',
    iosClientId: '371550894219-71n1rqs591dludb6plu780rko7td674m.apps.googleusercontent.com',
    iosBundleId: 'com.example.chatApplication',
  );
}