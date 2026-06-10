import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

String mapFirebaseError(dynamic e) {
  if (e is FirebaseAuthException) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'Email atau password salah';
      case 'invalid-email':
        return 'Format email tidak valid';
      case 'email-already-in-use':
        return 'Email sudah terdaftar';
      case 'weak-password':
        return 'Password terlalu lemah, minimal 6 karakter';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan';
      case 'operation-not-allowed':
        return 'Metode login ini tidak tersedia';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet';
      case 'account-exists-with-different-credential':
        return 'Email sudah terdaftar dengan metode login lain';
      default:
        return 'Terjadi kesalahan: ${e.code}';
    }
  }
  if (e is FirebaseException) {
    if (e.code == 'not-found') {
      return 'Data pengguna tidak ditemukan';
    }
    if (e.code == 'permission-denied') {
      return 'Tidak memiliki izin untuk mengubah data';
    }
    if (e.code == 'unavailable' || e.code == 'network-request-failed') {
      return 'Tidak ada koneksi internet';
    }
    if (e.code == 'failed-precondition') {
      return 'Dokumen terlalu besar. Coba gunakan gambar yang lebih kecil';
    }
    return 'Terjadi kesalahan: ${e.message ?? e.code}';
  }
  if (e is PlatformException) {
    if (e.code == '10' || e.code == 'sign_in_required') {
      return 'Login Google gagal. Pastikan perangkat terhubung ke internet dan akun Google aktif. Jika masalah berlanjut, hubungi pengembang.';
    }
    return 'Terjadi kesalahan: ${e.message ?? e.code}';
  }
  final msg = e.toString();
  if (msg.contains('dibatalkan')) return msg;
  return 'Terjadi kesalahan. Coba lagi.';
}

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool get isLoggedIn => _auth.currentUser != null;
  String? get uid => _auth.currentUser?.uid;

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email dan password harus diisi');
    }

    final cred = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user == null) throw Exception('Gagal mendaftar, coba lagi');

    await user.updateDisplayName(name);

    final userData = {
      'uid': user.uid,
      'name': name,
      'email': email,
      'createdAt': DateTime.now().toIso8601String(),
      'stats': {
        'totalTrips': 0,
        'totalDistanceKm': 0,
        'totalDurationSeconds': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      },
    };
    await _firestore.collection('users').doc(user.uid).set(userData);

    return UserModel(
      uid: user.uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
    );
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      throw Exception('Email dan password harus diisi');
    }

    final cred = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = cred.user;
    if (user == null) throw Exception('Gagal masuk, coba lagi');

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final data = doc.data();

    return UserModel(
      uid: user.uid,
      name: data?['name'] as String? ?? user.displayName ?? '',
      email: user.email ?? email,
      photoUrl: data?['photoUrl'] as String?,
      createdAt: DateTime.tryParse(data?['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Future<UserModel> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) throw Exception('Login Google dibatalkan');

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final cred = await _auth.signInWithCredential(credential);
    final user = cred.user;
    if (user == null) throw Exception('Gagal login dengan Google');

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final Map<String, dynamic> userData;
    if (!doc.exists) {
      userData = {
        'uid': user.uid,
        'name': user.displayName ?? 'Pengguna',
        'email': user.email ?? '',
        'photoUrl': user.photoURL,
        'createdAt': DateTime.now().toIso8601String(),
        'stats': {
          'totalTrips': 0,
          'totalDistanceKm': 0,
          'totalDurationSeconds': 0,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      };
      await _firestore.collection('users').doc(user.uid).set(userData);
    } else {
      userData = doc.data()!;
    }

    return UserModel(
      uid: user.uid,
      name: userData['name'] as String? ?? user.displayName ?? '',
      email: user.email ?? '',
      photoUrl: user.photoURL,
      createdAt: DateTime.tryParse(userData['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
  }

  Future<void> logout() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<void> updateProfile(String uid, Map<String, dynamic> data) async {
    await _firestore.collection('users').doc(uid).set(data, SetOptions(merge: true));
  }
}

class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? photoUrl;
  final DateTime createdAt;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.createdAt,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? email,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
