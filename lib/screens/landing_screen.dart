import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:colormind/screens/main_layout.dart';
import 'package:colormind/theme/app_theme.dart';
import 'package:colormind/widgets/glass_container.dart';
import 'package:colormind/providers/character_provider.dart';
import 'package:colormind/theme/theme_notifier.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CharacterProvider>(context, listen: false);
      if (provider.isInitialized) {
        _updateTheme(provider);
      } else {
        provider.addListener(() {
          if (mounted && provider.isInitialized) {
            _updateTheme(provider);
          }
        });
      }
    });
  }

  void _updateTheme(CharacterProvider provider) {
    Provider.of<ThemeNotifier>(
      context,
      listen: false,
    ).setTheme(provider.getCharacterTheme());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.getBackgroundGradient(Theme.of(context)),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Background Elements (Optional subtle circles)
              Positioned(
                top: -50,
                left: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
              ),

              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    // Logo Area
                    GlassContainer(
                      width: 300,
                      height: 300,
                      borderRadius: 60,
                      blur: 20,
                      opacity: 0.3,
                      color: Colors.white,
                      child: Center(
                        child: Image.asset(
                          'assets/colormind_logo_3.png',
                          height: 250,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),


                    // Subtitle
                    Text(
                      '당신의 감정을 이해하는\n따뜻한 AI 친구',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        height: 1.5,
                      ),
                    ),

                    const Spacer(flex: 3),

                    // Start Button
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainLayout(),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(
                                context,
                              ).primaryColor.withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '시작하기',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
