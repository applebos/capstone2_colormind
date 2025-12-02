
import 'package:flutter/material.dart';
import 'package:colormind/widgets/glass_container.dart';


class GlassCard extends StatelessWidget {
  final Widget child;
  const GlassCard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      width: double.infinity,
      borderRadius: 24,
      blur: 15,
      opacity: 0.7,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: child,
    );
  }
}
