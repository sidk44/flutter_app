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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBE8ZteOBlCMMOZNYH1JbfLraH-s2RdwI0',
    appId: '1:532954168699:android:c91a256f6a6890a92211de',
    messagingSenderId: '532954168699',
    projectId: 'social-9b5d9',
    storageBucket: 'social-9b5d9.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBvHl0T30uysXOOu7T_XtEtV2Mw3DEnQSk',
    appId: '1:532954168699:ios:ee8c113ef7be0d8b2211de',
    messagingSenderId: '532954168699',
    projectId: 'social-9b5d9',
    storageBucket: 'social-9b5d9.appspot.com',
    androidClientId: '532954168699-esdsf0u4si4soaaq33voe9of4k06a99g.apps.googleusercontent.com',
    iosClientId: '532954168699-husjv590hb2afehe6esl5bctsrlk6slv.apps.googleusercontent.com',
    iosBundleId: 'com.example.demo',
  );
}