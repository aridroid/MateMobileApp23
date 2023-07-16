import 'package:mate_app/groupChat/helper/helper_functions.dart';
import 'package:mate_app/groupChat/services/database_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService {
  late FirebaseAuth _auth;
  late GoogleSignIn googleSignIn;

  GoogleSignInService() {
    _auth = FirebaseAuth.instance;
    googleSignIn = GoogleSignIn();
  }

  Future<List<dynamic>> signInWithGoogle() async {
    await Firebase.initializeApp();

    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    final User user = authResult.user!; // <= the user from firebase


    String? token = await user.getIdToken(true); // <= this is how you get the firebase auth token

    print('firebase token::$token');

    return [token,user];

    // the google authentication token
    // print(
    //     'idToken: ${googleSignInAuthentication.idToken} and accessToken: ${googleSignInAuthentication.accessToken}');

    // return googleSignInAuthentication.idToken;
  }

  Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
    print("User Signed Out From Google");
  }
}
