import 'package:fishing_calendar/presentation/main_page/main_page.dart';
import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});
  
  void onGetStarted(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
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

              Image.asset(
                "assets/Fisherman.png",
              ),

              SizedBox(height: 16,),

              Text("Fish Smarter, Not Harder!", style: Theme.of(context).textTheme.titleLarge,),

              SizedBox(height: 16,),

              Text("Plan your perfect fishing trip with our daily fishing calendar—discover the best times to cast your line and reel in the big catch!", textAlign: TextAlign.center,),

              Spacer(),

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
