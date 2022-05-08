import 'package:flutter/material.dart';

import 'AppFactory.dart';

class ConstantsWidget extends InheritedWidget {
  static ConstantsWidget? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ConstantsWidget>();

  const ConstantsWidget({required Widget child, Key? key})
      : super(key: key, child: child);

  getAccountsType() {
    return [
      {
        'selected': true,
        'title': AppFactory.getLabel('breeder-account', 'مستخدم/مربي'),
        'id': 'breeder'
      },
      {
        'selected': false,
        'title': AppFactory.getLabel('provider-account',
            'مقدم الخدمة (بيطرة، فندقة، حلاقة، حمام، تنزه وتمشي، تدريب, نقل و اغاثة)'),
        'id': 'service_provider',
        'hint': '(بيطرة، فندقة، حلاقة، حمام، تنزه وتمشي، تدريب, نقل و اغاثة)'
      }
    ];
  }

  @override
  bool updateShouldNotify(ConstantsWidget oldWidget) => false;
}
