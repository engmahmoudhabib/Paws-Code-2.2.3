import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/ApplicationCore.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/models/api/CartAction.dart';
import 'package:flutter_app/models/api/CartData.dart';
import 'package:flutter_app/models/api/ServiceDetails.dart';
import 'package:flutter_app/models/api/ServicesModel.dart';
import 'package:flutter_app/providers/CartActionsProvider.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import 'SignInProvider.dart';

final cartDataProvider =
    StateNotifierProvider<CustomStateNotifier, ResultState>(
        (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

class CustomStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;

  CustomStateNotifier(this.bloc) : super(ResultState.idle());
  dynamic data;
  dynamic tags;
  List<dynamic> allData = [];

  filterByTags(dynamic tags) {
    this.tags = tags;
    load();
  }

  addTags(Map param) {
    if (tags == null) {
      return null;
    }

    for (int i = 0; i < tags.length; i++) {
      if (tags[i]['selected']) param['services[${i}]'] = tags[i]['id'];
    }
    return param;
  }

  updateRatingState(bool newState) {
    try {
      data['data']['user_reactions']['is_reviewed'] = newState;
    } catch (e) {}
    state = ResultState.data(data: data);
  }

  removeItem(String id) {
    try {
      data['data']!.forEach((element) {
        if (element['id'].toString() == id) {
          data['data'].remove(element);
        }
      });
    } catch (e) {}
    state = ResultState.data(data: data);
  }

  updateFavoriteState(String id, bool newState) {
    try {
      data['data']!.forEach((element) {
        if (element['id'].toString() == id) {
          element['user_reactions']['is_favorited'] = newState;
        }
      });
    } catch (e) {
      data['data']['user_reactions']['is_favorited'] = newState;
    }
    state = ResultState.data(data: data);
  }

  load() {
    if (GetStorage().hasData('account') &&
        (AuthResponse.fromMap(GetStorage().read('account'))
                    .data!
                    .user!
                    .status!
                    .id ==
                'uncompleted' ||
            AuthResponse.fromMap(GetStorage().read('account'))
                    .data!
                    .user!
                    .status!
                    .id ==
                'unverified')) {
      return;
    }

    bloc.doAction(
        param: {
          'method': 'get',
          'url': CART_DATA_API,
        },
        supportLoading: false,
        supportErrorMsg: false,
        supportDataHandler: false,
        onResponse: (json) {
          CartData data = CartData.fromJson(json);

          try {
            if (data.data?.items?.length == 0) {
              (GetIt.I<ApplicationCore>().getContext() as BuildContext)
                  .read(cartActionsProvider.notifier)
                  .removeCart();
            } else {
              CartAction cartAction = CartAction();
              cartAction.isShow = true;
              cartAction.data = CartActionData(
                  cart: CartActionDataCart(
                      totalItems: data.data?.items?.length.toString() ?? ''));
              (GetIt.I<ApplicationCore>().getContext() as BuildContext)
                  .read(cartActionsProvider.notifier)
                  .setCart(cartAction);
            }
          } catch (e) {}
        },
        onNewState: (state) {
          this.state = state;
        });
  }
}
