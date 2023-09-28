import 'package:flutter/material.dart';
import './main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          height: 700,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: SizedBox(
                  // color: Colors.amber,
                  height: 600,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '₦',
                        style: TextStyle(
                            fontSize: 150,
                            fontWeight: FontWeight.w500,
                            foreground: Paint()
                              ..shader = LinearGradient(
                                colors: <Color>[
                                  Colors.blue.shade500,
                                  Colors.blue.shade200,

                                  //add more color here.
                                ],
                              ).createShader(const Rect.fromLTWH(
                                  100.0, 100.0, 200.0, 100.0))),
                      ),
                      const Text(
                        'Track It',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              ),
              const Text(
                "Bluey Tech",
                style: TextStyle(
                  fontSize: 23,
                  color: Colors.blue,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
