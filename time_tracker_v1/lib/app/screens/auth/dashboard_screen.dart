import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../routing/transition_route_observer.dart';
import '../../utils/constants.dart';
import '../chat/design/home.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import '../../services/api.dart';
import '../../widgets/fade_in.dart';
import '../profile/profile.dart';

class DashboardScreen extends StatefulWidget {
  static const routeName = '/dashboard';

  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with SingleTickerProviderStateMixin, TransitionRouteAware {
  final routeObserver = TransitionRouteObserver<PageRoute?>();
  static const headerAniInterval = Interval(.1, .3, curve: Curves.easeOut);
  late Animation<double> _headerScaleAnimation;
  AnimationController? _loadingController;

  @override
  void initState() {
    api.update = false;
    api.start();

    super.initState();

    _loadingController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1250));

    _headerScaleAnimation = Tween<double>(begin: .6, end: 1).animate(CurvedAnimation(parent: _loadingController!, curve: headerAniInterval));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute<dynamic>?);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _loadingController!.dispose();

    super.dispose();
  }

  @override
  void didPushAfterTransition() => _loadingController!.forward();

  AppBar _buildAppBar(ThemeData theme) {
    final signOutBtn = IconButton(
      icon: const Icon(FontAwesomeIcons.solidUser),
      color: Color.fromARGB(255, 24, 46, 59),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
      },
    );
    final title = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: const <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Hero(tag: Constants.logoTag, child: CircleAvatar(radius: 15.0, backgroundImage: AssetImage('assets/images/ecorp.png'))),
        ),
        Expanded(child: Center(child: Text("Time Tracker", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0)))),
      ],
    );

    return AppBar(
      actions: <Widget>[
        FadeIn(controller: _loadingController, offset: .3, curve: headerAniInterval, fadeDirection: FadeDirection.endToStart, child: signOutBtn),
      ],
      title: title,
      backgroundColor: theme.primaryColor.withOpacity(.1),
      elevation: 0,
      // toolbarTextStyle: TextStle(),
      // textTheme: theme.accentTextTheme,
      // iconTheme: theme.accentIconTheme,
    );
  }

  ////my code starts here

  var startTime;
  bool canShowButton = true;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.
  final _isHours = true;
  void startLoading() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (api.update == true) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!api.update) {
      startLoading();
    }
    void widgetBuild() {
      setState(() {
        canShowButton = false;
      });
    }

    final theme = Theme.of(context);

    return WillPopScope(onWillPop: () => api.goToLogin(context), child: SafeArea(child: Scaffold(appBar: _buildAppBar(theme), body: Home())));
  }
}
