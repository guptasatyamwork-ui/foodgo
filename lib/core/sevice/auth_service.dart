import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late SharedPreferences _prefs;

  // Observable user state
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final RxBool isLoggedIn = false.obs;
  final RxString userName = ''.obs;
  final RxString userEmail = ''.obs;

  // SharedPreferences keys
  static const String _keyName    = 'user_name';
  static const String _keyEmail   = 'user_email';
  static const String _keyLoggedIn = 'is_logged_in';

  Future<AuthService> init() async {
    _prefs = await SharedPreferences.getInstance();

    // Firebase auth state listen karo
    _auth.authStateChanges().listen((User? user) {
      firebaseUser.value = user;
      if (user != null) {
        isLoggedIn.value = true;
        userEmail.value = user.email ?? '';
        // Local se naam lo
        userName.value = _prefs.getString(_keyName) ?? '';
      } else {
        isLoggedIn.value = false;
        userEmail.value = '';
        userName.value = '';
      }
    });

    // Local cache check
    isLoggedIn.value = _prefs.getBool(_keyLoggedIn) ?? false;
    userName.value  = _prefs.getString(_keyName) ?? '';
    userEmail.value = _prefs.getString(_keyEmail) ?? '';

    return this;
  }

  // ✅ REGISTER
  Future<String?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Firebase mein display name set karo
      await credential.user?.updateDisplayName(name.trim());

      // SharedPreferences mein save karo
      await _saveLocal(name: name.trim(), email: email.trim());

      return null; // null = success
    } on FirebaseAuthException catch (e) {
      return _errorMessage(e.code);
    } catch (e) {
      return 'Kuch galat hua. Dobara try karo.';
    }
  }

  // ✅ LOGIN
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final user = credential.user;
      final name = user?.displayName ?? email.split('@')[0];

      // SharedPreferences mein save karo
      await _saveLocal(name: name, email: email.trim());

      return null; // null = success
    } on FirebaseAuthException catch (e) {
      return _errorMessage(e.code);
    } catch (e) {
      return 'Kuch galat hua. Dobara try karo.';
    }
  }

  // ✅ FORGOT PASSWORD
  Future<String?> resetPassword({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      return null; // null = success (email bhej diya)
    } on FirebaseAuthException catch (e) {
      return _errorMessage(e.code);
    } catch (e) {
      return 'Kuch galat hua. Dobara try karo.';
    }
  }

  // ✅ LOGOUT
  Future<void> logout() async {
    await _auth.signOut();
    await _prefs.clear();
    isLoggedIn.value = false;
    userName.value   = '';
    userEmail.value  = '';
  }

  // Local mein save karo
  Future<void> _saveLocal({required String name, required String email}) async {
    await _prefs.setString(_keyName, name);
    await _prefs.setString(_keyEmail, email);
    await _prefs.setBool(_keyLoggedIn, true);
    userName.value  = name;
    userEmail.value = email;
    isLoggedIn.value = true;
  }

  // Firebase error codes → readable messages
  String _errorMessage(String code) {
    switch (code) {
      case 'user-not-found':        return 'Yeh email registered nahi hai.';
      case 'wrong-password':        return 'Password galat hai.';
      case 'email-already-in-use':  return 'Yeh email pehle se registered hai.';
      case 'weak-password':         return 'Password kam se kam 6 characters ka hona chahiye.';
      case 'invalid-email':         return 'Email format sahi nahi hai.';
      case 'user-disabled':         return 'Yeh account disabled hai.';
      case 'too-many-requests':     return 'Bahut zyada attempts. Thodi der baad try karo.';
      case 'network-request-failed':return 'Internet connection check karo.';
      case 'invalid-credential':    return 'Email ya password galat hai.';
      default:                      return 'Kuch galat hua. Dobara try karo.';
    }
  }

  // Current Firebase user
  User? get currentUser => _auth.currentUser;

  // Check if user is currently logged in
  bool get isAuthenticated => _auth.currentUser != null;
}