import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get_storage/get_storage.dart';

import 'SignInProvider.dart';

final offersProvider =
    StateNotifierProvider<CustomStateNotifier, ResultState>(
        (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

class CustomStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;

  CustomStateNotifier(this.bloc) : super(ResultState.idle());
  dynamic data;
  String? animalType;
  dynamic tags;

  filterByTags(dynamic tags) {
    this.tags = tags;
    load();
  }

  filterByAnimalType(String id) {
    if (id != 'all')
      animalType = id;
    else
      animalType = null;
    load();
  }

  addTags(Map param) {
    if (tags == null) {
      return null;
    }

    for (int i = 0; i < tags.length; i++) {
      if (tags[i]['selected']) param['tags[${i}]'] = tags[i]['id'];
    }
    return param;
  }


  load() {
    bloc.doAction(
        param: {
          'method': 'get',
          'perpage': PERPAGE,
          'url': OFFERS_API,

          'service_provider_id':AuthResponse.fromMap(GetStorage().read('account'))
        .data?.serviceProvider['id']??null
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

