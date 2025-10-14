import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  Future<UserCredential> signIn(String email, String password) async {
    if (!isValidEmail(email)) throw 'Format email tidak valid';
    if (password.length < 6) throw 'Password minimal 6 karakter';

    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw 'Email dan password tidak boleh kosong';
    }
    if (password.length < 6) {
      throw 'Password minimal 6 karakter';
    }
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    if (email.isEmpty) {
      throw 'Email tidak boleh kosong';
    }
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  Future<void> updatePassword(String newPassword) async {
    if (newPassword.isEmpty) {
      throw 'Password tidak boleh kosong';
    }
    if (newPassword.length < 6) {
      throw 'Password minimal 6 karakter';
    }
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw 'User tidak ditemukan. Silakan login kembali';
      }
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e.code);
    }
  }

  String _handleAuthError(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'weak-password':
        return 'Password terlalu lemah';
      case 'user-not-found':
        return 'User tidak ditemukan';
      case 'wrong-password':
        return 'Password salah';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan coba beberapa saat lagi';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah';
      case 'operation-not-allowed':
        return 'Operasi tidak diizinkan';
      case 'invalid-credential':
        return 'Email atau password salah';
      default:
        return 'Terjadi kesalahan: $code';
    }
  }
}
