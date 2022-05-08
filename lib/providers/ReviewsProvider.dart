import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get_storage/get_storage.dart';

import 'SignInProvider.dart';

final reviewsProvider =
    StateNotifierProvider.family<CustomStateNotifier, ResultState, String>(
        (ref, type) => CustomStateNotifier(ref.watch(mainBlocProvider), type));

class CustomStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;
  String type;

  CustomStateNotifier(this.bloc, this.type) : super(ResultState.idle());

  /*
  authResponse.data!.serviceProvider['service_center']['id'].toString();
   */

  getServiceCenterId(){
    try {
      return AuthResponse
          .fromMap(GetStorage().read('account'))
          .data
          ?.serviceProvider
      ['service_center']['id'] ?? null;
    }catch(e){
      return null;
    }
  }

  load(String id) {
    bloc.doAction(
        param: {
          'method': 'get',
          'reviewable_id': id,
          'perpage': PERPAGE,
          'url': REVIEWS_LIST_API,
          'type': type
        },
        supportLoading: false,
        supportErrorMsg: false,
        onNewState: (state) {
          this.state = state;
        });
  }
}
