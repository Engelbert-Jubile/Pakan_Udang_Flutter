import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart'; // Impor firebase_core untuk inisialisasi Firebase
import 'package:firebase_auth/firebase_auth.dart'; // Firebase Auth

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user; // Mengembalikan pengguna setelah login
    } catch (e) {
      rethrow; // Rethrow exception untuk ditangani di UI
    }
  }

  User? get currentUser => _auth.currentUser;

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
