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
import 'package:flutter_app/providers/ArticlesProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/EditAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/chat/MessagesScreen.dart';
import 'package:flutter_app/ui/screen/dogs/AddDogsCatsScreen.dart';
import 'package:flutter_app/ui/screen/dogs/DetailsScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/animals/AnimalsListScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/products/ProductsListScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/services/ServicesListScreen.dart';
import 'package:flutter_app/ui/screen/info/InfoScreen.dart';
import 'package:flutter_app/ui/widget/AppBarWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/BottomSliderWidget.dart';
import 'package:flutter_app/ui/widget/CustomFilterWidget.dart';
import 'package:flutter_app/ui/widget/FilterWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/ImagePickerWidget.dart';
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
import 'package:get_storage/get_storage.dart';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:shimmer/shimmer.dart';

import '../HomeScreen.dart';
import 'ArticleDetailsScreen.dart';

class ArticlesScreen extends StatefulWidget {
  static const String PATH = '/home-articles';
  final String initPage;

  late final String favorite;
  late final String? initialId;

  ArticlesScreen(this.initPage, {this.favorite = '', this.initialId});

  static String generatePath(String initPage,
      {String? favorite, String? initialId}) {
    Map<String, dynamic> parameters = {
      'initPage': initPage,
      'favorite': favorite,
      'initialId': initialId
    };
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends BaseStatefulState<ArticlesScreen> {
  TabController? _controller;
  List<Widget> tabs = [];
  List<Widget> children = [];

  @override
  void initState() {
    tabs.add(Tab(
      text: 'القطط',
    ));
    tabs.add(Tab(
      text: 'الكلاب',
    ));
    tabs.add(Tab(
      text: 'الخدمات',
    ));
    tabs.add(Tab(
      text: 'تسوق',
    ));

    children.add(AnimalsListScreen(
        showFilter, showServiceDetails, widget.favorite, false));
    children.add(AnimalsListScreen(
        showFilter, showServiceDetails, widget.favorite, true));
    children.add(ServicesListWidget(
      showServiceDetails,
      widget.favorite,
      initialId: widget.initialId,
    ));
    children.add(ProductsListScreen(
      showServiceDetails,
      widget.favorite,
      initialId: widget.initialId,
    ));

    if (widget.favorite.length == 0) {
      tabs.add(Tab(
        text: 'المقالات',
      ));
      children.add(ValueListenableBuilder(
          valueListenable: addArticleForm,
          builder: (context, value, child) => Container(
                child: addArticleForm.value
                    ? AddArticleWidget(
                        onAdd: () {
                          addArticleForm.value = false;
                        },
                      )
                    : ArticlesWidget(
                        onAddArticleClick: () {
                          addArticleForm.value = true;
                        },
                      ),
              )));
    }
    _controller =
        TabController(length: widget.favorite.length == 0 ? 5 : 4, vsync: this);
    _controller!.index = int.parse(widget.initPage);

    super.initState();
  }

  @override
  void dispose() {
    addArticleForm.dispose();
    super.dispose();
  }

  ValueNotifier<bool> showServiceDetails = ValueNotifier(false);
  ValueNotifier<bool> showFilter = ValueNotifier(false);
  ValueNotifier<bool> addArticleForm = ValueNotifier(false);

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
                  AppBarWidget(
                      widget.favorite.length == 0 ? 'home' : 'favorite',
                      (pageId) {
                    goTo(HomeScreen.generatePath(pageId: pageId));
                  }),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: NestedScrollView(
                      headerSliverBuilder: (context, value) {
                        return [
                          SliverToBoxAdapter(
                            child: Center(
                              child: Stack(
                                children: [
                                  TabBar(
                                    onTap: (index) {
                                      if (index == 1) {
                                        GetStorage()
                                            .write('filter-animal-id', 'dog');
                                        GetStorage()
                                            .write('filter-animal-name', 'كلب');
                                      } else if (index == 0) {
                                        GetStorage()
                                            .write('filter-animal-id', 'cat');
                                        GetStorage()
                                            .write('filter-animal-name', 'قط');
                                      }
                                      goTo(
                                          ArticlesScreen.generatePath(
                                              index.toString(),
                                              favorite: widget.favorite),
                                          transition: TransitionType.native,
                                          replace: true);
                                    },
                                    indicatorWeight: 3.w,
                                    indicatorColor: AppFactory.getColor(
                                        'primary', toString()),
                                    labelColor: AppFactory.getColor(
                                        'primary', toString()),
                                    labelStyle: TextStyle(
                                      fontFamily: FontFamily.araHamahAlislam,
                                      fontSize: 15.h,
                                      color: const Color(0xff3876ba),
                                    ),
                                    unselectedLabelColor: Color(0xffD5D3D3),
                                    indicatorSize: TabBarIndicatorSize.tab,
                                    controller: _controller,
                                    isScrollable: true,
                                    tabs: tabs,
                                  ),
                                  Positioned(
                                    bottom: 0.5.w,
                                    left: 0,
                                    right: 0,
                                    child: SvgPicture.string(
                                      '<svg viewBox="12.5 162.5 349.3 1.0" ><path transform="translate(12.5, 162.5)" d="M 349.25 0 L 0 0" fill="none" fill-opacity="0.23" stroke="#707070" stroke-width="0.5" stroke-opacity="0.23" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                      allowDrawingOutsideViewBox: true,
                                      fit: BoxFit.fill,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ];
                      },
                      body: Container(
                        child: TabBarView(
                          controller: _controller,
                          physics: NeverScrollableScrollPhysics(),
                          children: children,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        )));
  }
}

class ArticlesWidget extends StatefulWidget {
  final VoidCallback? onAddArticleClick;

  ArticlesWidget({this.onAddArticleClick});

  @override
  _ArticlesState createState() => _ArticlesState();
}

class _ArticlesState extends BaseStatefulState<ArticlesWidget> {
  late List<dynamic> tags;

  @override
  void initState() {
    context.read(articlesProvider.notifier).animalType = null;
    context.read(articlesProvider.notifier).tags = null;
    Future.delayed(Duration.zero, () {
      context.read(articlesProvider.notifier).load();
    });

    status.value = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          GetStorage().hasData('token')
              ? Align(
                  alignment: Alignment.center,
                  child: Wrap(
                    children: [
                      InkWell(
                        onTap: widget.onAddArticleClick,
                        child: Container(
                          padding: EdgeInsetsResponsive.only(
                              left: 10, right: 10, top: 4, bottom: 7),
                          margin:
                              EdgeInsetsResponsive.only(left: 20, right: 20),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
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
                                    'add_article', 'إضافة مقال'),
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: AppFactory.getColor(
                                      'primary', toString()),
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
                )
              : Container(),
          SizedBox(
            height: 20.h,
          ),
          Row(
            children: [
              Expanded(
                child: CustomFilterWidget(
                  onSelected: (data) {
                    context
                        .read(articlesProvider.notifier)
                        .filterByAnimalType(data['id']);
                  },
                  data: [
                    {
                      'id': 'all',
                      'margin-left': 48.w,
                      'selected':
                          context.read(articlesProvider.notifier).animalType ==
                              null,
                      'name': AppFactory.getLabel('all', 'الكل'),
                    },
                    {
                      'id': 'dog',
                      'margin-left': 48.w,
                      'selected':
                          context.read(articlesProvider.notifier).animalType ==
                              'dog',
                      'name': AppFactory.getLabel('dog', 'كلب'),
                    },
                    {
                      'id': 'cat',
                      'margin-left': 48.w,
                      'selected':
                          context.read(articlesProvider.notifier).animalType ==
                              'cat',
                      'name': AppFactory.getLabel('cat', 'قط'),
                      'icon': Assets.icons.discount.path
                    },
                  ],
                ),
              ),
              ValueListenableBuilder(
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
                                  .svg(width: 22.w, height: 22.w)))),
              SizedBox(
                width: 20.w,
              )
            ],
          ),
          ValueListenableBuilder(
              valueListenable: status,
              builder: (context, value, child) => Visibility(
                  visible: status.value,
                  child: Container(
                    margin: EdgeInsetsResponsive.only(top: 20),
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomFilterWidget(
                            onSelected: (data) {
                              context
                                  .read(articlesProvider.notifier)
                                  .filterByTags(data);
                            },
                            isMulti: true,
                            data: copy(GetStorage().read('basics')?['enums']
                                    ?['article_tags'] ??
                                []),
                          ),
                        ),
                      ],
                    ),
                  ))),
          SizedBox(
            height: 10.h,
          ),
          Expanded(
            child: Consumer(
              builder: (context, watch, child) {
                final response = watch(articlesProvider);
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
                  ArticlesResponse data = ArticlesResponse.fromMap(map);
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsetsResponsive.only(bottom: 40, top: 10),
                    itemBuilder: (context, index) =>
                        ArticleItem(data.data![index], () {
                      goTo(ArticleDetailsScreen.generatePath(),
                          transition: TransitionType.inFromTop,
                          data: data.data![index]);
                    }),
                    itemCount: data.data!.length,
                  );
                }, error: (e) {
                  return Container();
                });
              },
            ),
          ),
        ],
      ),
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

class ArticleItem extends StatelessWidget {
  final DataBeanArticle data;
  final VoidCallback onTap;

  ArticleItem(this.data, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsetsResponsive.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
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
                        child: CachedNetworkImage(
                          imageUrl: data.image!.conversions!.large!.url ?? '',
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                            ),
                          ),
                          placeholder: (context, url) =>
                              ImageLoaderPlaceholder(),
                          errorWidget: (context, url, error) =>
                              ImageLoaderErrorWidget(),
                        )),
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
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextResponsive(
                            data.title ?? '',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xff3876ba),
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          TextResponsive(
                            data.source != null
                                ? 'اسم الناشر :' + ' ' + (data.source ?? '')
                                : '',
                            style: TextStyle(
                              fontSize: 16,
                              color: const Color(0xff707070),
                            ),
                            textAlign: TextAlign.start,
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
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
                              TextResponsive(
                                data.sourceType!.desc ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: const Color(0xfffeca2e),
                                ),
                                textAlign: TextAlign.right,
                              )
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
                              TextResponsive(
                                data.publishedAt ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: const Color(0xff3876ba),
                                ),
                                textAlign: TextAlign.right,
                              )
                            ],
                          )
                        ],
                      ),
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
      ),
    );
  }
}

