import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/NotificationsResponse.dart';
import 'package:flutter_app/providers/NotificationsProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/EditAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/chat/MessagesScreen.dart';
import 'package:flutter_app/ui/screen/dogs/AddDogsCatsScreen.dart';
import 'package:flutter_app/ui/screen/dogs/DetailsScreen.dart';
import 'package:flutter_app/ui/widget/AppBarWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/BottomSliderWidget.dart';
import 'package:flutter_app/ui/widget/CustomFilterWidget.dart';
import 'package:flutter_app/ui/widget/FilterWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/MainSliderWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

import 'animals/AnimalsListScreen.dart';

class NotificationsScreen extends StatefulWidget {
  static const String PATH = '/home-notifications';

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends BaseStatefulState<NotificationsScreen> {
  TabController? _controller;

  @override
  void initState() {
    _controller = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
          padding: EdgeInsetsResponsive.only(bottom: 0, left: 10, right: 10),
          child: NestedScrollView(
            headerSliverBuilder: (context, value) {
              return [
                SliverToBoxAdapter(
                  child: TabBar(
                    indicatorColor: AppFactory.getColor('primary', toString()),
                    labelColor: AppFactory.getColor('primary', toString()),
                    labelStyle: TextStyle(
                      fontFamily: FontFamily.araHamahAlislam,
                      fontSize: 20.h,
                      color: const Color(0xff3876ba),
                    ),
                    controller: _controller,
                    tabs: [
                      Tab(
                        text: 'محادثاتي',
                      ),
                      Tab(
                        text: 'تنبيهاتي',
                      ),
                    ],
                  ),
                ),
              ];
            },
            body: Container(
              child: TabBarView(
                controller: _controller,
                children: <Widget>[
                  Container(
                    width: 310.w,
                    child: ListView.builder(
                      itemBuilder: (context, index) => InkWell(
                        onTap: () {
                          goTo(MessagesScreen.generatePath(),
                              transition: TransitionType.inFromRight);
                        },
                        child: Column(
                          children: [
                            Container(
                                margin: EdgeInsetsResponsive.only(
                                    top: 10, bottom: 10),
                                child: Row(
                                  children: [
                                    Container(
                                        width: 48.w,
                                        height: 48.w,
                                        child: CircularProfileAvatar(
                                          'https://avatars0.githubusercontent.com/u/8264639?s=460&v=4',
                                          backgroundColor: Colors.transparent,
                                          borderWidth: 0,
                                          borderColor: Colors.transparent,
                                          elevation: 3.0,
                                          foregroundColor: Colors.transparent,
                                          //sets foreground colour, it works if showInitialTextAbovePicture = true , default Colors.transparent
                                          cacheImage: true,
                                          // allow widget to cache image against provided url
                                          onTap: () {
                                            print('adil');
                                          },
                                          // sets on tap
                                          showInitialTextAbovePicture:
                                              true, // setting it true will show initials text above profile picture, default false
                                        )),
                                    SizedBox(
                                      width: 15.w,
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextResponsive(
                                          'حسن محمد',
                                          style: TextStyle(
                                            fontSize: AppFactory.getFontSize(
                                                21.0, toString()),
                                            color: AppFactory.getColor(
                                                'primary', toString()),
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                        TextResponsive(
                                          '20/2/2021',
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: const Color(0xff707070),
                                          ),
                                          textAlign: TextAlign.right,
                                        )
                                      ],
                                    )
                                  ],
                                )),
                            Container(
                              width: 323.w,
                              height: 0.2.w,
                              color: Colors.black.withOpacity(0.41),
                            )
                          ],
                        ),
                      ),
                      itemCount: 0,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                    ),
                  ),
                  NotificationsWidget(),
                ],
              ),
            ),
          )),
    );
  }
}

