import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go2car/core/errors/failure.dart';
import 'package:go2car/features/auth/data/models/user_model.dart';
import 'package:go2car/features/auth/data/repos/user_repo.dart';


class UserRepoImpl implements UserRepo {
  @override
  Future<void> logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Future<Either<Failure, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      // Step 1: Sign in with Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      if (user != null) {
        log("✅ Signed in as: ${user.email}");

        // Step 2: Get user profile from Firestore (optional)
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get();

        if (userDoc.exists) {
          log("📂 User profile: ${userDoc.data()}");
          return Right(UserModel.fromJson(userDoc));
        } else {
          log("⚠️ No profile found in Firestore!");
          return left(
            Failure(errorMessage: "⚠️ No profile found in Firestore!"),
          );
        }
      }
    } on FirebaseAuthException catch (ex) {
      if (ex.code == 'user-not-found') {
        return left(Failure(errorMessage: "No user found for that email"));
      } else if (ex.code == 'wrong-password') {
        return left(
          Failure(errorMessage: "Wrong password provided for that user."),
        );
      }
    } on Exception catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }
    return left(Failure(errorMessage: 'Something went wrong,please try later'));
  }

  @override
  Future<Either<Failure, void>> registerUser({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Step 1: Create account in Firebase Auth
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      // Step 2: Save user profile in Firestore
      if (user != null) {
        final userData = {
        'userid': user.uid,
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      };
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(userData);
      }

      log("✅ User registered & profile saved!");
      return right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(
          Failure(errorMessage: "The password provided is too weak."),
        );
      } else if (e.code == 'email-already-in-use') {
        return left(
          Failure(errorMessage: "The account already exists for that email."),
        );
      }
    } on Exception catch (e) {
      return left(Failure(errorMessage: e.toString()));
    }

    return left(
      Failure(errorMessage: "Something went wrong, please try later"),
    );
  }
}
