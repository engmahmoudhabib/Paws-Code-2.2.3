import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ApiResult.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/bloc/ApiBloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

final mainBlocProvider = Provider<ApiBloc>((ref) {
  print('[ApiBloc][Provider][Create]');
  return ApiBloc();
});

final signInProvider =
    StateNotifierProvider.autoDispose<ProfileStateNotifier, ResultState>(
        (ref) => ProfileStateNotifier(ref.watch(mainBlocProvider)));

class ProfileStateNotifier extends StateNotifier<ResultState> {
  ApiBloc bloc;

  ProfileStateNotifier(this.bloc) : super(ResultState.idle());

  fetchProfile() {
    bloc.doAction(
        param: {
          'method': 'post',
          'url': 'member-info_v2',
        },
         supportLoading: false,
        supportErrorMsg: false,
        onNewState: (state) {
          this.state = state;
        });
  }
}
