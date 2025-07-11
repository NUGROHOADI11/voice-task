import 'package:get/get.dart';
import 'package:google_sign_in_platform_interface/google_sign_in_platform_interface.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  GoogleSignInUserData? currentUser;
  bool isAuthorized = false;
  String errorMessage = '';
  Future<void>? _initialization;

  @override
  void onInit() {
    super.onInit();
    _signIn();
  }

  Future<void> _ensureInitialized() {
    return _initialization ??=
        GoogleSignInPlatform.instance.init(const InitParameters())
          ..catchError((dynamic _) {
            _initialization = null;
          });
  }

  void _setUser(GoogleSignInUserData? user) {
    currentUser = user;
    if (user != null) {}
  }

  Future<void> _signIn() async {
    await _ensureInitialized();
    try {
      final AuthenticationResults? result = await GoogleSignInPlatform.instance
          .attemptLightweightAuthentication(
              const AttemptLightweightAuthenticationParameters());
      _setUser(result?.user);
    } on GoogleSignInException catch (e) {
      errorMessage = e.code == GoogleSignInExceptionCode.canceled
          ? ''
          : 'GoogleSignInException ${e.code}: ${e.description}';
    }
  }

  Future<void> handleSignIn() async {
    try {
      await _ensureInitialized();
      final AuthenticationResults result = await GoogleSignInPlatform.instance
          .authenticate(const AuthenticateParameters());
      _setUser(result.user);
      isAuthorized = true;
    } on GoogleSignInException catch (e) {
      errorMessage = e.code == GoogleSignInExceptionCode.canceled
          ? ''
          : 'GoogleSignInException ${e.code}: ${e.description}';
    }
  }

  Future<void> handleSignOut() async {
    await _ensureInitialized();
    await GoogleSignInPlatform.instance.disconnect(const DisconnectParams());
  }
}
