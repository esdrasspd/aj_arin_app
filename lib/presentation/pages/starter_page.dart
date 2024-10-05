import 'package:flutter/material.dart';
import 'package:tickets_app/data/utils/fade_animation.dart';
import 'package:tickets_app/presentation/pages/login_page.dart';

class StarterPage extends StatefulWidget {
  const StarterPage({super.key});

  @override
  State<StarterPage> createState() => _StarterPage();
}

class _StarterPage extends State<StarterPage> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _animation = Tween<double>(
      begin: 1.0,
      end: 35.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _onTap() {
    setState(() {});

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/home.jpg'), fit: BoxFit.cover),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(.9),
                Colors.black.withOpacity(.8),
                Colors.black.withOpacity(.2),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const FadeAnimation(
                  .5,
                  Text(
                    'Realiza reportes fácilmente',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 50,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const FadeAnimation(
                  1,
                  Text(
                    'Carreteras, tuberías, basureros, otros... ',
                    style: TextStyle(
                        color: Colors.white, height: 1.4, fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                FadeAnimation(
                  1.2,
                  ScaleTransition(
                    scale: _animation,
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: const LinearGradient(
                            colors: [
                              Colors.yellow,
                              Colors.orange,
                            ],
                          ),
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: _onTap,
                          child: const Text(
                            'Continuar',
                            style: TextStyle(color: Colors.white),
                          ),
                        )),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
