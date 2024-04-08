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
    apiKey: 'AIzaSyAFoBaK4ifiVMrFTh8912-zuI5v_HR58L4',
    appId: '1:689484762717:web:36ce381a0c90c2bc4707b4',
    messagingSenderId: '689484762717',
    projectId: 'weasel-games',
    authDomain: 'weasel-games.firebaseapp.com',
    storageBucket: 'weasel-games.appspot.com',
    measurementId: 'G-NB5ELWWGJK',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAbGmSZUtsyeSjjC1hSUN8wj-glXkoGmp8',
    appId: '1:689484762717:android:8381ef5be09be38f4707b4',
    messagingSenderId: '689484762717',
    projectId: 'weasel-games',
    storageBucket: 'weasel-games.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyD9KZpSriyY6PBPfrqBLfJtQvaGXmNmgLo',
    appId: '1:689484762717:ios:3cf86ef7fb758a4b4707b4',
    messagingSenderId: '689484762717',
    projectId: 'weasel-games',
    storageBucket: 'weasel-games.appspot.com',
    iosBundleId: 'com.example.weasel',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyD9KZpSriyY6PBPfrqBLfJtQvaGXmNmgLo',
    appId: '1:689484762717:ios:7c82737744c4208c4707b4',
    messagingSenderId: '689484762717',
    projectId: 'weasel-games',
    storageBucket: 'weasel-games.appspot.com',
    iosBundleId: 'com.example.weasel.RunnerTests',
  );
}
