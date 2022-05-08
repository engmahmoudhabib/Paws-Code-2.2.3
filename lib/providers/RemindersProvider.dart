import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get_storage/get_storage.dart';

import 'SignInProvider.dart';

final remindersProvider =
    StateNotifierProvider.family<CustomStateNotifier, ResultState, String>(
        (ref, id) => CustomStateNotifier(id, ref.watch(mainBlocProvider)));

class CustomStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;

  CustomStateNotifier(this.id, this.bloc) : super(ResultState.idle());
  dynamic data;
  String? id;
  dynamic tags;

  load() {
    bloc.doAction(
        param: {
          'method': 'get',
          'url': ANIMALS_LIST_API + '/${id}/reminders',
        },
        supportLoading: false,
        supportErrorMsg: false,
        onResponse: (data) {
          this.data = data;
        },
        onNewState: (state) {
          this.state = state;
        });
  }
}
