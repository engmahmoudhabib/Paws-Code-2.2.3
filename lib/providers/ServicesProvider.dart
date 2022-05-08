import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_app/models/api/ServiceDetails.dart';
import 'package:flutter_app/models/api/ServicesModel.dart';
import 'package:flutter_riverpod/all.dart';

import 'SignInProvider.dart';

final servicesProvider =
    StateNotifierProvider<CustomStateNotifier, ResultState>(
        (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

final servicesDetailsProvider =
    StateNotifierProvider.autoDispose<CustomStateNotifier, ResultState>(
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

  getDetails(String id, {Function(ServiceDetails)? onResponse}) {
    if (id.length > 0) {
      bloc.doAction(
          param: {
            'method': 'get',
            'url': SERVICE_DETAILS_API + id,
          },
          supportLoading: false,
          supportErrorMsg: false,
          onResponse: (data) {
            try {
              if (onResponse != null) {
                onResponse.call(ServiceDetails.fromMap(data));
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

  load({String favorite = ''}) {
    bloc.doAction(
        param: {
          'method': 'get',
          'perpage': PERPAGE,
          'url': SERVICES_LIST_API,
          'services': addTags(Map()),
          'in_favorites': favorite.length > 0,
        },
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
