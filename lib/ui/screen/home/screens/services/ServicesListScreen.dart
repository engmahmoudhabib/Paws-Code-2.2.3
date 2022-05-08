import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
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
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_app/models/api/ServicesModel.dart';
import 'package:flutter_app/providers/ArticlesProvider.dart';
import 'package:flutter_app/providers/ServicesProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/EditAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/chat/MessagesScreen.dart';
import 'package:flutter_app/ui/screen/dogs/AddDogsCatsScreen.dart';
import 'package:flutter_app/ui/screen/dogs/DetailsScreen.dart';
import 'package:flutter_app/ui/screen/info/InfoScreen.dart';
import 'package:flutter_app/ui/screen/services/ActivateServicesScreen.dart';
import 'package:flutter_app/ui/screen/services/ServiceDetailsScreen.dart';
import 'package:flutter_app/ui/widget/AppBarWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/BottomSliderWidget.dart';
import 'package:flutter_app/ui/widget/CustomFilterWidget.dart';
import 'package:flutter_app/ui/widget/CustomFilterWidgetWrap.dart';
import 'package:flutter_app/ui/widget/FilterWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/ImagePickerWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/MainSliderWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/SlideAction.dart' as SlideAction;
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_app/ui/widget/date_piker/src/date_format.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shimmer/shimmer.dart';

import '../../HomeScreen.dart';

class ServicesListWidget extends StatefulWidget {
  ServicesListWidget(this.showServiceDetails, this.favorite, {this.initialId});

  final String favorite;
  final String? initialId;

  final ValueNotifier<bool> showServiceDetails;

  @override
  _ServicesListWidgetState createState() => _ServicesListWidgetState();
}

class _ServicesListWidgetState extends BaseStatefulState<ServicesListWidget> {
  late List<dynamic> tags;
  DataBean? selectedService;
  ScrollController _scrollController =
      new ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      context.read(servicesProvider.notifier).tags = null;
      context.read(servicesProvider.notifier).load(favorite: widget.favorite);
    });
    try {
      if (widget.initialId != null) {
        selectedService = DataBean(
          int.parse(widget.initialId ?? '0'),
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
          null,
        );
        widget.showServiceDetails.value = true;
      }
    } catch (e) {}

    status.value = false;
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  getStates() {
    try {
      List t = copy(GetStorage().read('basics')['enums']['service_types']);
      if (context.read(servicesProvider.notifier).tags != null)
        for (var element in t) {
          element['selected'] = false;

          for (var tag in context.read(servicesProvider.notifier).tags) {
            if ((tag['id'] == element['id']) && tag['selected']) {
              //   element['selected'] = true;
            }
          }
        }

      /* t.insert(0, {
        'id': 'all',
        'margin-left': 48.w,
        'selected': context.read(animalsProvider.notifier).tags == null,
        'name': AppFactory.getLabel('all', 'الكل'),
      });*/
      return t;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.showServiceDetails,
      builder: (context, value, child) => Container(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: widget.favorite.length == 0 ? 20.h : 0,
          ),
          !widget.showServiceDetails.value && widget.favorite.length == 0
              ? Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: CustomFilterWidgetWrap(
                        onSelected: (data) {
                          context
                              .read(servicesProvider.notifier)
                              .filterByTags(data);
                        },
                        isMulti: true,
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
              : Container(),
          SizedBox(
            height: widget.favorite.length == 0 ? 10.h : 0,
          ),
          widget.showServiceDetails.value
              ? Expanded(
                  child: ServiceDetailsScreen(
                  selectedService?.id.toString() ?? '',
                  onBack: () {
                    widget.showServiceDetails.value = false;
                  },
                ))
              : Expanded(
                  child: Consumer(
                    builder: (context, watch, child) {
                      final response = watch(servicesProvider);
                      return response.when(idle: () {
                        return Container();
                      }, loading: () {
                        return ListView.builder(
                          shrinkWrap: true,
                          padding:
                              EdgeInsetsResponsive.only(bottom: 40, top: 30),
                          itemBuilder: (context, index) => ArticleLoaderItem(),
                          itemCount: 10,
                        );
                      }, data: (map) {
                        try {
                          ServicesModel data = ServicesModel.fromMap(map);
                          return (data.data?.length ?? 0) > 0
                              ? Container(
                                  width: 347.w,
                                  child: LazyLoadScrollView(
                                      onEndOfPage: () {
                                        context
                                            .read(servicesProvider.notifier)
                                            .loadMore(_scrollController);
                                      },
                                      scrollOffset: 10,
                                      child: ListView.builder(
                                        key: PageStorageKey<String>(
                                            'controllerA'),
                                        controller: _scrollController,
                                        shrinkWrap: true,
                                        padding: EdgeInsetsResponsive.only(
                                            bottom: 40, top: 10),
                                        itemBuilder: (context, index) => Column(
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
                                                  selectedService =
                                                      data.data![index];

                                                  widget.showServiceDetails
                                                      .value = true;
                                                },
                                                data.data![index],
                                                (number) {
                                                  launchCaller(number);
                                                },
                                                widget.favorite,
                                                onRating: () {
                                                  if (GetStorage()
                                                      .hasData('token'))
                                                    apiBloc.doAction(
                                                        param: BaseStatefulState
                                                            .addServiceInfo(
                                                                Map(),
                                                                data: {
                                                              'method': 'post',
                                                              'url':
                                                                  FAVORITE_API,
                                                              'type':
                                                                  'service_center',
                                                              'favoriateable_id':
                                                                  data
                                                                      .data![
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                              'status': !(data
                                                                      .data![
                                                                          index]
                                                                      .userReactions
                                                                      ?.isFavorited ??
                                                                  false)
                                                            }),
                                                        supportLoading: true,
                                                        supportErrorMsg: false,
                                                        onResponse: (json) {
                                                          if (isSuccess(json)) {
                                                            if (widget.favorite
                                                                    .length >
                                                                0) {
                                                              context
                                                                  .read(servicesProvider
                                                                      .notifier)
                                                                  .removeItem(data
                                                                      .data![
                                                                          index]
                                                                      .id
                                                                      .toString());
                                                              return;
                                                            }
                                                            context
                                                                .read(servicesProvider
                                                                    .notifier)
                                                                .updateFavoriteState(
                                                                    data
                                                                        .data![
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                    !(data
                                                                            .data![index]
                                                                            .userReactions
                                                                            ?.isFavorited ??
                                                                        false));
                                                          }
                                                        });
                                                  else
                                                    goTo(
                                                        LoginScreen
                                                            .generatePath(),
                                                        transition:
                                                            TransitionType
                                                                .inFromTop);
                                                },
                                              ),
                                              actions: <Widget>[],
                                              secondaryActions: <Widget>[
                                                SlideAction.IconSlideAction(
                                                  caption: 'تعديل',
                                                  onTap: () {},
                                                  color: AppFactory.getColor(
                                                          'primary', toString())
                                                      .withOpacity(0.8),
                                                  icon: Icons.edit,
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        itemCount: data.data?.length ?? 0,
                                      )))
                              : widget.favorite.length != 0
                                  ? emptyWidget(
                                      msg: 'عند أختيار مفضلتك ستظهر هنا')
                                  : Container();
                        } catch (e) {
                          return Container();
                        }
                      }, error: (e) {
                        return Container();
                      });
                    },
                  ),
                ),
        ],
      )),
    );
  }
}

