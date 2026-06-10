import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/auth_state.dart';

/// Provider quản lý trạng thái xác thực.
/// TODO: kết nối với AuthRepository khi implement.
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> login({
    required String studentId,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    // TODO: gọi AuthRepository.login()
    await Future.delayed(const Duration(seconds: 1));
    state = state.copyWith(
      status: AuthStatus.authenticated,
      studentId: studentId,
    );
  }

  Future<void> logout() async {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (_) => AuthNotifier(),
);
