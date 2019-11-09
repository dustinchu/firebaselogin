import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebaselogin/bloc/authentication_bloc/bloc.dart';
import 'package:firebaselogin/user_repository.dart';
import 'package:firebaselogin/home_screen.dart';
import 'package:firebaselogin/view/login/login.dart';
import 'package:firebaselogin/splash_screen.dart';
import 'package:firebaselogin/simple_bloc_delegate.dart';
import 'package:device_info/device_info.dart';

void main() async{
  BlocSupervisor.delegate = SimpleBlocDelegate();
  final UserRepository userRepository = UserRepository();
  final DeviceID getDeviceID = DeviceID();

  //待 把登入修改 getdevice 寫進去～～～

  runApp(
    BlocProvider(
      builder: (context) => AuthenticationBloc(userRepository: userRepository,deviceID:getDeviceID._getDeviceID(context))
        ..dispatch(AppStarted()),
      child: App(userRepository: userRepository),
    ),
  );
}

class App extends StatelessWidget {
  final UserRepository _userRepository;
  final DeviceID getDeviceID = DeviceID();
  App({Key key, @required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state is Unauthenticated) {
            return LoginScreen(userRepository: _userRepository);
          }
          if (state is Authenticated) {
            return HomeScreen(name: state.displayName);
          }
          return SplashScreen();
        },
      ),
    );
  }
}

class DeviceID {
  Future<String> _getDeviceID(BuildContext context) async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }
}
