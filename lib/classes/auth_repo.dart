import 'package:firebase_auth/firebase_auth.dart';

class AuthRepo {
  static Future<void> signUpWithEmailAndPassword(email, password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> sendEmailVerification() async {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();
  }

  static get uid {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<void> updateUserName(displayName) async {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(displayName);
  }

  static Future<void> updateProfileImage(photoURL) async {
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(photoURL);
  }

  static Future<void> signInWithEmailAndPassword(email, password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }

  static Future<void> reloadUserData() async {
    await FirebaseAuth.instance.currentUser!.reload();
  }

  static Future<bool> checkEmailVerification() async {
    return FirebaseAuth.instance.currentUser!.emailVerified;
  }

  static Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }

  static Future<void> sendPasswordResetEmail(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e);
    }
  }

  static Future<bool> checkOldPassword(email, password) async {
    final AuthCredential authCredential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    try {
      var credentialResult = await FirebaseAuth.instance.currentUser!
          .reauthenticateWithCredential(authCredential);
          return credentialResult.user  !=null;
    } on FirebaseAuthException catch (e) {
      print(e);
      return false;
    }
  }
  static Future<void> updateUserPassword(newPassword) async{
    try{
      await FirebaseAuth.instance.currentUser!.updatePassword(newPassword);
    }catch(e){
      print(e);
    }
  }
}
