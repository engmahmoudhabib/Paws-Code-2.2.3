 import 'package:flutter/material.dart';

import 'Env.dart';

void main() => Production();

class Production extends Env {
  final String appName = "Paws";
  final String baseUrl = 'https://api.thepaws.app/api/';
  final Color primarySwatch = Colors.teal;
  EnvType environmentType = EnvType.PRODUCTION;
  final String dbName = 'flutterStarter.db';
}
