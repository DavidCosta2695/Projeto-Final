import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDBIbUJt8psulqvuOQwSfRSy5gWlA_A12g',
    appId: '1:1009929986093:web:03708ee35452e792c998a4',
    messagingSenderId: '1009929986093',
    projectId: 'houseconnect-4d021',
    authDomain: 'houseconnect-4d021.firebaseapp.com',
    storageBucket: 'houseconnect-4d021.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBSSvFWbndNaChiSGDGGVL5EJfYAg9OtQY',
    appId: '1:1009929986093:android:4dc2193e4ff6bfb2c998a4',
    messagingSenderId: '1009929986093',
    projectId: 'houseconnect-4d021',
    storageBucket: 'houseconnect-4d021.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBIdmPp717sQuYBPN48LT6It3tLiayIvx0',
    appId: '1:1009929986093:ios:0e8cb85433b68327c998a4',
    messagingSenderId: '1009929986093',
    projectId: 'houseconnect-4d021',
    storageBucket: 'houseconnect-4d021.firebasestorage.app',
    iosBundleId: 'ualg.ise.andredavid.projetoFinal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBIdmPp717sQuYBPN48LT6It3tLiayIvx0',
    appId: '1:1009929986093:ios:0e8cb85433b68327c998a4',
    messagingSenderId: '1009929986093',
    projectId: 'houseconnect-4d021',
    storageBucket: 'houseconnect-4d021.firebasestorage.app',
    iosBundleId: 'ualg.ise.andredavid.projetoFinal',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDBIbUJt8psulqvuOQwSfRSy5gWlA_A12g',
    appId: '1:1009929986093:web:e0a49c51923dc7abc998a4',
    messagingSenderId: '1009929986093',
    projectId: 'houseconnect-4d021',
    authDomain: 'houseconnect-4d021.firebaseapp.com',
    storageBucket: 'houseconnect-4d021.firebasestorage.app',
  );
}
