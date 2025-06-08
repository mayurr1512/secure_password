import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:password_manager/utils/helper/assets_helper.dart';
import 'package:sizer/sizer.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Progress duration
    )..addListener(() {
      setState(() {});
    });

    _controller.forward().whenComplete(() {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(AssetsHelper.appIcon, width: 40.w, height: 40.w),
              SizedBox(height: 3.h),
              Text(
                "Secure Password",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                )
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: 40.w,
                child: LinearProgressIndicator(
                  color: Colors.amber,
                  value: _controller.value,
                  minHeight: 6,
                ),
              )
            ],
          )),
    );
  }
}
