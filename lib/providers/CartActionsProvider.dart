import 'package:flutter/cupertino.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/ApplicationCore.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_app/models/api/CartAction.dart';
import 'package:flutter_app/ui/screen/cart/CartScreen.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import 'CartDataProvider.dart';
import 'SignInProvider.dart';

final cartActionsProvider =
    StateNotifierProvider<CustomStateNotifier, ResultState>(
        (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

class CustomStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;
  Map<String, dynamic> shippingParam = Map();

  CustomStateNotifier(this.bloc)
      : super(GetStorage().hasData('cart')
            ? ResultState.data(
                data: CartAction.fromJson(GetStorage().read('cart')))
            : ResultState.idle());

  showCart() {
    state.maybeWhen(
        data: (data) {
          (data as CartAction).isShow = true;
          state = ResultState.data(data: data);
        },
        orElse: () {});
  }

  hiddenCart() {
    state.maybeWhen(
        data: (data) {
          (data as CartAction).isShow = false;
          state = ResultState.data(data: data);
        },
        orElse: () {});
  }

  removeCart() {
    GetStorage().remove('cart');
    state = ResultState.idle();
    GetIt.I<ApplicationCore>().goTo(
      HomeScreen.generatePath(pageId: 'home'),
      clearStack: true,
    );
  }

  submitCart() {
    bloc.doAction(
        param: {
          'method': 'post',
          'url': CART_SUBMIT_API,
        },
        supportLoading: true,
        supportErrorMsg: true,
        onResponse: (json) {
          if (json['message']['type'] == 'success') {
            GetIt.I<APIRepository>().showSuccessDialog(json['message']['text']);

            removeCart();
          } else {
            GetIt.I<APIRepository>().showErrorDialog(json['message']['text']);
          }
        });
  }

  setShippingAddress() {
    bloc.doAction(
      param: {
        ...{
          'method': 'post',
          '_method': 'put',
          'url': SHIPPING_ADDRESS_API,
        },
        ...shippingParam
      },
      supportLoading: true,
      onResponse: (json) {
        (GetIt.I<ApplicationCore>().getContext() as BuildContext)
            .read(cartDataProvider.notifier)
            .load();
      },
      supportErrorMsg: true,
    );
  }

  removeFromCart(id) {
    bloc.doAction(
      param: {
        'method': 'delete',
        'url': REMOVE_ITEM_CART_API + id,
      },
      supportLoading: true,
      onResponse: (json) {
        GetStorage().write('cart', json);
        state =
            ResultState.data(data: CartAction.fromJson(json)..isShow = false);
        (GetIt.I<ApplicationCore>().getContext() as BuildContext)
            .read(cartDataProvider.notifier)
            .load();
      },
      supportErrorMsg: true,
    );
  }

  addToCart(Map param, {bool supportNav = false}) {
    bloc.doAction(
      param: {
        ...{
          'method': 'post',
          'url': CART_API,
        },
        ...param
      },
      supportLoading: true,
      supportErrorMsg: true,
      onResponse: (json) {
        GetStorage().write('cart', json);
        state =
            ResultState.data(data: CartAction.fromJson(json)..isShow = true);
        (GetIt.I<ApplicationCore>().getContext() as BuildContext)
            .read(cartDataProvider.notifier)
            .load();
        if (supportNav) {
          GetIt.I.get<ApplicationCore>().goTo(CartScreen.generatePath());
        }
      },
    );
  }

  setCart(CartAction cartAction) {
    GetStorage().write('cart', cartAction.toJson());
    state = ResultState.data(data: cartAction);
  }
}
