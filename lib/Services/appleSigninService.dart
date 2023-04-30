import 'package:firebase_auth/firebase_auth.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';

class AppleSignInService {

  final firebaseAuthenticationService = FirebaseAuthenticationService();

  Future<List<dynamic>> useAppleAuthentication() async {
    final result = await firebaseAuthenticationService.signInWithApple(
      appleClientId: 'Q59WYJV87T',//Annie Sheoran (PGJASXC567)
      appleRedirectUri: 'https://mate-app-b5fe6.firebaseapp.com/__/auth/handler',
    );

    final User user = result.user; // <= the user from firebase
    String token = await user.getIdToken(true); // <= this is how you get the firebase auth token
    print('firebase token::$token');

    print(result.user.uid);
    print(result.user.email);
    print(result.user.displayName);
    print(result.user.phoneNumber);
    print(result.user.photoURL);
    return [token,user];
  }

  Future<void> signOutApple() async {
    await firebaseAuthenticationService.logout();
    print("User Signed Out From Apple");
  }

}