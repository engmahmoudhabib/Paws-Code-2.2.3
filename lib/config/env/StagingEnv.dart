import 'Env.dart';
import 'package:flutter/material.dart';

void main() => Staging();

class Staging extends Env {
  final String appName = "Paws (Staging)";
  final String baseUrl = 'https://api.thepaws.app/api/';
  final Color primarySwatch = Colors.amber;
  EnvType environmentType = EnvType.STAGING;
  final String dbName = 'flutterStarter-Stg.db';
}
