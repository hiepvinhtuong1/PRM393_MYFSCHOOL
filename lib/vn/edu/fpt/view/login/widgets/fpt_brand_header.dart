import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';

class FptBrandHeader extends StatelessWidget {
  const FptBrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppAssets.ththcsFptLogo,
      width: 150,
      fit: BoxFit.contain,
    );
  }
}
