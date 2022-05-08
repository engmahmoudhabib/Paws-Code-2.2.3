import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/models/api/ProductsReponse.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:get_storage/get_storage.dart';

import 'SignInProvider.dart';

final animalsProvider = StateNotifierProvider<CustomStateNotifier, ResultState>(
    (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

final animalsDetailsProvider =
    StateNotifierProvider.autoDispose<CustomStateNotifier, ResultState>(
        (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

class CustomStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;

  CustomStateNotifier(this.bloc) : super(ResultState.idle());
  dynamic data;
  dynamic tags;
  List<dynamic> allData = [];
  String? animalType;

  filterByTags(dynamic tags, {String? idBreeder}) {
    this.tags = tags;
    load(idBreeder: idBreeder);
  }

  filterByAnimalType(String id) {
    if (id != 'all')
      animalType = id;
    else
      animalType = null;
    load();
  }

  addTags(Map<String, dynamic> param,
      {String favorite = '', String? idBreeder, String? animalType}) {
    if (tags == null || favorite.length > 0) {
      return param;
    }

    for (int i = 0; i < tags.length; i++) {
      if (tags[i]?['selected'] ?? false) param['status[${i}]'] = tags[i]['id'];
    }

    return param;
  }

  getDetails(String id, {Function(ProductDataDetails)? onResponse}) {
    if (id.length > 0) {
      bloc.doAction(
          param: {
            'method': 'get',
            'url': ANIMALS_LIST_API + '/' + id,
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
            try {
              this.state = state;
            } catch (e) {}
          });
    }
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
      data['data']['reactions']['is_reviewed'] = newState;
    } catch (e) {}
    state = ResultState.data(data: data);
  }

  updateFavoriteState(String id, bool newState) {
    try {
      data['data']!.forEach((element) {
        if (element['id'].toString() == id) {
          element['reactions']['is_favorited'] = newState;
        }
      });
    } catch (e) {
      data['data']['reactions']['is_favorited'] = newState;
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

  load({String favorite = '', String? idBreeder, String? animalType}) {
    if (animalType != null) this.animalType = animalType;
    bloc.doAction(
        param: addTags({
          'method': 'get',
          'animal_type':
              idBreeder == null ? animalType ?? this.animalType : null,
          'current_breeder_id': idBreeder,
          'species_id': idBreeder == null && favorite.length == 0
              ? GetStorage().read('filter-species-id')
              : null,
          'perpage': PERPAGE,
          'months': idBreeder == null && favorite.length == 0
              ? GetStorage().read('filter-month') != null
                  ? GetStorage()
                      .read('filter-month')
                      .toString()
                      .replaceFirst('.0', '')
                  : null
              : null,
          'years': idBreeder == null && favorite.length == 0
              ? GetStorage().read('filter-year') != null
                  ? GetStorage()
                      .read('filter-year')
                      .toString()
                      .replaceFirst('.0', '')
                  : null
              : null,
          'governorate_id': idBreeder == null && favorite.length == 0
              ? GetStorage().read('filter-city-id')
              : null,
          'url': ANIMALS_LIST_API,
          'in_favorites': favorite.length > 0 ? true : null,
        }, animalType: animalType, idBreeder: idBreeder, favorite: favorite),
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
