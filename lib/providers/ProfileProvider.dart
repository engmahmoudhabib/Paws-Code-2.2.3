import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get_storage/get_storage.dart';

import 'SignInProvider.dart';

final profileProvider = StateNotifierProvider<CustomStateNotifier, ResultState>(
    (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

class CustomStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;

  CustomStateNotifier(this.bloc) : super(ResultState.idle());

  load() {
    bloc.doAction(
        param: {
          'method': 'get',
          'url': PROFILE_API,
        },
        supportLoading: false,
        supportErrorMsg: false,
        onResponse: (json) {
          try {
            GetStorage().write('account', json);
          } catch (e) {}
        },
        onNewState: (state) {
          this.state = state;
        });
  }
}
