import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

/// §22. `Result.fold` here is `core`'s own hand-rolled `Result` API (§15),
/// not a freezed union — ADR-005's ban on `.when()`/`.map()` applies to
/// freezed-generated union matching (see `LoginState`), not this.
@injectable
class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;
  LoginCubit(this._loginUseCase) : super(const LoginState.initial());

  Future<void> submit({required String email, required String password}) async {
    emit(const LoginState.loading());
    final result = await _loginUseCase(LoginParams(email: email, password: password));
    result.fold(
      (failure) => emit(LoginState.failure(failure)),
      (user) => emit(LoginState.success(user)),
    );
  }
}