class AddArticleWidget extends StatefulWidget {
  final VoidCallback? onAdd;

  AddArticleWidget({this.onAdd});

  @override
  _AddArticleWidgetState createState() => _AddArticleWidgetState();
}

class _AddArticleWidgetState extends BaseStatefulState<AddArticleWidget> {
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();
  var tags = [];
  File? imageFile;
  dynamic articleTags;
  dynamic animalTypes;
  dynamic articleSourceTypes;

  @override
  void initState() {
    articleTags = copy(GetStorage().read('basics')['enums']['article_tags']);
    animalTypes = copy(GetStorage().read('basics')['enums']['animal_types']);
    articleSourceTypes =
        copy(GetStorage().read('basics')['enums']['article_source_types']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsetsResponsive.zero,
      children: [
        Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              buildMainTitle(
                AppFactory.getLabel('add_article', 'إضافة مقال'),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 113.0.w,
                width: 329.w,
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
                child: Stack(
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(10.0.w),
                        ),
                        child: ImagePickerWidget(
                          onResult: (files) {
                            files.forEach((file) async {
                              imageFile = file;
                            });
                          },
                          emptyWidget: Center(
                              child: Assets.icons.iconMaterialFileUpload
                                  .svg(width: 21.w, height: 26.w)),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              AppTextField(
                name: AppFactory.getLabel('article_name', 'اسم المقال'),
                onSaved: (value) {
                  param['title'] = value;
                },
                // value: authResponse.data!.user!.name!.last,
                validator: RequiredValidator(errorText: errorText()),
              ),
              buildSectionTitle(
                AppFactory.getLabel('add_type', 'نوع المقال:'),
              ),
              CustomFilterWidget(
                onSelected: (data) {
                  tags.clear();
                  data.forEach((element) {
                    if (element['selected']) {
                      tags.add(element['id']);
                    }
                  });
                },
                isMulti: true,
                data: articleTags,
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  buildWrapSectionTitle(AppFactory.getLabel('for', 'يخص:')),
                  CustomFilterWidget(
                    onSelected: (data) {
                      var animal_type;
                      int index = 0;
                      data.forEach((element) {
                        if (element['selected']) {
                          animal_type = element['id'];
                          index++;
                        }
                      });
                      if (index == 1)
                        param['animal_type'] = animal_type;
                      else
                        param.remove('animal_type');
                    },
                    isMulti: true,
                    data: animalTypes,
                  ),
                ],
              ),
              buildSectionTitle(AppFactory.getLabel('text', 'النص:'), top: 5),
              Container(
                width: 300.0.w,
                height: 101.0.w,
                child: AppTextField(
                  supportUnderLine: false,
                  name: AppFactory.getLabel('hint_location', 'أبجد هوز….'),
                  validator: RequiredValidator(errorText: errorText()),
                  onSaved: (value) {
                    param['text'] = value;
                  },
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.0.w),
                  ),
                  color: Colors.white,
                  border: Border.all(
                    width: 0.3,
                    color: AppFactory.getColor('gray_1', toString()),
                  ),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              AppTextField(
                name: AppFactory.getLabel('source', 'المصدر'),
                onSaved: (value) {
                  param['source'] = value;
                },
                // value: authResponse.data!.user!.name!.last,
                validator: RequiredValidator(errorText: errorText()),
              ),
              SizedBox(
                height: 30.h,
              ),
              CustomFilterWidget(
                onSelected: (data) {
                  param['source_type'] = data['id'];
                },
                data: articleSourceTypes,
              ),
              SizedBox(
                height: 20.h,
              ),
              InkWell(
                onTap: () {
                  goTo(InfoScreen.generatePath(
                      'شروط النشر',
                      GetStorage().read('basics')['about_app']
                          ['article_publication_terms']));
                },
                child: Padding(
                  padding: EdgeInsetsResponsive.only(left: 20, right: 20),
                  child: Row(
                    children: [
                      Wrap(
                        children: [
                          TextResponsive(
                            'من حق الإدارة عدم نشر المقال في حال عدم مطابقته',
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xff707070),
                            ),
                            textAlign: TextAlign.start,
                          ),
                          SizedBoxResponsive(
                            width: 5,
                          ),
                          TextResponsive(
                            'لشروط النشر',
                            style: TextStyle(
                              fontSize: 15,
                              color: const Color(0xff3876ba),
                              decoration: TextDecoration.underline,
                            ),
                            textAlign: TextAlign.right,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              buildOrangeBtn(AppFactory.getLabel('add_article', 'إضافة مقال'),
                  () async {
                if (imageFile == null) {
                  showFlash(AppFactory.getLabel(
                      'plz_select_image', 'الرجاء اختيار صورة'));
                  return;
                }

                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();

                  if (tags.length == 0) {
                    showFlash(AppFactory.getLabel(
                        'plz_select_article_type', 'الرجاء اختيار نوع المقال'));
                    return;
                  }

                  if (param['source_type'] == null) {
                    showFlash(AppFactory.getLabel(
                        'plz_select_source_type', 'الرجاء اختيار نوع المصدر'));
                    return;
                  }

                  apiBloc.doAction(
                      param: BaseStatefulState.addServiceInfo(param, data: {
                        'url': ARTICLES_API,
                        'method': 'post',
                        'image': imageFile != null
                            ? await getImageMultiPart(imageFile!)
                            : null,
                        'tags': addTags(Map())
                      }),
                      supportLoading: true,
                      supportErrorMsg: false,
                      onResponse: (json) {
                        if (isSuccess(json) && widget.onAdd != null)
                          widget.onAdd!.call();
                        handlerResponseMsg(json);
                      });
                }
              }),
              SizedBox(
                height: 70.h,
              ),
            ],
          ),
        ),
      ],
    );
  }

  addTags(Map param) {
    for (int i = 0; i < tags.length; i++) {
      param['tags[${i}]'] = tags[i];
    }
    return param;
  }
}