class ArticleLoaderItem extends StatelessWidget {
  ArticleLoaderItem();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsResponsive.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                margin: EdgeInsetsResponsive.only(top: 3),
                height: 113.0.w,
                width: 329.w,
                child: SizedBox.expand(
                  child: ClipRRect(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10.0.w),
                      ),
                      child: Shimmer.fromColors(
                          baseColor: getBaseColor(),
                          highlightColor: getHighlightColor(),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                              ),
                              color: Colors.white,
                            ),
                          ))),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0.w),
                  ),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppFactory.getColor('gray_1', toString())
                          .withOpacity(0.12),
                      offset: Offset(0, 2.0),
                      blurRadius: 12.0,
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: 20.w,
          ),
          Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 100.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.w)),
                          ),
                          child: Shimmer.fromColors(
                              baseColor: getBaseColor(),
                              highlightColor: getHighlightColor(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.w)),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                          width: 100.w,
                          height: 20.w,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.w)),
                          ),
                          child: Shimmer.fromColors(
                              baseColor: getBaseColor(),
                              highlightColor: getHighlightColor(),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.w)),
                                  border: Border.all(
                                    color: Colors.white,
                                  ),
                                  color: Colors.white,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 8.w,
                            height: 8.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(9999.0, 9999.0)),
                              color: const Color(0xfffeca2e),
                            ),
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            width: 100.w,
                            height: 20.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.w)),
                            ),
                            child: Shimmer.fromColors(
                                baseColor: getBaseColor(),
                                highlightColor: getHighlightColor(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.w)),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Assets.icons.calendar.svg(
                            width: 8.w,
                            color: Color(0xff3876BA),
                            height: 8.w,
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          Container(
                            width: 100.w,
                            height: 20.w,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.w)),
                            ),
                            child: Shimmer.fromColors(
                                baseColor: getBaseColor(),
                                highlightColor: getHighlightColor(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.w)),
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 10.w,
              ),
            ],
          ),
          SizedBox(
            height: 20.w,
          ),
        ],
      ),
    );
  }
}

