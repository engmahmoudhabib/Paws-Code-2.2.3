// ignore: import_of_legacy_library_into_null_safe
import 'dart:async';

import 'package:flutter_app/tools/DataConnectionChecker.dart';

class DataConnectivityService {
  StreamController<DataConnectionStatus> connectivityStreamController =
  StreamController<DataConnectionStatus>();
  DataConnectivityService() {
    DataConnectionChecker().onStatusChange.listen((dataConnectionStatus) {
      connectivityStreamController.add(dataConnectionStatus);
    });
  }
}