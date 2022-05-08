import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/ArticleDetails.dart';
import 'package:flutter_app/models/api/ArticlesResponse.dart';
import 'package:flutter_app/providers/ArticlesProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogs/ChangeUsernameDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/ProfileTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsTypsWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';

import 'ArticalsScreen.dart';

class ArticleDetailsScreen extends StatefulWidget {
  static const String PATH = '/articles-details';
  late final DataBeanArticle article;

  ArticleDetailsScreen(this.article);

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _ArticleDetailsScreenState createState() => _ArticleDetailsScreenState();
}

class _ArticleDetailsScreenState
    extends BaseStatefulState<ArticleDetailsScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => context
            .read(articleDetailsProvider.notifier)
            .getDetails(widget.article.id.toString()));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
                children: [
                  SizedBox(
                    height: AppFactory.getDimensions(
                            60, toString() + '-systemNavigationBarMargin')
                        .h,
                  ),
                  Stack(
                    children: [
                      Center(
                        child: Container(
                          margin: EdgeInsetsResponsive.only(top: 5),
                          child: buildMainTitle(AppFactory.getLabel(
                              'article_details', 'تفاصيل مقالة')),
                        ),
                      ),
                      buildBackBtn(context,
                          color: AppFactory.getColor('primary', toString())),
                    ],
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsetsResponsive.only(
                        left: 20, right: 20, bottom: 20),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
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
                                      imageUrl: widget.article.image!
                                              .conversions!.large!.url ??
                                          '',
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
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
                                    color: AppFactory.getColor(
                                            'gray_1', toString())
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
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextResponsive(
                                  widget.article.title ?? '',
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
                                  widget.article.source != null
                                      ? 'اسم الناشر :' +
                                          ' ' +
                                          (widget.article.source ?? '')
                                      : '',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: const Color(0xff707070),
                                  ),
                                  textAlign: TextAlign.start,
                                )
                              ],
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 8.w,
                                            height: 8.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.elliptical(
                                                      9999.0, 9999.0)),
                                              color: const Color(0xfffeca2e),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          TextResponsive(
                                            widget.article.sourceType!.desc ??
                                                '',
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
                                          Container(
                                            width: 8.w,
                                            height: 8.w,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.elliptical(
                                                      9999.0, 9999.0)),
                                              color: const Color(0xfffeca2e),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          TextResponsive(
                                            widget.article.animalType!.desc ??
                                                '',
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
                                            widget.article.publishedAt ?? '',
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
                         Consumer(
                            builder: (context, watch, child) {
                              final response = watch(articleDetailsProvider);
                              return response.when(idle: () {
                                return Container();
                              }, loading: () {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsetsResponsive.only(
                                      bottom: 40, top: 10),
                                  itemBuilder: (context, index) =>
                                      ArticleLoaderItem(),
                                  itemCount: 1,
                                );
                              }, data: (map) {
                                ArticleDetails data =
                                    ArticleDetails.fromMap(map);

                                return Column(
                                  children: [
                                    Wrap(
                                      children: data.data!.tags!
                                          .map((e) =>
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Container(
                                                width: 8.w,
                                                height: 8.w,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.elliptical(
                                                          9999.0, 9999.0)),
                                                  color:  AppFactory.getColor(
                                                      'primary', toString()),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              TextResponsive(
                                                    e.name??'',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: AppFactory.getColor(
                                                          'primary', toString()),
                                                    ),
                                                    textAlign: TextAlign.right,
                                                  ),
                                            ],
                                          ))
                                          .toList(),
                                      spacing: 10.w,
                                    ),
                                    Html(data: data.data?.text ?? ''),
                                  ],
                                );
                              }, error: (e) {
                                return Container();
                              });
                            },
                          ),

                        SizedBox(
                          height: 20.w,
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            ],
          ),
        )));
  }
}
