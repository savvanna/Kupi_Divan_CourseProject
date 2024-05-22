// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
        return windows;
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
    apiKey: 'AIzaSyDeoeROv0HkOY8xQYOb_fxOwjjXX5uf-Bk',
    appId: '1:1092987819919:web:e089ccb0a5f53b06f79dfa',
    messagingSenderId: '1092987819919',
    projectId: 'furnitures-75745',
    authDomain: 'furnitures-75745.firebaseapp.com',
    storageBucket: 'furnitures-75745.appspot.com',
    measurementId: 'G-SF5QCYF5NB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBjHUoaonCvdnrzbrpdU4jKM1I0OwO6Y5Y',
    appId: '1:1092987819919:android:f3f84141805d11fff79dfa',
    messagingSenderId: '1092987819919',
    projectId: 'furnitures-75745',
    storageBucket: 'furnitures-75745.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBx_b7a89KrY6NAeRMVWABmTCODzgjDoRI',
    appId: '1:1092987819919:ios:2b5a8a849621464ff79dfa',
    messagingSenderId: '1092987819919',
    projectId: 'furnitures-75745',
    storageBucket: 'furnitures-75745.appspot.com',
    iosBundleId: 'com.example.ecommerce',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBx_b7a89KrY6NAeRMVWABmTCODzgjDoRI',
    appId: '1:1092987819919:ios:2b5a8a849621464ff79dfa',
    messagingSenderId: '1092987819919',
    projectId: 'furnitures-75745',
    storageBucket: 'furnitures-75745.appspot.com',
    iosBundleId: 'com.example.ecommerce',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDeoeROv0HkOY8xQYOb_fxOwjjXX5uf-Bk',
    appId: '1:1092987819919:web:047ece25131e176ef79dfa',
    messagingSenderId: '1092987819919',
    projectId: 'furnitures-75745',
    authDomain: 'furnitures-75745.firebaseapp.com',
    storageBucket: 'furnitures-75745.appspot.com',
    measurementId: 'G-4ZC45W9RQ5',
  );
}
