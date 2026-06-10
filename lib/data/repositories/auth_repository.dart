import 'package:get/get.dart';
import '../remote/firebase/auth_service.dart';
import 'trip_repository.dart';

class AuthRepository extends GetxService {
  final AuthService _authService = Get.find<AuthService>();

  final _user = Rxn<UserModel>();

  bool get isLoggedIn => _authService.isLoggedIn;
  String get uid => _authService.uid ?? 'guest';

  UserModel? get user => _user.value;
  Rxn<UserModel> get userRx => _user;

  Future<void> _migrateIfNeeded() async {
    try {
      final repo = Get.find<TripRepository>();
      await repo.migrateGuestTrips(uid);
    } catch (_) {}
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = await _authService.register(
      name: name,
      email: email,
      password: password,
    );
    _user.value = user;
    await _migrateIfNeeded();
    return user;
  }

  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final user = await _authService.login(email: email, password: password);
    _user.value = user;
    await _migrateIfNeeded();
    return user;
  }

  Future<UserModel> loginWithGoogle() async {
    final user = await _authService.signInWithGoogle();
    _user.value = user;
    await _migrateIfNeeded();
    return user;
  }

  Future<void> logout() async {
    await _authService.logout();
    _user.value = null;
  }

  Future<UserModel?> getProfile({bool forceRefresh = false}) async {
    if (!forceRefresh && _user.value != null) return _user.value;
    final uid = this.uid;
    if (uid == 'guest') return null;
    final data = await _authService.getUserProfile(uid);
    if (data == null) return null;
    _user.value = UserModel(
      uid: uid,
      name: data['name'] as String? ?? '',
      email: data['email'] as String? ?? '',
      photoUrl: data['photoUrl'] as String?,
      createdAt: DateTime.tryParse(data['createdAt'] as String? ?? '') ?? DateTime.now(),
    );
    return _user.value;
  }

  void updateProfile(UserModel user) {
    _user.value = user;
  }
}
