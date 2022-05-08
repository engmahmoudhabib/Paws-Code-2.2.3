import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/models/api/OrderDetailsResponse.dart';
import 'package:flutter_app/models/api/ProductsReponse.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get_it/get_it.dart';

import 'SignInProvider.dart';

final ordersProvider = StateNotifierProvider<CustomStateNotifier, ResultState>(
    (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

final ordersDetailsProvider =
    StateNotifierProvider.autoDispose<CustomStateNotifier, ResultState>(
        (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

class CustomStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;

  CustomStateNotifier(this.bloc) : super(ResultState.idle());
  dynamic data;
  dynamic tags;
  List<dynamic> allData = [];
  String? animalType;

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

  addTags(Map<String, dynamic> param) {
    if (tags == null || tags['id'] == 'all') {
      param.remove('status');
      return param;
    }

    print(tags);
    param['status'] = tags['id'];
    Map<String, dynamic> openingHours = Map();

    return param;
  }

  getDetails(String id, {Function(OrderDetailsResponse)? onResponse}) {
    if (id.length == 0) return;

    bloc.doAction(
        param: {
          'method': 'get',
          'url': ORDERS_LIST_API + '/' + id,
        },
        supportLoading: false,
        supportErrorMsg: false,
        onResponse: (data) {
          try {
            if (onResponse != null) {
              onResponse.call(OrderDetailsResponse.fromJson(data));
            }
          } catch (e) {}
          this.data = data;
        },
        onNewState: (state) {
          this.state = state;
        });
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

  updateRatingState(bool newState) {
    try {
      data['data']['user_reactions']['is_reviewed'] = newState;
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

  loadMore(ScrollController _scrollController) {
    try {
      if ((data['links']?['next'] ?? null) == null) {
        return;
      }
      bloc.doAction(
          param: {
            'method': 'get',
            'full-url': data['links']['next'],
          },
          supportLoading: false,
          supportErrorMsg: false,
          supportDataHandler: false,
          onResponse: (json) {
            this.data = json;
            allData.addAll(data['data']);
            this.data['data'] = allData;
          },
          onNewState: (state) {
            this.state = state;
            Timer(
              Duration(microseconds: 500),
              () {
                if (_scrollController.hasClients) {
                  _scrollController
                      .jumpTo(_scrollController.position.maxScrollExtent);
                }
              },
            );
          });
    } catch (e) {}
  }

  cancelOrder(id) {
    bloc.doAction(
        param: {
          'method': 'post',
          'url': ORDERS_LIST_API + '/' + id + '/cancel',
        },
        supportLoading: true,
        supportErrorMsg: true,
        onResponse: (json) {
          if (json['message']['type'] == 'success') {
            GetIt.I<APIRepository>().showSuccessDialog(json['message']['text']);
            getDetails(id);
          } else {
            GetIt.I<APIRepository>().showErrorDialog(json['message']['text']);
          }
        });
  }

  load({String favorite = ''}) {
    bloc.doAction(
        param: addTags({
          'method': 'get',
          'perpage': PERPAGE,
          'url': ORDERS_LIST_API,
        }),
        supportLoading: false,
        supportErrorMsg: false,
        supportDataHandler: false,
        onResponse: (json) {
          allData = [];
          print(json);
          this.data = json;
          allData.addAll(data['data']);
        },
        onNewState: (state) {
          this.state = state;
        });
  }
}