class ServiceItem extends StatelessWidget {
  final VoidCallback onTap;
  final DataBean item;
  final Function(String) onCall;
  final VoidCallback? onRating;
  final String favorite;
  ServiceItem(this.onTap, this.item, this.onCall, this.favorite,
      {this.onRating});

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
              right: 8.w,
              top: 20.w,
              child: Container(
                  width: 90.w,
                  height: 90.w,
                  child: CircularProfileAvatar(
                    item.mainImage?.conversions?.large?.url ?? '',
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
                          item.name ?? '',
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
                      RatingBar(
                        initialRating: item.stats!.reviewsAvg ?? 0.0,
                        minRating: 5,
                        textDirection: TextDirection.ltr,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemSize: 10.w,
                        ratingWidget: RatingWidget(
                          full: Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          half: Icon(
                            Icons.star_half_sharp,
                            color: Colors.amber,
                          ),
                          empty: Icon(
                            Icons.star_border,
                            color: Colors.amber,
                          ),
                        ),
                        itemPadding: EdgeInsets.symmetric(horizontal: 2.w),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      TextResponsive(
                        '[${item.stats!.reviewsCount.toString()}]',
                        style: TextStyle(
                          fontSize: AppFactory.getFontSize(15.0, toString()),
                          color: AppFactory.getColor('gray_1', toString()),
                        ),
                        textAlign: TextAlign.right,
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextResponsive(
                          item.location['governorate']?['name'] ?? '',
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                              fontSize:
                                  AppFactory.getFontSize(16.0, toString()),
                              color: Colors.black),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      (item.isOpenNow ?? false)
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 7.0.w,
                                      height: 8.0.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(3.5.w, 4.0.w)),
                                          color: Color(0xff3EC62C)),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    TextResponsive(
                                      'يعمل الآن',
                                      style: TextStyle(
                                        fontSize: AppFactory.getFontSize(
                                            16.0, toString()),
                                        color: Color(0xff3EC62C),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  width: 20.w,
                                ),
                                (item.contacts!.mobile ?? '').length > 0
                                    ? InkWell(
                                        onTap: () {
                                          onCall.call(
                                              item.contacts?.mobile ?? '');
                                        },
                                        child: Assets.icons.callRound
                                            .svg(height: 23.w, width: 43.w))
                                    : Container()
                              ],
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      width: 7.0.w,
                                      height: 8.0.w,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.elliptical(3.5.w, 4.0.w)),
                                          color: Color(0xffE31414)),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    TextResponsive(
                                      'مغلق',
                                      style: TextStyle(
                                        fontSize: AppFactory.getFontSize(
                                            16.0, toString()),
                                        color: Color(0xffE31414),
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                    ],
                  ),
                  (item.offersCount ?? 0) > 0
                      ? Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 7.0.w,
                                  height: 8.0.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(3.5.w, 4.0.w)),
                                      color: Color(0xffE31414)),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                TextResponsive(
                                  'يوجد عرض',
                                  style: TextStyle(
                                    fontSize: AppFactory.getFontSize(
                                        16.0, toString()),
                                    color: Color(0xffE31414),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                          ],
                        )
                      : Container()
                ],
              ),
            ),
            Positioned(
                top: 0,
                left: 5.w,
                child: favorite.length > 0
                    ? InkWell(
                        onTap: onRating,
                        child: SvgPicture.string(
                          '<svg viewBox="16.0 181.0 19.1 19.1" ><path transform="translate(13.0, 178.0)" d="M 12.55151557922363 3 C 7.269526481628418 3 3 7.269526481628418 3 12.55151557922363 C 3 17.83350563049316 7.269526481628418 22.10302734375 12.55151557922363 22.10302734375 C 17.83350563049316 22.10302734375 22.10302734375 17.83350563049316 22.10302734375 12.55151557922363 C 22.10302734375 7.269526481628418 17.83350563049316 3 12.55151557922363 3 Z M 17.3272705078125 15.98051071166992 L 15.98051071166992 17.3272705078125 L 12.55151557922363 13.89827823638916 L 9.12252140045166 17.3272705078125 L 7.7757568359375 15.98051071166992 L 11.20475101470947 12.55151557922363 L 7.7757568359375 9.12252140045166 L 9.12252140045166 7.7757568359375 L 12.55151557922363 11.20475101470947 L 15.98051071166992 7.7757568359375 L 17.3272705078125 9.12252140045166 L 13.89827823638916 12.55151557922363 L 17.3272705078125 15.98051071166992 Z" fill="#707070" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                          allowDrawingOutsideViewBox: true,
                          fit: BoxFit.fill,
                          width: 20.w,
                          height: 20.w,
                        ),
                      )
                    : SizedBox())
          ],
        ),
      ),
    );
  }
}
