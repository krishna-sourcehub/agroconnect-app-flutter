import 'package:agroconnect/screens/auth/views/auth_management.dart';

class UserDependencies {
  Future<Map<String, dynamic>> getSessionToken() async {
    final sessionToken = await secureStorage.read(key: "sessionToken");

    if (sessionToken == null || sessionToken.isEmpty) {
      return {'status': false, 'reason': 'sessionTokenNotFound'};
    }

    return {'status': true, 'sessionToken': sessionToken};
  }
}
