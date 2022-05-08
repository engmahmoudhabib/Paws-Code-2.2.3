import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/models/api/ProductsReponse.dart';
import 'package:flutter_riverpod/all.dart';

import 'SignInProvider.dart';

final productsProvider =
    StateNotifierProvider<CustomStateNotifier, ResultState>(
        (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

final productsDetailsProvider =
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
    if (tags == null) {
      return param;
    }

    print(tags);
    try {
      if (tags['children'].length == 0) {
        Map<String, dynamic> openingHours = Map();
        var items = <int>[];
        items.add(tags['id']);
        param['categories[${tags['id'].toString()}]'] = 'null';
        return param;
      }
    } catch (e) {}

    Map<String, dynamic> openingHours = Map();

    for (int i = 0; i < tags.length; i++) {
      var items = <int>[];

      if (openingHours[tags[i]['parent'].toString()] == null)
        openingHours[tags[i]['parent'].toString()] = [];

      if (tags[i]['selected']) {
        items.add(tags[i]['id']);
        openingHours[tags[i]['parent'].toString()].add(tags[i]['id']);
      }
    }

    for (var entry in openingHours.entries) {
      List t = entry.value as List;
      int i = 0;

      t.forEach((element) {
        param['categories[${entry.key}][${i}]'] = int.parse(element.toString());
        i++;
      });
    }

    return param;
  }

  getDetails(String id, {Function(ProductDataDetails)? onResponse}) {
    if (id.length == 0) return;

    bloc.doAction(
        param: {
          'method': 'get',
          'url': PRODUCTS_LIST_API + '/' + id,
        },
        supportLoading: false,
        supportErrorMsg: false,
        onResponse: (data) {
          try {
            if (onResponse != null) {
              onResponse.call(ProductDataDetails.fromMap(data));
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

  load({String favorite = '' }) {
    bloc.doAction(
        param: addTags({
          'method': 'get',
          'animal_type':  animalType  ,
          'perpage': PERPAGE,
          'url': PRODUCTS_LIST_API,
          'in_favorites': favorite.length > 0 ? true : null,
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
