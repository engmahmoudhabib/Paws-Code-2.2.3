import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:expandable/expandable.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/config/ApplicationCore.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/models/api/OrdersResponse.dart';
import 'package:flutter_app/providers/OrdersProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogsss/ChangeStatusDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
import 'package:flutter_app/ui/screen/home/articles/ArticalsScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MainScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyAccountScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyDogsCatsScreen.dart';
import 'package:flutter_app/ui/widget/AppBarWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldBorderedWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/BottomSliderWidget.dart';
import 'package:flutter_app/ui/widget/CheckBoxWidget.dart';
import 'package:flutter_app/ui/widget/CustomFilterWidget.dart';
import 'package:flutter_app/ui/widget/CustomFilterWidgetWrap.dart';
import 'package:flutter_app/ui/widget/CustomTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/DogCatSelectWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/MainSliderWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsLargeWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:html/parser.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_app/ui/widget/SlideAction.dart' as SlideAction;

import 'OrderDetailsScreen.dart';

class OrdersScreen extends StatefulWidget {
  static const String PATH = '/orders';

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends BaseStatefulState<OrdersScreen> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  dynamic enquiryTypes;

  ScrollController _scrollController =
      new ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    Future.delayed(
        Duration.zero, () => context.read(ordersProvider.notifier).load());
    status.value = false;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getCategories() {
    try {
      List t = copy(GetStorage().read('basics')['categories']);
      t.insert(0, {
        'id': 'all',
        'margin-left': 48.w,
        'selected': context.read(ordersProvider.notifier).tags == null,
        'name': AppFactory.getLabel('all', 'الكل'),
      });
      return t;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    preBuild(context);
    return handledWidget(AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Colors.white),
        child: Scaffold(
          backgroundColor: AppFactory.getColor('background', toString()),
          body: Stack(
            children: [
              KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
                return !isKeyboardVisible ? RightLeftWidget() : Container();
              }),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: AppFactory.getDimensions(
                            50, toString() + '-systemNavigationBarMargin')
                        .h,
                  ),
                  AppBarWidget('', (pageId) {
                    goTo(
                        HomeScreen.generatePath(
                          pageId: pageId,
                        ),
                        clearStack: true);
                  }),
                  Column(
                    children: [
                      SizedBox(
                        height: 10.h,
                      ),
                      TextResponsive(
                        'طلباتي',
                        style: TextStyle(
                          fontSize: 23,
                          color: const Color(0xff3876ba),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      buildSectionTitle('نوع الطلب', top: 0, bottom: 10.w),
                      Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsetsResponsive.only(left: 20, right: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CustomFilterWidget(
                                    onSelected: (data) {
                                      // context
                                      //   .read(ordersProvider.notifier)
                                      //  .filterByAnimalType(data['id']);
                                    },
                                    data: [
                                      {
                                        'id': 'all',
                                        'margin-left': 48.w,
                                        'selected': context
                                                .read(ordersProvider.notifier)
                                                .animalType ==
                                            null,
                                        'name':
                                            AppFactory.getLabel('all', 'الكل'),
                                      },
                                      {
                                        'id': 'materials',
                                        'margin-left': 48.w,
                                        'selected': context
                                                .read(ordersProvider.notifier)
                                                .animalType ==
                                            'dog',
                                        'name': AppFactory.getLabel(
                                            'materials', 'مواد و مستلزمات'),
                                      },
                                    ],
                                  ),
                                ),
                                /*  ValueListenableBuilder(
                                    valueListenable: status,
                                    builder: (context, value, child) => InkWell(
                                        onTap: () {
                                          status.value =
                                              status.value ? false : true;
                                        },
                                        child: Padding(
                                            padding:
                                                EdgeInsetsResponsive.all(4),
                                            child: !(status.value ?? false)
                                                ? Assets.icons.settings.svg(
                                                    width: 22.w, height: 22.w)
                                                : Assets.icons.selectedSettings
                                                    .svg(
                                                        width: 22.w,
                                                        height: 22.w)))),
                                SizedBox(
                                  width: 20.w,
                                )*/
                              ],
                            ),
                          ),
                          buildSectionTitle('حالة الطلب', bottom: 0, top: 10.w),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: CustomFilterWidgetWrap(
                                  onSelected: (data) {
                                    context
                                        .read(ordersProvider.notifier)
                                        .filterByTags(data);
                                  },
                                  isMulti: false,
                                  data: getStates(),
                                ),
                              ),
                              /*   ValueListenableBuilder(
                        valueListenable: status,
                        builder: (context, value, child) => InkWell(
                            onTap: () {
                              status.value = status.value ? false : true;
                            },
                            child: Padding(
                                padding: EdgeInsetsResponsive.all(4),
                                child: !(status.value ?? false)
                                    ? Assets.icons.settings
                                        .svg(width: 22.w, height: 22.w)
                                    : Assets.icons.selectedSettings
                                        .svg(width: 22.w, height: 22.w)))),*/
                            ],
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, watch, child) {
                        final response = watch(ordersProvider);
                        return response.when(idle: () {
                          return Container();
                        }, loading: () {
                          return ListView.builder(
                            shrinkWrap: true,
                            padding:
                                EdgeInsetsResponsive.only(bottom: 40, top: 10),
                            itemBuilder: (context, index) =>
                                ArticleLoaderItem(),
                            itemCount: 10,
                          );
                        }, data: (map) {
                          try {
                            OrdersResponse data = OrdersResponse.fromJson(map);
                            return (data.data?.length ?? 0) > 0
                                ? Container(
                                    width: 347.w,
                                    child: LazyLoadScrollView(
                                        onEndOfPage: () {
                                          context
                                              .read(ordersProvider.notifier)
                                              .loadMore(_scrollController);
                                        },
                                        scrollOffset: 10,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          padding: EdgeInsetsResponsive.only(
                                              bottom: 40, top: 10),
                                          itemBuilder: (context, index) =>
                                              Column(
                                            children: [
                                              index == 2
                                                  ? MainSliderWidget(
                                                      supportRound: true,
                                                    )
                                                  : Container(),
                                              Slidable(
                                                actionPane:
                                                    SlidableDrawerActionPane(),
                                                enabled: false,
                                                actionExtentRatio: 0.25,
                                                child: ServiceItem(
                                                  () {
                                                    goTo(OrderDetailsScreen
                                                        .generatePath(data
                                                                .data![index]
                                                                .id ??
                                                            ''));
                                                  },
                                                  data.data![index],
                                                  (number) {
                                                    launchCaller(number);
                                                  },
                                                ),
                                                actions: <Widget>[],
                                                secondaryActions: <Widget>[
                                                  SlideAction.IconSlideAction(
                                                    caption: 'تعديل',
                                                    onTap: () {},
                                                    color: AppFactory.getColor(
                                                            'primary',
                                                            toString())
                                                        .withOpacity(0.8),
                                                    icon: Icons.edit,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          itemCount: data.data?.length ?? 0,
                                        )))
                                : emptyWidget(msg: 'لايوجد طلبات');
                          } catch (e) {
                            return Text(e.toString());
                          }
                        }, error: (e) {
                          return Container();
                        });
                      },
                    ),
                  )
                ],
              ),
            ],
          ),
        )));
  }

  getStates() {
    List t = copy(GetStorage().read('basics')['enums']['order_statuses']);
    if (context.read(ordersProvider.notifier).tags != null)
      t.forEach((element) {
        element['selected'] = false;
        if (context.read(ordersProvider.notifier).tags['id'] == element['id'] &&
            context.read(ordersProvider.notifier).tags['selected']) {
          element['selected'] = true;
        }
      });

    t.insert(0, {
      'id': 'all',
      'margin-left': 48.w,
      'selected': context.read(ordersProvider.notifier).tags == null,
      'name': AppFactory.getLabel('all', 'الكل'),
    });
    return t;
  }
}

