import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebaselogin/deviceID.dart';
import 'package:firebaselogin/user_firestore_loginData.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebaselogin/user_repository.dart';
import 'package:firebaselogin/view/register/register.dart';
import 'package:firebaselogin/validators.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;
  final DeviceAuthenticate _deviceAuthenticate = DeviceAuthenticate();
  RegisterBloc({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  RegisterState get initialState => RegisterState.empty();

  @override
  Stream<RegisterState> transformEvents(
    Stream<RegisterEvent> events,
    Stream<RegisterState> Function(RegisterEvent event) next,
  ) {
    final observableStream = events as Observable<RegisterEvent>;
    final nonDebounceStream = observableStream.where((event) {
      return (event is! EmailChanged && event is! PasswordChanged);
    });
    final debounceStream = observableStream.where((event) {
      return (event is EmailChanged || event is PasswordChanged);
    }).debounceTime(Duration(milliseconds: 300));
    return super
        .transformEvents(nonDebounceStream.mergeWith([debounceStream]), next);
  }

  @override
  Stream<RegisterState> mapEventToState(
    RegisterEvent event,
  ) async* {
    if (event is EmailChanged) {
      yield* _mapEmailChangedToState(event.email);
    } else if (event is PasswordChanged) {
      yield* _mapPasswordChangedToState(event.password);
    } else if (event is Submitted) {
      yield* _mapFormSubmittedToState(event.email, event.password);
    }
  }

  Stream<RegisterState> _mapEmailChangedToState(String email) async* {
    yield currentState.update(
      isEmailValid: Validators.isValidEmail(email),
    );
  }

  Stream<RegisterState> _mapPasswordChangedToState(String password) async* {
    yield currentState.update(
      isPasswordValid: Validators.isValidPassword(password),
    );
  }

  Stream<RegisterState> _mapFormSubmittedToState(
    String email,
    String password,
  ) async* {
    yield RegisterState.loading();
    try {
      await _userRepository.signUp(
        email: email,
        password: password,
      );
      bool isDeviceAuthenticate = await _deviceToState(email: email);
      if (isDeviceAuthenticate) {
        yield RegisterState.success();
      } else {
        yield RegisterState.failure();
      }
    } catch (_) {
      yield RegisterState.failure();
    }
  }
  //寫入或更新設備ID
  Future<bool> _deviceToState({
    String email,
  }) async {
    //寫入或更新設備ID
    bool isDeviceAuthenticate =
    await _deviceAuthenticate.check(email, Device.id);
    return isDeviceAuthenticate;
  }
}
