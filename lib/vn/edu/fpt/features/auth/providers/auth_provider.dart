import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/mock/mock.dart';

enum AuthStatus { unauthenticated, authenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.errorMessage,
    this.isLoading = false,
  });

  final AuthStatus status;
  final String? errorMessage;
  final bool isLoading;

  AuthState copyWith({
    AuthStatus? status,
    String? errorMessage,
    bool clearError = false,
    bool? isLoading,
  }) =>
      AuthState(
        status: status ?? this.status,
        errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
        isLoading: isLoading ?? this.isLoading,
      );
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState(status: AuthStatus.unauthenticated));

  /// Mock login — chấp nhận bất kỳ thông tin (phase 1 UI-only).
  Future<bool> login(String studentId, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (studentId.trim().isEmpty || password.trim().isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Vui lòng nhập đầy đủ thông tin.',
      );
      return false;
    }

    state = state.copyWith(
      status: AuthStatus.authenticated,
      isLoading: false,
    );
    return true;
  }

  void logout() {
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(),
);

final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(authProvider).status == AuthStatus.authenticated,
);

/// Hint mã số mock để hiển thị trên màn hình login.
final mockStudentIdHintProvider = Provider<String>((_) => MockUser.studentId);
