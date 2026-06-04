import 'package:flutter/services.dart';

abstract final class AppFormatters {
  static final phone = <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(10),
  ];
}
