import 'dart:async';

import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class ApiBloc {
  CompositeSubscription? _compositeSubscription;

  doAction(
      {required Map<String, dynamic> param,
      bool supportLoading = false,
      bool supportDataHandler = false,
      Function(dynamic)? onResponse,
      Function(dynamic)? onNewState,
      Function(dynamic)? onPreCall,
      bool supportErrorMsg = true,
      dynamic behaviorSubject}) async {
    if (_compositeSubscription == null) {
      _compositeSubscription = CompositeSubscription();
    }

    if (behaviorSubject != null) {
      try {
        behaviorSubject.add(ResultState.loading());
      } catch (e) {}
    }

    if (onPreCall != null) {
      param = await onPreCall.call(param);
    }

    if (onNewState != null) {
      onNewState.call(ResultState.loading());
    }

    StreamSubscription subscription = Stream.fromFuture(GetIt.I<APIRepository>()
            .doAction(
                param: param,
                supportLoading: supportLoading,
                supportErrorMsg: supportErrorMsg))
        .listen((response) {
      response.when(success: (data) {
        if (onResponse != null) if (supportDataHandler)
          data = onResponse.call(data);
        else
          onResponse.call(data);
        else if (behaviorSubject != null) {
          try {
            behaviorSubject.add(ResultState.data(data: data));
          } catch (e) {}
        }

        if (onNewState != null) {
          onNewState.call(ResultState.data(data: data));
        }
      }, failure: (error) {
        if (behaviorSubject != null) {
          try {
            behaviorSubject.add(ResultState.error(error: error));
          } catch (e) {}
        }

        if (onNewState != null) {
          onNewState.call(ResultState.error(error: error));
        }
      });
    });
    _compositeSubscription!.add(subscription);
  }

  dispose() {
    if (_compositeSubscription != null) _compositeSubscription!.clear();
  }
}
