import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter_login/flutter_login.dart';
import 'package:time_tracker/app/routing/custom_route.dart';
import 'package:time_tracker/app/screens/auth/dashboard_screen.dart';
import 'package:time_tracker/app/services/api.dart';
import 'package:time_tracker/app/services/offline_storage_service.dart';
import 'package:time_tracker/app/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/auth';
  static bool isChecked = false;

  LoginScreen({super.key});
  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2250);

  Future<String?> _signupUser(SignupData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  Future<String?> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
      // if (!mockUsers.containsKey(name)) {
      //   return 'User not exists';
      // }
      return null;
    });
  }

  Future<String?> _signupConfirm(String error, LoginData data) {
    return Future.delayed(loginTime).then((_) {
      return null;
    });
  }

  // checkAuth() async {
  //   String? user = await OfflineHelper.getUser();
  //   if (user != null) {
  //     ///bool res=await Api.checkToken(user.token);
  //     ///if(res){
  //     ///Nvigate
  //     ///}
  //   }

  /// Get offline user
  /// if found
  /// check auth token if(true) Navigate.home
  // }

  @override
  Widget build(BuildContext context) {
    // checkAuth();
    return FlutterLogin(
      children: [
        const Row(
          children: [
            SizedBox(
              width: 100,
            ),
            FooterWidget()
          ],
        )
      ],
      title: Constants.appName,
      logo: const AssetImage('assets/images/ecorp.png'),

      logoTag: Constants.logoTag,
      titleTag: Constants.titleTag,
      navigateBackAfterRecovery: true,
      onConfirmRecover: _signupConfirm,
      //onConfirmSignup: _signupConfirm,
      loginAfterSignUp: false,
      messages: LoginMessages(confirmSignupSuccess: 'New user created !', signUpSuccess: 'New user created !'),

      // scrollable: true,
      // hideProvidersTitle: false,
      // loginAfterSignUp: false,
      hideForgotPasswordButton: true,
      // hideSignUpButton: true,
      // disableCustomPageTransformer: true,
      // messages: LoginMessages(
      //   userHint: 'User',
      //   passwordHint: 'Pass',
      //   confirmPasswordHint: 'Confirm',
      //   loginButton: 'LOG IN',
      //   signupButton: 'REGISTER',
      //   forgotPasswordButton: 'Forgot huh?',
      //   recoverPasswordButton: 'HELP ME',
      //   goBackButton: 'GO BACK',
      //   confirmPasswordError: 'Not match!',
      //   recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
      //   recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
      //   recoverPasswordSuccess: 'Password rescued successfully',
      //   flushbarTitleError: 'Oh no!',
      //   flushbarTitleSuccess: 'Succes!',
      //   providersTitle: 'login with'
      // ),

      //   // beforeHeroFontSize: 50,
      //   // afterHeroFontSize: 20,
      //   bodyStyle: TextStyle(
      //     fontStyle: FontStyle.italic,
      //     decoration: TextDecoration.underline,
      //   ),
      //   textFieldStyle: TextStyle(
      //     color: Colors.orange,
      //     shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
      //   ),
      //   buttonStyle: TextStyle(
      //     fontWeight: FontWeight.w800,
      //     color: Colors.yellow,
      //   ),
      //   cardTheme: CardTheme(
      //     color: Colors.yellow.shade100,
      //     elevation: 5,
      //     margin: EdgeInsets.only(top: 15),
      //     shape: ContinuousRectangleBorder(
      //         borderRadius: BorderRadius.circular(100.0)),
      //   ),
      //   inputTheme: InputDecorationTheme(
      //     filled: true,
      //     fillColor: Colors.purple.withOpacity(.1),
      //     contentPadding: EdgeInsets.zero,
      //     errorStyle: TextStyle(
      //       backgroundColor: Colors.orange,
      //       color: Colors.white,
      //     ),
      //     labelStyle: TextStyle(fontSize: 12),
      //     enabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //     errorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade700, width: 7),
      //       borderRadius: inputBorder,
      //     ),
      //     focusedErrorBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.red.shade400, width: 8),
      //       borderRadius: inputBorder,
      //     ),
      //     disabledBorder: UnderlineInputBorder(
      //       borderSide: BorderSide(color: Colors.grey, width: 5),
      //       borderRadius: inputBorder,
      //     ),
      //   ),
      //   buttonTheme: LoginButtonTheme(
      //     splashColor: Colors.purple,
      //     backgroundColor: Colors.pinkAccent,
      //     highlightColor: Colors.lightGreen,
      //     elevation: 9.0,
      //     highlightElevation: 6.0,
      //     shape: BeveledRectangleBorder(
      //       borderRadius: BorderRadius.circular(10),
      //     ),
      //     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      //     // shape: CircleBorder(side: BorderSide(color: Colors.green)),
      //     // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
      //   ),
      // ),
      userValidator: (value) {
        if (!value!.contains('@')) {
          return "Email must contain '@' and end with '.com'";
        }
        return null;
      },
      passwordValidator: (value) {
        if (value!.isEmpty) {
          return 'Password is empty';
        }
        return null;
      },
      onLogin: (loginData) {
        debugPrint('Login info');
        debugPrint('Name: ${loginData.name}');
        debugPrint('Password: ${loginData.password}');
        if (LoginScreen.isChecked) {
          SharedPreferences.getInstance().then(
            (prefs) {
              prefs.setBool("remember_me", LoginScreen.isChecked);
              prefs.setString('email', loginData.name);
              prefs.setString('password', loginData.password);
            },
          );
        } else {
          SharedPreferences.getInstance().then(
            (prefs) {
              prefs.setBool("remember_me", false);
              prefs.setString('email', "");
              prefs.setString('password', "");
            },
          );
        }
        return api.loginUser(loginData);
      },
      onSignup: (signupData) {
        debugPrint('Signup info');
        debugPrint('Name: ${signupData.name}');
        debugPrint('Password: ${signupData.password}');

        signupData.additionalSignupData?.forEach((key, value) {
          debugPrint('$key: $value');
        });
        if (signupData.termsOfService.isNotEmpty) {
          debugPrint('Terms of service: ');
          for (final element in signupData.termsOfService) {
            debugPrint(
              ' - ${element.term.id}: ${element.accepted == true ? 'accepted' : 'rejected'}',
            );
          }
        }
        return api.signupUser(signupData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(
          FadePageRoute(
            builder: (context) => const DashboardScreen(),
          ),
        );
      },
      onRecoverPassword: (name) {
        debugPrint('Recover password info');
        debugPrint('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      headerWidget: IntroWidget(),

      theme: LoginTheme(
        primaryColor: const Color.fromARGB(84, 24, 46, 59),
        accentColor: const Color.fromARGB(84, 24, 46, 59),
        errorColor: const Color.fromARGB(84, 24, 46, 59),
        pageColorLight: const Color.fromARGB(255, 24, 46, 59),
        pageColorDark: const Color.fromARGB(255, 24, 46, 59),
        logoWidth: 50.0,
        titleStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class IntroWidget extends StatelessWidget {
  IntroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column();
  }
}

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadUserEmailPassword();
  }

  void _handleRemeberme() {
    setState() {
      LoginScreen.isChecked = LoginScreen.isChecked;
    }
  }

  void _loadUserEmailPassword() async {
    try {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      var _email = _prefs.getString("email") ?? "";
      var _password = _prefs.getString("password") ?? "";
      var _remeberMe = _prefs.getBool("remember_me") ?? false;
      if (_remeberMe) {
        setState(() {
          LoginScreen.isChecked = true;
        });
        var login = await api.loginUser(LoginData(name: _email, password: _password));
        if (login != "Incorrect e-mail or password") {
          Navigator.of(context).pushReplacement(
            FadePageRoute(
              builder: (context) => const DashboardScreen(),
            ),
          );
        }
// _emailController.text = _email ?? "";
// _passwordController.text = _password ?? "";
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            width: 140.0,
            child: Row(
              children: [
                Theme(
                  data: ThemeData(unselectedWidgetColor: const Color(0xff00C8E8) // Your color
                      ),
                  child: Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                    side: MaterialStateBorderSide.resolveWith(
                      (states) => const BorderSide(width: 1.0, color: Colors.grey),
                    ),
                    focusColor: Colors.grey,
                    activeColor: Colors.white,
                    checkColor: Colors.grey,
                    value: LoginScreen.isChecked,
                    onChanged: (bool? value) {
                      // _handleRemeberme(value);
                      setState(() {
                        LoginScreen.isChecked = value!;
                      });
                    },
                  ),
                ),
                const Expanded(
                  child: Text("Remember me", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 12, fontFamily: 'Rubic')),
                )
              ],
            )),
      ]),
    );
  }
}
