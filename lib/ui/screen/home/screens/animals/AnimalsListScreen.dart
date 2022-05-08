import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/AnimalsListData.dart';
import 'package:flutter_app/models/api/ProductsReponse.dart';
import 'package:flutter_app/providers/AnimalsProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/EditAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/chat/MessagesScreen.dart';
import 'package:flutter_app/ui/screen/dogs/AddDogsCatsScreen.dart';
import 'package:flutter_app/ui/screen/dogs/DetailsScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/animals/AnimalsFilterScreen.dart';
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
import 'AnimalsDetailsScreen.dart';

class AnimalsListScreen extends StatefulWidget {
  AnimalsListScreen(
      this.showFilter, this.showServiceDetails, this.favorite, this.foDog);

  final ValueNotifier<bool> showServiceDetails;
  final bool foDog;

  final ValueNotifier<bool> showFilter;
  final String favorite;

  @override
  _AnimalsListScreenState createState() => _AnimalsListScreenState();
}

class _AnimalsListScreenState extends BaseStatefulState<AnimalsListScreen> {
  late List<dynamic> tags;
  AnimalsListDataData? selectedService;
  ScrollController _scrollController =
      new ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    GetStorage().remove('filter-species-name');
    GetStorage().remove('filter-species-id');
    // context.read(animalsProvider.notifier).tags = [];
    Future.delayed(Duration.zero, () {
      context.read(animalsProvider.notifier).tags = null;
      context.read(animalsProvider.notifier).load(
          favorite: widget.favorite, animalType: widget.foDog ? 'dog' : 'cat');
    });
    status.value = false;
    widget.showFilter.addListener(() {
      if (!widget.showFilter.value)
        context.read(animalsProvider.notifier).load(favorite: widget.favorite);
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.showServiceDetails,
      builder: (context, value, child) => ValueListenableBuilder(
          valueListenable: widget.showFilter,
          builder: (context, value, child) => Container(
                  child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.favorite.length == 0
                      ? Column(
                          children: [
                            SizedBox(
                              height:
                                  widget.showServiceDetails.value ? 0 : 20.h,
                            ),
                            !widget.showServiceDetails.value &&
                                    !widget.showFilter.value
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomFilterWidget(
                                              onSelected: (data) {
                                                print(data.toString());

                                                context
                                                    .read(animalsProvider
                                                        .notifier)
                                                    .filterByTags(data);
                                              },
                                              isMulti: true,
                                              data: getStates(),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                widget.showFilter.value = true;
                                              },
                                              child: Padding(
                                                  padding:
                                                      EdgeInsetsResponsive.all(
                                                          4),
                                                  child: Assets.icons.settings
                                                      .svg(
                                                          width: 22.w,
                                                          height: 22.w))),
                                          SizedBox(
                                            width: 20.w,
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                : Container(),
                            SizedBox(
                              height: widget.showServiceDetails.value ||
                                      widget.showFilter.value
                                  ? 0
                                  : 10.h,
                            ),
                          ],
                        )
                      : Container(),
                  widget.showServiceDetails.value
                      ? Expanded(
                          child: AnimalsDetailsScreen(
                          selectedService?.id?.toString() ?? '',
                          onBack: () {
                            widget.showServiceDetails.value = false;
                          },
                        ))
                      : widget.showFilter.value
                          ? Expanded(
                              child: AnimalsFilterScreen(
                              forDog: widget.foDog,
                              onBack: () {
                                widget.showFilter.value = false;
                              },
                            ))
                          : Expanded(
                              child: Consumer(
                                builder: (context, watch, child) {
                                  final response = watch(animalsProvider);
                                  return response.when(idle: () {
                                    return Container();
                                  }, loading: () {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      padding: EdgeInsetsResponsive.only(
                                          bottom: 40, top: 10),
                                      itemBuilder: (context, index) =>
                                          ArticleLoaderItem(),
                                      itemCount: 10,
                                    );
                                  }, data: (map) {
                                    try {
                                      AnimalsListData data =
                                          AnimalsListData.fromJson(map);
                                      return (data.data?.length ?? 0) > 0
                                          ? Container(
                                              width: 347.w,
                                              child: LazyLoadScrollView(
                                                  onEndOfPage: () {
                                                    context
                                                        .read(animalsProvider
                                                            .notifier)
                                                        .loadMore(
                                                            _scrollController);
                                                  },
                                                  scrollOffset: 10,
                                                  child: ListView.builder(
                                                    key: PageStorageKey<String>(
                                                        'controllerA'),
                                                    controller:
                                                        _scrollController,
                                                    shrinkWrap: true,
                                                    padding:
                                                        EdgeInsetsResponsive
                                                            .only(
                                                                bottom: 40,
                                                                top: 10),
                                                    itemBuilder:
                                                        (context, index) =>
                                                            Column(
                                                      children: [
                                                        index == 2
                                                            ? MainSliderWidget(
                                                                supportRound:
                                                                    true,
                                                              )
                                                            : Container(),
                                                        Slidable(
                                                          actionPane:
                                                              SlidableDrawerActionPane(),
                                                          enabled: false,
                                                          actionExtentRatio:
                                                              0.25,
                                                          child: ServiceItem(
                                                            () {
                                                              selectedService =
                                                                  data.data![
                                                                      index];

                                                              widget
                                                                  .showServiceDetails
                                                                  .value = true;
                                                            },
                                                            data.data![index],
                                                            (number) {
                                                              launchCaller(
                                                                  number);
                                                            },
                                                            widget.favorite,
                                                            onRating: () {
                                                              if (GetStorage()
                                                                  .hasData(
                                                                      'token'))
                                                                apiBloc
                                                                    .doAction(
                                                                        param: BaseStatefulState.addServiceInfo(
                                                                            Map(),
                                                                            data: {
                                                                              'method': 'post',
                                                                              'url': FAVORITE_API,
                                                                              'type': 'animal',
                                                                              'favoriateable_id': data.data![index].id,
                                                                              'status': !(data.data![index].reactions?.isFavorited ?? false)
                                                                            }),
                                                                        supportLoading:
                                                                            true,
                                                                        supportErrorMsg:
                                                                            false,
                                                                        onResponse:
                                                                            (json) {
                                                                          if (isSuccess(
                                                                              json)) {
                                                                            if (widget.favorite.length >
                                                                                0) {
                                                                              context.read(animalsProvider.notifier).removeItem(data.data![index].id.toString());
                                                                              return;
                                                                            }
                                                                            context.read(animalsProvider.notifier).updateFavoriteState(data.data![index].id.toString(),
                                                                                !(data.data![index].reactions?.isFavorited ?? false));
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
                                                          secondaryActions: <
                                                              Widget>[
                                                            SlideAction
                                                                .IconSlideAction(
                                                              caption: 'تعديل',
                                                              onTap: () {},
                                                              color: AppFactory
                                                                      .getColor(
                                                                          'primary',
                                                                          toString())
                                                                  .withOpacity(
                                                                      0.8),
                                                              icon: Icons.edit,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    itemCount:
                                                        data.data?.length ?? 0,
                                                  )))
                                          : widget.favorite.length != 0
                                              ? emptyWidget(
                                                  msg:
                                                      'عند أختيار مفضلتك ستظهر هنا')
                                              : Container();
                                    } catch (e) {
                                      return Text(e.toString());
                                    }
                                  }, error: (e) {
                                    return Container();
                                  });
                                },
                              ),
                            ),
                ],
              ))),
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
  late final AnimalsListDataData item;
  final VoidCallback? onRating;
  final String favorite;
  final Function(String) onCall;

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
              right: 6.w,
              top: 20.w,
              child: Container(
                  width: 90.w,
                  height: 90.w,
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
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: onRating,
                        child: Padding(
                          padding: EdgeInsetsResponsive.only(
                              left: 5, right: 5, top: 5),
                          child: favorite.length > 0
                              ? Container()
                              : item.reactions?.isFavorited ?? false
                                  ? SvgPicture.string(
                                      '<svg viewBox="26.3 361.0 15.8 13.9" ><path transform="translate(26.27, 358.75)" d="M 14.30443096160889 3.195546627044678 C 12.60875797271729 1.750511884689331 10.08691024780273 2.010432481765747 8.530481338500977 3.61637020111084 L 7.920905590057373 4.244511604309082 L 7.31132984161377 3.61637020111084 C 5.75799560546875 2.010432481765747 3.233052492141724 1.750511884689331 1.53738009929657 3.195546627044678 C -0.4058356583118439 4.854087352752686 -0.5079473853111267 7.830796241760254 1.231045126914978 9.628580093383789 L 7.218501091003418 15.81097793579102 C 7.605287551879883 16.21014213562012 8.233428955078125 16.21014213562012 8.62021541595459 15.81097793579102 L 14.60767078399658 9.628581047058105 C 16.34976005554199 7.83079719543457 16.24764633178711 4.854088306427002 14.30443000793457 3.195547580718994 Z" fill="#e31414" stroke="#e31414" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                      width: 16.w,
                                      height: 14.w,
                                    )
                                  : // Adobe XD layer: 'Icon awesome-heart' (shape)
                                  SvgPicture.string(
                                      '<svg viewBox="24.0 490.1 15.8 13.9" ><path transform="translate(24.0, 487.89)" d="M 14.30443096160889 3.195546627044678 C 12.60875797271729 1.750511884689331 10.08691024780273 2.010432481765747 8.530481338500977 3.61637020111084 L 7.920905590057373 4.244511604309082 L 7.31132984161377 3.61637020111084 C 5.75799560546875 2.010432481765747 3.233052492141724 1.750511884689331 1.53738009929657 3.195546627044678 C -0.4058356583118439 4.854087352752686 -0.5079473853111267 7.830796241760254 1.231045126914978 9.628580093383789 L 7.218501091003418 15.81097793579102 C 7.605287551879883 16.21014213562012 8.233428955078125 16.21014213562012 8.62021541595459 15.81097793579102 L 14.60767078399658 9.628581047058105 C 16.34976005554199 7.83079719543457 16.24764633178711 4.854088306427002 14.30443000793457 3.195547580718994 Z" fill="none" stroke="#e31414" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                      width: 16.w,
                                      height: 14.w,
                                    ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextResponsive(
                          item.species?.name ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            color: const Color(0xff3876ba),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      item.properties?.isHybrid != null
                          ? Expanded(
                              flex: 2,
                              child: TextResponsive(
                                !(item.properties?.isHybrid ?? false)
                                    ? 'نقي'
                                    : 'مهجن',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height: 1,
                                  fontSize:
                                      AppFactory.getFontSize(15.0, toString()),
                                  color: Color(0xff707070),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextResponsive(
                          'اللون: ${item.color?.name}',
                          style: TextStyle(
                            fontSize: 15,
                            color: const Color(0xff3876ba),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Expanded(
                        flex: 2,
                        child: TextResponsive(
                          item.gender?.desc ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            height: 1,
                            fontSize: AppFactory.getFontSize(16.0, toString()),
                            color: Color(0xffFECA2E),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
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
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontSize: AppFactory.getFontSize(
                                          16.0, toString()),
                                      color: statusColor[item.status?.id] ??
                                          Colors.green),
                                  textAlign: TextAlign.right,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                TextResponsive(
                                  getCity(),
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                      fontSize: AppFactory.getFontSize(
                                          16.0, toString()),
                                      color: statusColor[item.status?.id] ??
                                          Colors.black),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                      SizedBox(
                        width: 5.w,
                      ),
                      item.status?.id == 'sale' || item.status?.id == 'marriage'
                          ? Row(
                              children: [
                                item.offer != null
                                    ? TextResponsive(
                                        'السعر:${item.offer?.price?.formatted ?? ''}',
                                        textDirection: TextDirection.rtl,
                                        style: TextStyle(
                                          fontFamily: 'roboto',
                                          fontSize: AppFactory.getFontSize(
                                              12.0, toString()),
                                          color: Color(0xff000000),
                                        ),
                                        textAlign: TextAlign.right,
                                      )
                                    : Container(),
                              ],
                            )
                          : SizedBox(),
                    ],
                  )
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

  getCity() {
    try {
      return '- ' + item.breeder?['location']['governorate']['name'];
    } catch (e) {}
    return '';
  }
}

Map<String, Color> statusColor = {
  'adoption': Colors.blue,
  'normal': Colors.orange,
  'sale': Colors.deepOrangeAccent,
  'marriage': Colors.green,
  'missing': Colors.red,
};