class ServiceItem extends StatelessWidget {
  final VoidCallback onTap;
  final OrdersResponseData item;
  final Function(String) onCall;

  ServiceItem(this.onTap, this.item, this.onCall);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsetsResponsive.only(top: 15),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Container(
              margin: EdgeInsets.only(right: 70.w),
              child: Assets.images.servicesIcBack.image(),
            ),
            Positioned(
              right: 6.w,
              top: 20.w,
              child: Container(
                  width: 90.w,
                  height: 90.w,
                  child: CircularProfileAvatar(
                    //  item.mainImage?.conversions?.large?.url ?? '',
                    '',
                    initialsText: TextResponsive(
                      item.id ?? '',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30),
                    ),
                    backgroundColor: AppFactory.getColor('primary', toString()),
                    borderWidth: 0,
                    radius: 1000.w,
                    placeHolder: (context, url) => ImageLoaderPlaceholder(),
                    borderColor: Colors.transparent,
                    elevation: 0,
                    foregroundColor: Colors.transparent,
                    cacheImage: true,
                    showInitialTextAbovePicture:
                        true, // setting it true will show initials text above profile picture, default false
                  )),
            ),
            Positioned.fill(
              right: 120.w,
              bottom: 15.w,
              left: 20.w,
              top: 9.w,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextResponsive(
                          'رقم الطلب' + '  ' + (item.id ?? ''),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1,
                            fontSize: AppFactory.getFontSize(15.0, toString()),
                            color: AppFactory.getColor('primary', toString()),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Flexible(
                        child: Row(
                          children: [
                            Container(
                              width: 7.0.w,
                              height: 8.0.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.elliptical(3.5.w, 4.0.w)),
                                  color: item.state?.id == 'pending' ||
                                          item.state?.id == 'processing' ||
                                          item.state?.id == 'shipping' ||
                                          item.state?.id == 'delivered'
                                      ? Colors.green
                                      : Colors.red),
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Flexible(
                              flex: 1,
                              child: TextResponsive(
                                item.state?.desc ?? '',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: item.state?.id == 'pending' ||
                                          item.state?.id == 'processing' ||
                                          item.state?.id == 'shipping' ||
                                          item.state?.id == 'delivered'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Flexible(
                              child: TextResponsive(
                                'السعر الكلي:${item.totalAmount?.formatted?.toString()}',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontFamily: 'roboto',
                                  fontSize:
                                      AppFactory.getFontSize(12.0, toString()),
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 1,
                        child: Row(
                          children: [
                            Assets.icons.calendar.svg(
                                width: 15.w,
                                height: 15.w,
                                color: Color(0xff3876ba)),
                            SizedBox(
                              width: 10.w,
                            ),
                            Flexible(
                              child: TextResponsive(
                                '${item.requestedAt}',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize:
                                      AppFactory.getFontSize(16.0, toString()),
                                  color: const Color(0xff3876ba),
                                ),
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
