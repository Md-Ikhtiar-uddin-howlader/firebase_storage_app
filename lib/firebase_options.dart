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
    apiKey: 'AIzaSyACO4zd6WW7qkRJEBPskWK66fKIkQhxDmk',
    appId: '1:945818395084:web:704a7e23d58f1cd852bd69',
    messagingSenderId: '945818395084',
    projectId: 'casestudy-f2d42',
    authDomain: 'casestudy-f2d42.firebaseapp.com',
    storageBucket: 'casestudy-f2d42.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAi0r9viuirgmD6xyv_pWNzI6vxNgKGPvg',
    appId: '1:945818395084:android:191960c9b13d880552bd69',
    messagingSenderId: '945818395084',
    projectId: 'casestudy-f2d42',
    storageBucket: 'casestudy-f2d42.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBzikQeF963sz2sdFF6kr57G5U8mZw3teQ',
    appId: '1:945818395084:ios:fe3e2c2e078786cc52bd69',
    messagingSenderId: '945818395084',
    projectId: 'casestudy-f2d42',
    storageBucket: 'casestudy-f2d42.appspot.com',
    iosBundleId: 'com.example.firebaseStorageApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBzikQeF963sz2sdFF6kr57G5U8mZw3teQ',
    appId: '1:945818395084:ios:42232767ef39926752bd69',
    messagingSenderId: '945818395084',
    projectId: 'casestudy-f2d42',
    storageBucket: 'casestudy-f2d42.appspot.com',
    iosBundleId: 'com.example.firebaseStorageApp.RunnerTests',
  );
}