class NotificationsWidget extends StatefulWidget {
  @override
  _NotificationsWidgetState createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends BaseStatefulState<NotificationsWidget> {
  List dataFilter = [];

  @override
  void initState() {
    Future.delayed(Duration.zero,
        () => context.read(notificationsProvider.notifier).load());
    try {
      dataFilter = copy(
          GetStorage().read('basics')?['enums']?['notification_categories']);
      dataFilter.forEach((element) {
        if (context.read(notificationsProvider.notifier).category ==
            element['id']) element['selected'] = true;
      });
    } catch (e) {}
    super.initState();
  }

  ScrollController _scrollController =
      new ScrollController(keepScrollOffset: true);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsetsResponsive.only(top: 20),
          child: Row(
            children: [
              Expanded(
                child: CustomFilterWidget(
                  onSelected: (data) {
                    context
                        .read(notificationsProvider.notifier)
                        .filterCategory(data['id']);
                  },
                  isMulti: false,
                  data: dataFilter,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Consumer(
            builder: (context, watch, child) {
              final response = watch(notificationsProvider);
              return response.when(idle: () {
                return Container();
              }, loading: () {
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsetsResponsive.only(bottom: 40, top: 10),
                  itemBuilder: (context, index) => ArticleLoaderItem(),
                  itemCount: 10,
                );
              }, data: (map) {
                NotificationsResponse data =
                    NotificationsResponse.fromJson(map);

                return (data.data?.length ?? 0) > 0
                    ? LazyLoadScrollView(
                        onEndOfPage: () {
                          context
                              .read(notificationsProvider.notifier)
                              .loadMore(_scrollController);
                        },
                        scrollOffset: 10,
                        child: ListView.builder(
                          shrinkWrap: true,
                          controller: _scrollController,
                          padding:
                              EdgeInsetsResponsive.only(bottom: 40, top: 10),
                          itemBuilder: (context, index) =>
                              NotificationItem(data.data![index], () {
                            //   goTo(ArticleDetailsScreen.generatePath(),
                            //  transition: TransitionType.inFromTop,
                            //  data: data.data![index]);
                          }, () {
                            GetIt.I<APIRepository>().showConfirmDialog(
                                'هل تريد الحذف بالتأكيد', onDone: () {
                              apiBloc.doAction(
                                  param: BaseStatefulState.addServiceInfo(Map(),
                                      data: {
                                        'method': 'delete',
                                        'url': 'v1/notifications/' +
                                            data.data![index].id.toString(),
                                      }),
                                  supportLoading: true,
                                  supportErrorMsg: false,
                                  onResponse: (json) {
                                    if (isSuccess(json)) {
                                      Future.delayed(
                                          Duration.zero,
                                          () => context
                                              .read(notificationsProvider
                                                  .notifier)
                                              .load());
                                    }
                                  });
                            });
                          }),
                          itemCount: data.data!.length,
                        ))
                    : emptyWidget(msg: 'لايوجد اشعارات حاليا');
              }, error: (e) {
                return Container();
              });
            },
          ),
        ),
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  final NotificationsResponseData data;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  NotificationItem(this.data, this.onTap, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          color: Colors.white,
          elevation: 5,
          margin: EdgeInsetsResponsive.only(
              left: 10, right: 10, top: 20, bottom: 5),
          child: Padding(
              padding: EdgeInsetsResponsive.all(10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextResponsive(
                    data.text ?? '',
                    style: TextStyle(
                      fontSize: 18,
                      color: const Color(0xff707070),
                    ),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 20.w,
                  ),
                  Row(
                    children: [
                      Assets.icons.calendar.svg(
                        width: 12.w,
                        color: Color(0xff3876BA),
                        height: 12.w,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      TextResponsive(
                        data.createdAt?.human ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xff3876ba),
                        ),
                        textAlign: TextAlign.right,
                      )
                    ],
                  )
                ],
              )),
        ),
        Positioned(
          left: 0,
          top: 15.w,
          child: InkWell(
            onTap: onRemove,
            child: SvgPicture.string(
              '<svg viewBox="19.0 111.0 20.1 20.1" ><path transform="translate(15.63, 107.63)" d="M 13.4375 3.375 C 7.878936290740967 3.375 3.375 7.878936290740967 3.375 13.4375 C 3.375 18.99606513977051 7.878936290740967 23.5 13.4375 23.5 C 18.99606513977051 23.5 23.5 18.99606513977051 23.5 13.4375 C 23.5 7.878935813903809 18.99606513977051 3.375 13.4375 3.375 Z M 15.98698997497559 17.08031845092773 L 13.4375 14.53082847595215 L 10.88801002502441 17.08031845092773 C 10.58806991577148 17.38025856018066 10.0946216583252 17.38025856018066 9.794681549072266 17.08031845092773 C 9.644710540771484 16.93034934997559 9.567306518554688 16.73200035095215 9.567306518554688 16.53365325927734 C 9.567306518554688 16.33530616760254 9.644710540771484 16.13695907592773 9.794681549072266 15.98698997497559 L 12.34416961669922 13.4375 L 9.794679641723633 10.88801002502441 C 9.644710540771484 10.73804092407227 9.567306518554688 10.53969192504883 9.567306518554688 10.34134674072266 C 9.567306518554688 10.14299774169922 9.644710540771484 9.944650650024414 9.794679641723633 9.794681549072266 C 10.09461975097656 9.494741439819336 10.58806991577148 9.494741439819336 10.88801002502441 9.794681549072266 L 13.43749809265137 12.34417152404785 L 15.98698806762695 9.794681549072266 C 16.28692817687988 9.494741439819336 16.7803783416748 9.494741439819336 17.0803165435791 9.794681549072266 C 17.38025665283203 10.0946216583252 17.38025665283203 10.58806991577148 17.0803165435791 10.88801193237305 L 14.53082847595215 13.4375 L 17.08031845092773 15.98698997497559 C 17.38025856018066 16.28693008422852 17.38025856018066 16.7803783416748 17.08031845092773 17.08031845092773 C 16.7803783416748 17.38509559631348 16.28693008422852 17.38509559631348 15.98698997497559 17.08031845092773 Z" fill="#feca2e" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
          ),
        )
      ],
    );
  }
}
