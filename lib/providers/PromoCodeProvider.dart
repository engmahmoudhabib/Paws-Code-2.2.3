import 'package:flutter/cupertino.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/ApplicationCore.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_app/models/api/CartAction.dart';
import 'package:flutter_app/providers/CartDataProvider.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import 'SignInProvider.dart';
import 'package:flutter_riverpod/all.dart';

final promoCodeProvider =
    StateNotifierProvider<CustomStateNotifier, ResultState>(
        (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

class CustomStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;

  CustomStateNotifier(this.bloc) : super(ResultState.idle());

  removeFromCart(Map param) {
    bloc.doAction(
      param: {
        ...{
          'method': 'delete',
          'url': PROMO_CODE_API,
        },
        ...param
      },
      supportLoading: true,
      supportErrorMsg: true,
      onResponse: (json) {
        (GetIt.I<ApplicationCore>().getContext() as BuildContext)
            .read(cartDataProvider.notifier)
            .load();
      },
    );
  }

  applyToCart(Map param) {
    bloc.doAction(
      param: {
        ...{
          'method': 'post',
          'url': PROMO_CODE_API,
        },
        ...param
      },
      supportLoading: true,
      supportErrorMsg: true,
      onResponse: (json) {
        (GetIt.I<ApplicationCore>().getContext() as BuildContext)
            .read(cartDataProvider.notifier)
            .load();
      },
    );
  }
}
