import 'package:flutter/material.dart';
import '../../core/constants/constants.dart';

/// Skeleton loading placeholder.
class AppShimmer extends StatefulWidget {
  const AppShimmer({required this.child, super.key});
  final Widget child;

  @override
  State<AppShimmer> createState() => _AppShimmerState();
}

class _AppShimmerState extends State<AppShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => ShaderMask(
        shaderCallback: (rect) => LinearGradient(
          begin: Alignment(_anim.value - 1, 0),
          end: Alignment(_anim.value + 1, 0),
          colors: const [
            AppColors.line2,
            AppColors.line,
            AppColors.line2,
          ],
        ).createShader(rect),
        blendMode: BlendMode.srcATop,
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Box placeholder dùng trong skeleton.
class ShimmerBox extends StatelessWidget {
  const ShimmerBox({
    this.width,
    this.height = 16,
    this.borderRadius,
    super.key,
  });

  final double? width;
  final double height;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.line,
        borderRadius: borderRadius ?? AppRadius.borderSm,
      ),
    );
  }
}

/// Skeleton cho 1 list item (icon + 2 dòng text).
class ShimmerListItem extends StatelessWidget {
  const ShimmerListItem({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            ShimmerBox(width: 44, height: 44,
                borderRadius: AppRadius.borderSm),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(height: 14, width: double.infinity),
                  const SizedBox(height: 6),
                  ShimmerBox(height: 12, width: 140),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Skeleton cho card.
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({this.height = 120, super.key});
  final double height;

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: AppColors.line,
          borderRadius: AppRadius.borderLg,
        ),
      ),
    );
  }
}
