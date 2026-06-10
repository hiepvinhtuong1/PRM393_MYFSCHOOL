/// Trạng thái xác thực của user.
enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  const AuthState({
    this.status = AuthStatus.initial,
    this.studentId,
    this.errorMessage,
  });

  final AuthStatus status;
  final String? studentId;
  final String? errorMessage;

  AuthState copyWith({
    AuthStatus? status,
    String? studentId,
    String? errorMessage,
  }) =>
      AuthState(
        status: status ?? this.status,
        studentId: studentId ?? this.studentId,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
