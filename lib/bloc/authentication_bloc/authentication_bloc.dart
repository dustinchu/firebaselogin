import 'dart:async';
import 'package:bloc/bloc.dart';
import '../../user_firestore_loginData.dart';
import './bloc.dart';
import 'package:meta/meta.dart';
import 'package:firebaselogin/bloc/authentication_bloc/bloc.dart';
import 'package:firebaselogin/user_repository.dart';
import 'package:firebaselogin/deviceID.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;
  final Future<String> _deviceID;
  final UserFirebaseStoreLoginData _deviceAuthenticate =
      UserFirebaseStoreLoginData();

  AuthenticationBloc(
      {@required UserRepository userRepository, Future<String> deviceID})
      : assert(userRepository != null),
        _userRepository = userRepository,
        _deviceID = deviceID;

  @override
  AuthenticationState get initialState => Uninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(
    AuthenticationEvent event,
  ) async* {
    if (event is AppStarted) {
      yield* _mapAppStartedToState();
    } else if (event is LoggedIn) {
      yield* _mapLoggedInToState();
    } else if (event is LoggedOut) {
      yield* _mapLoggedOutToState();
    }
  }

  Stream<AuthenticationState> _mapAppStartedToState() async* {
    try {
      //登入狀態
      final isSignedIn = await _userRepository.isSignedIn();
      //得到設備ID
      final deviceID = await _deviceID;
      Device.id = deviceID;
      //token 正確
      if (isSignedIn) {
        final email = await _userRepository.getUser();
        final String isDeviceID =
            await _deviceAuthenticate.checkDeviceID(email, deviceID);
        //與上一次登入設備id一樣
        if (isDeviceID == "true") {
          yield Authenticated(email);
        } else {
          yield Unauthenticated();
        }
      } else {
        yield Unauthenticated();
      }
    } catch (_) {
      yield Unauthenticated();
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState() async* {
    yield Authenticated(await _userRepository.getUser());
  }

  Stream<AuthenticationState> _mapLoggedOutToState() async* {
    yield Unauthenticated();
    _userRepository.signOut();
  }
}
