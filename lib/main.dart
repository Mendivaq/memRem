import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:socialapp/servisler/yetkilendirmeservisi.dart';
import 'package:socialapp/yonlendirme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());

}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return Provider<YetkilendirmeServisi>(
      create: (_)=>YetkilendirmeServisi(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Projem',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: Splash(),
      ),
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  final Shader linearGradient = LinearGradient(
    colors: <Color>[
      Colors.orange[100],
      Colors.orange[200],
      Colors.orange[300],
      Colors.orange[400],
      Colors.orange[500],
      Colors.orange[600],
      Colors.orange[700],
      Colors.orange[800],
    ],
  ).createShader(new Rect.fromLTWH(0.0, 0.0, 200.0, 70.0));
  //SpinKitWave spinkit;
  SpinKitPouringHourglass spinkit;

  @override
  void initState() {
    super.initState();

    spinkit = SpinKitPouringHourglass(
      color: Colors.orange,
      size: 90.0,
      controller: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 1500)),
    );

    Future.delayed(const Duration(seconds: 5), () async {
      Navigator.pushReplacement(
          context, new MaterialPageRoute(builder: (context) => new Yonlendirme()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(240, 240, 240, 1),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            spinkit,
            SizedBox(height: 55.0,),
            Column(
              children: [
                Image.asset('assets/images/logo_emo.png', width: 100, height: 100,),
              ],
            ),
            SizedBox(
              height: 25,
            ),
            Center(
              child: Text(
                "MemRem",
                style: new TextStyle(
                    fontSize: 60.0,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()..shader = linearGradient),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Text("Developed by Emirhan Coşkun"),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
