import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:real_san_jose/api/auth_service.dart';

final authServiceProvider = Provider((ref) => AuthService());

final loginProvider =
    FutureProvider.family<Map<String, dynamic>, Map<String, String>>(
  (ref, credentials) async {
    final service = ref.read(authServiceProvider);
    return await service.login(
      credentials["identificator"]!,
      credentials["password"]!,
    );
  },
);
