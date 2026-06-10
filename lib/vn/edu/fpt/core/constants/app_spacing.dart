import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xs   = 4;
  static const double sm   = 8;
  static const double md   = 12;
  static const double lg   = 16;
  static const double xl   = 20;
  static const double x2l  = 24;
  static const double x3l  = 32;
  static const double screenH = 18; // horizontal screen padding
}

abstract final class AppRadius {
  static const xs   = Radius.circular(7);
  static const sm   = Radius.circular(10);
  static const md   = Radius.circular(14);
  static const lg   = Radius.circular(18);
  static const xl   = Radius.circular(24);
  static const full = Radius.circular(999);

  static const borderXs   = BorderRadius.all(xs);
  static const borderSm   = BorderRadius.all(sm);
  static const borderMd   = BorderRadius.all(md);
  static const borderLg   = BorderRadius.all(lg);
  static const borderXl   = BorderRadius.all(xl);
  static const borderFull = BorderRadius.all(full);
}

abstract final class AppShadows {
  static const sm = [
    BoxShadow(color: Color(0x1214325A), blurRadius: 8, offset: Offset(0, 2)),
  ];
  static const md = [
    BoxShadow(color: Color(0x1A14325A), blurRadius: 22, offset: Offset(0, 8)),
  ];
  static const lg = [
    BoxShadow(color: Color(0x2914325A), blurRadius: 44, offset: Offset(0, 18)),
  ];
  static const blue = [
    BoxShadow(color: Color(0x4D0066CC), blurRadius: 26, offset: Offset(0, 10)),
  ];
  static const orange = [
    BoxShadow(color: Color(0x52FF7A1A), blurRadius: 24, offset: Offset(0, 10)),
  ];
}
