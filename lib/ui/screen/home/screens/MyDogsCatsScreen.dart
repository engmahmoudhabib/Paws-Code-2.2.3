import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/AnimalsListData.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/providers/AnimalsProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/EditAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
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
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:flutter_app/ui/widget/SlideAction.dart' as SlideAction;

import '../HomeScreen.dart';
import 'animals/AnimalsListScreen.dart';

class MyDogsCatsScreen extends StatefulWidget {
  static const String PATH = '/home-dogs-cats';

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _MyDogsCatsScreenState createState() => _MyDogsCatsScreenState();
}

class _MyDogsCatsScreenState extends BaseStatefulState<MyDogsCatsScreen> {
  AuthResponse? authResponse;
  TabController? _controller;

  @override
  void initState() {
    authResponse = AuthResponse.fromMap(GetStorage().read('account'));
    // context.read(animalsProvider.notifier).tags = [];
    Future.delayed(Duration.zero, () {
      context.read(animalsProvider.notifier).tags = null;
      context
          .read(animalsProvider.notifier)
          .load(idBreeder: authResponse?.data?.user?.id?.toString() ?? null);
    });
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
      child: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [
            SliverToBoxAdapter(
                child: SizedBox(
              height: 20.h,
            )),
            SliverToBoxAdapter(
                child: Center(
              child: Wrap(
                children: [
                  InkWell(
                    onTap: () {
                      goTo(AddDogsCatsScreen.generatePath());
                    },
                    child: Container(
                      padding: EdgeInsetsResponsive.only(
                          left: 10, right: 10, top: 3, bottom: 5),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          SvgPicture.string(
                            '<svg viewBox="332.8 112.0 12.9 12.9" ><path transform="translate(323.85, 103.04)" d="M 21.02638244628906 14.59523010253906 L 16.19676208496094 14.59523010253906 L 16.19676208496094 9.765609741210938 C 16.19676208496094 9.325188636779785 15.83641719818115 8.96484375 15.39599609375 8.96484375 C 14.95557498931885 8.96484375 14.59523010253906 9.325188636779785 14.59523010253906 9.765609741210938 L 14.59523010253906 14.59523010253906 L 9.765609741210938 14.59523010253906 C 9.325188636779785 14.59523010253906 8.96484375 14.95557498931885 8.96484375 15.39599609375 C 8.96484375 15.61620712280273 9.054929733276367 15.81639862060547 9.200069427490234 15.96153736114502 C 9.345207214355469 16.10667610168457 9.545398712158203 16.19676208496094 9.765609741210938 16.19676208496094 L 14.59523010253906 16.19676208496094 L 14.59523010253906 21.02638244628906 C 14.59523010253906 21.2465934753418 14.68531608581543 21.44678497314453 14.8304557800293 21.59192276000977 C 14.97559452056885 21.73706436157227 15.17578601837158 21.8271484375 15.39599609375 21.8271484375 C 15.83641719818115 21.8271484375 16.19676208496094 21.46680450439453 16.19676208496094 21.02638244628906 L 16.19676208496094 16.19676208496094 L 21.02638244628906 16.19676208496094 C 21.46680450439453 16.19676208496094 21.8271484375 15.83641719818115 21.8271484375 15.39599609375 C 21.8271484375 14.95557498931885 21.46680450439453 14.59523010253906 21.02638244628906 14.59523010253906 Z" fill="#3876ba" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                            allowDrawingOutsideViewBox: true,
                            fit: BoxFit.fill,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          TextResponsive(
                            AppFactory.getLabel(
                                'add_dog_cat', 'إضافة قط أو كلب'),
                            style: TextStyle(
                              fontSize: 20.0,
                              color: AppFactory.getColor('primary', toString()),
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(23.0.w),
                        color: AppFactory.getColor('orange', toString())
                            .withOpacity(0.3),
                        border: Border.all(
                          width: 1.0,
                          color: AppFactory.getColor('primary', toString()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )),
            SliverToBoxAdapter(
                child: SizedBox(
              height: 20.h,
            )),
            SliverToBoxAdapter(
                child: Row(
              children: [
                Container(
                  width: 330.w,
                  child: CustomFilterWidget(
                    onSelected: (data) {
                      context.read(animalsProvider.notifier).filterByTags(data,
                          idBreeder: authResponse?.data?.user?.id?.toString());
                    },
                    isMulti: true,
                    data: getStates(),
                  ),
                ),
              ],
            )),
            SliverToBoxAdapter(
                child: SizedBox(
              height: 20.h,
            )),
            SliverToBoxAdapter(
              //authResponse!.data!.accountType!.id == '3' ||
              //                       authResponse!.data!.accountType!.id == 'service_provider'
              child: false
                  ? Padding(
                      padding: EdgeInsetsResponsive.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TabBar(
                                  indicatorColor: AppFactory.getColor(
                                      'primary', toString()),
                                  labelColor: AppFactory.getColor(
                                      'primary', toString()),
                                  labelStyle: TextStyle(
                                    fontFamily: FontFamily.araHamahAlislam,
                                    fontSize: 16.h,
                                    color: const Color(0xff3876ba),
                                  ),
                                  controller: _controller,
                                  tabs: [
                                    Tab(
                                      text: 'قططي و كلابي',
                                    ),
                                    Tab(
                                      text: 'قطط و كلاب زبائن المركز',
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  goTo(HomeScreen.generatePath(pageId: 'home'));
                                },
                                child: Container(
                                  margin: EdgeInsetsResponsive.only(
                                      left: 5, right: 5),
                                  padding: EdgeInsetsResponsive.all(5),
                                  child: Assets.icons.iconIonicIosArrowRoundBack
                                      .svg(
                                          color: AppFactory.getColor(
                                              'primary', toString()),
                                          width: AppFactory.getDimensions(
                                                  20, toString())
                                              .w,
                                          height: AppFactory.getDimensions(
                                                  14, toString())
                                              .h),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsResponsive.only(
                                left: 5, right: 5, top: 20),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                BtnStyle1(
                                  'بحث بالصفحة حسب الباركود أو الاسم',
                                  Assets.icons.iconFeatherSearch
                                      .svg(width: 12.w, height: 12.w),
                                ),
                                BtnStyle1(
                                  'اضافة ملاحظة او تنبيه لقطط و كلاب الزبائن',
                                  Assets.icons.iconIonicIosAddCircleOutline
                                      .svg(width: 12.w, height: 12.w),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : Container(),
            ),
          ];
        },
        body: Container(
          child: TabBarView(
            controller: _controller,
            children: <Widget>[ListDataWidget(), Container()],
          ),
        ),
      ),
    );
  }
}

class ListDataWidget extends StatefulWidget {
  @override
  _ListDataWidgetState createState() => _ListDataWidgetState();
}

class _ListDataWidgetState extends BaseStatefulState<ListDataWidget> {
  ScrollController _scrollController =
      new ScrollController(keepScrollOffset: true);

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final response = watch(animalsProvider);
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
          try {
            AnimalsListData data = AnimalsListData.fromJson(map);
            return Container(
                width: 347.w,
                child: LazyLoadScrollView(
                    onEndOfPage: () {
                      context
                          .read(animalsProvider.notifier)
                          .loadMore(_scrollController);
                    },
                    scrollOffset: 10,
                    child: ListView.builder(
                      key: PageStorageKey<String>('controllerA'),
                      controller: _scrollController,
                      shrinkWrap: true,
                      padding: EdgeInsetsResponsive.only(
                          bottom: 40, top: 10, left: 20, right: 20),
                      itemBuilder: (context, index) => Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: CatDogItem(data.data![index], () {
                          goTo(
                              DetailsScreen.generatePath(
                                  data.data![index].id.toString()),
                              transition: TransitionType.inFromRight);
                        }, index),
                        actions: <Widget>[
                          SlideAction.IconSlideAction(
                            caption: 'تعديل',
                            onTap: () {
                              goTo(AddDogsCatsScreen.generatePath(
                                  id: data.data![index].id));
                            },
                            color: AppFactory.getColor('primary', toString())
                                .withOpacity(0.8),
                            icon: Icons.edit,
                          ),
                        ],
                        secondaryActions: <Widget>[],
                      ),
                      itemCount: data.data?.length ?? 0,
                    )));
          } catch (e) {
            return Text(e.toString());
          }
        }, error: (e) {
          return Container();
        });
      },
    );
  }
}

class BtnStyle1 extends StatelessWidget {
  final String name;
  final Widget icon;

  BtnStyle1(this.name, this.icon);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsResponsive.only(left: 10, right: 10),
      constraints: BoxConstraints(minHeight: 33.h, minWidth: 144.w),
      child: Row(
        children: [
          icon,
          SizedBox(
            width: 10.w,
          ),
          TextResponsive(
            name,
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xffffffff),
            ),
            textAlign: TextAlign.right,
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23.0),
        color: const Color(0xff3876ba),
        border: Border.all(width: 1.0, color: const Color(0xff3876ba)),
      ),
    );
  }
}

class CatDogItem extends StatelessWidget {
  final VoidCallback onTap;
  final int index;
  final AnimalsListDataData item;

  CatDogItem(this.item, this.onTap, this.index);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsetsResponsive.only(top: 15),
        child: Opacity(
            opacity: index == 100000 ? 0.6 : 1,
            child: Stack(
              fit: StackFit.passthrough,
              children: [
                Container(
                    margin: EdgeInsets.only(right: 5.w),
                    child: Assets.images.box1.image()),
                Positioned(
                  right: 0.w,
                  top: 7.w,
                  child: Container(
                    padding: EdgeInsetsResponsive.all(4),
                    width: 84.w,
                    height: 84.w,
                    child: CircularProfileAvatar(
                      item.avatar?.conversions?.large?.url ?? '',
                      backgroundColor: Colors.transparent,
                      borderWidth: 0,
                      radius: 1000.w,
                      placeHolder: (context, url) => ImageLoaderPlaceholder(),
                      borderColor: Colors.transparent,
                      elevation: 3.0,
                      foregroundColor: Colors.transparent,
                      cacheImage: true,
                      showInitialTextAbovePicture:
                          true, // setting it true will show initials text above profile picture, default false
                    ),
                  ),
                ),
                Positioned.fill(
                  right: 90.w,
                  bottom: 15.w,
                  left: 20.w,
                  top: 9.w,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextResponsive(
                        item.name ?? '',
                        style: TextStyle(
                          fontSize: AppFactory.getFontSize(21.0, toString()),
                          color: AppFactory.getColor('primary', toString()),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          item.status?.id == 'normal'
                              ? SizedBox()
                              : Row(
                                  children: [
                                    Container(
                                      width: 7.0.w,
                                      height: 8.0.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(3.5.w, 4.0.w)),
                                          color: statusColor[item.status?.id] ??
                                              Colors.green),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    TextResponsive(
                                      item.status?.desc ?? '',
                                      style: TextStyle(
                                          fontSize: AppFactory.getFontSize(
                                              16.0, toString()),
                                          color: statusColor[item.status?.id] ??
                                              Colors.green),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                          TextResponsive(
                            item.code ?? '',
                            style: TextStyle(
                              fontSize:
                                  AppFactory.getFontSize(15.0, toString()),
                              color: AppFactory.getColor('gray_1', toString()),
                            ),
                            textAlign: TextAlign.right,
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}
