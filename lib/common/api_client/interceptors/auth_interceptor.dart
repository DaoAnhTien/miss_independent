import 'package:dio/dio.dart';
import '../../../data/local/keychain/shared_prefs.dart';
import '../../../data/local/keychain/shared_prefs_key.dart';
import '../../../di/injection.dart';

class AuthInterceptor extends Interceptor {
  final SharedPrefs _sharedPrefs = getIt<SharedPrefs>();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final String? token = _sharedPrefs.get(SharedPrefsKey.token);
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    options.headers['Accept'] = 'application/json';
    super.onRequest(options, handler);
  }
}
