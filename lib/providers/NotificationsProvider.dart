import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_riverpod/all.dart';

import 'SignInProvider.dart';

final notificationsProvider =
    StateNotifierProvider<CustomStateNotifier, ResultState>(
        (ref) => CustomStateNotifier(ref.watch(mainBlocProvider)));

class CustomStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;

  CustomStateNotifier(this.bloc) : super(ResultState.idle());
  dynamic data;
  String? category = 'general';
  dynamic tags;

  filterByTags(dynamic tags) {
    this.tags = tags;
    load();
  }

  filterCategory(String id) {
    if (id != 'all')
      category = id;
    else
      category = null;
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

  List<dynamic> allData = [];

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

  load() {
    bloc.doAction(
        param: {
          'method': 'get',
          'perpage': PERPAGE,
          'url': NOTIFICATIONS_API,
          'category': category,
        },
        supportLoading: false,
        supportDataHandler: false,
        supportErrorMsg: false,
        onResponse: (json) {
          allData = [];
          this.data = json;
          allData.addAll(data['data']);
        },
        onNewState: (state) {
          this.state = state;
        });
  }
}
