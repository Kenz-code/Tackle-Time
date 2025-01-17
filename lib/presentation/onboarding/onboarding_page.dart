import 'package:tackle_time/domain/onboarding_check.dart';
import 'package:tackle_time/utils/services/onboarding_service.dart';
import 'package:tackle_time/presentation/main_page/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});
  
  void onGetStarted(BuildContext context) async {
    await OnboardingService().markOnboardingSeen();

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingCheck()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 16,),

              Text("Tackle Time", style: Theme.of(context).textTheme.displaySmall!,),

              SizedBox(height: 16,),

              Expanded(
                child: Image.asset(
                  "assets/Fisherman.png",
                  fit: BoxFit.cover,
                ),
              ),

              SizedBox(height: 16,),

              Text("Fish Smarter, Not Harder!", style: Theme.of(context).textTheme.titleLarge,),

              SizedBox(height: 16,),

              Text("Plan your perfect fishing trip with our daily fishing calendar—discover the best times to cast your line and reel in the big catch!", textAlign: TextAlign.center,),

              SizedBox(height: 48,),

              Row(
                children: [
                  Expanded(
                    child: FilledButton(
                      onPressed: () => onGetStarted(context),
                      child: Text("Get Started"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}
