import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/models/api/OffersModel.dart';
import 'package:flutter_app/providers/OffersProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogs/ChangeUsernameDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/home/articles/ArticalsScreen.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/ProfileTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsTypsWidget.dart';
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

import 'AddOfferScreen.dart';

class OffersScreen extends StatefulWidget {
  static const String PATH = '/offers-list';

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _OffersScreenState createState() => _OffersScreenState();
}

class _OffersScreenState extends BaseStatefulState<OffersScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    Future.delayed(
        Duration.zero, () => context.read(offersProvider.notifier).load());

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
                          child: buildMainTitle(
                              AppFactory.getLabel('offers', 'عروضي')),
                        ),
                      ),
                      buildBackBtn(context,
                          color: AppFactory.getColor('primary', toString())),
                    ],
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Wrap(
                      children: [
                        InkWell(
                          onTap: () {
                            goTo(AddOfferScreen.generatePath(),
                                onResponse: (result) {
                              if (result != null) {
                                Future.delayed(
                                    Duration.zero,
                                    () => context
                                        .read(offersProvider.notifier)
                                        .load());
                              }
                            });
                          },
                          child: Container(
                            padding: EdgeInsetsResponsive.only(
                                left: 10, right: 10, top: 3, bottom: 5),
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
                                  AppFactory.getLabel('add_offer', 'إضافة عرض'),
                                  style: TextStyle(
                                    fontSize: 20.0,
                                    color: AppFactory.getColor(
                                        'primary', toString()),
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(23.0.w),
                              border: Border.all(
                                width: 1.0,
                                color:
                                    AppFactory.getColor('primary', toString()),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Consumer(
                      builder: (context, watch, child) {
                        final response = watch(offersProvider);
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
                          OffersModel data = OffersModel.fromMap(map);
                          return ListView.builder(
                            shrinkWrap: true,
                            padding:
                                EdgeInsetsResponsive.only(bottom: 20, top: 10),
                            itemBuilder: (context, index) =>
                                OfferItem(data.data![index], () {
                              GetIt.I<APIRepository>().showConfirmDialog(
                                  'هل تريد الحذف بالتأكيد', onDone: () {
                                apiBloc.doAction(
                                    param: BaseStatefulState.addServiceInfo(
                                        Map(),
                                        data: {
                                          'method': 'delete',
                                          'url': OFFERS_API +
                                              '/' +
                                              data.data![index].id.toString(),
                                        }),
                                    supportLoading: true,
                                    supportErrorMsg: false,
                                    onResponse: (json) {
                                      if (isSuccess(json)) {
                                        Future.delayed(
                                            Duration.zero,
                                            () => context
                                                .read(offersProvider.notifier)
                                                .load());
                                      }
                                    });
                              });
                            }),
                            itemCount: data.data?.length ?? 0,
                          );
                        }, error: (e) {
                          return Container();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )));
  }
}

class OfferItem extends StatelessWidget {
  final DataBean data;
  final VoidCallback onRemove;

  OfferItem(this.data, this.onRemove);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                      placeholder: (context, url) => ImageLoaderPlaceholder(),
                      errorWidget: (context, url, error) =>
                          ImageLoaderErrorWidget(),
                    )),
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
              ),
              Positioned(
                left: 0,
                top: 0,
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
          ),
          SizedBox(
            height: 20.w,
          ),
          Container(
            width: 329.w,
            child: TextResponsive(
              data.text ?? '',
              style: TextStyle(
                fontSize: 17,
                color: const Color(0xff707070),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 20.w,
          ),
          SvgPicture.string(
            '<svg viewBox="22.5 350.5 330.0 1.0" ><path transform="translate(22.5, 350.5)" d="M 330 0 L 0 0" fill="none" fill-opacity="0.45" stroke="#000000" stroke-width="0.20000000298023224" stroke-opacity="0.45" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
            allowDrawingOutsideViewBox: true,
            fit: BoxFit.fill,
          )
        ],
      ),
    );
  }
}
