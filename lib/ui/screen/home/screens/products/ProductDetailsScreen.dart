import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:expandable/expandable.dart';
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
import 'package:flutter_app/models/api/ProductsReponse.dart';
import 'package:flutter_app/models/api/Reviews.dart';
import 'package:flutter_app/models/api/ServiceDetails.dart';
import 'package:flutter_app/providers/CartActionsProvider.dart';
import 'package:flutter_app/providers/ProductsProvider.dart';
import 'package:flutter_app/providers/ReviewsProvider.dart';
import 'package:flutter_app/providers/ServicesProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogs/AddRatingDialog.dart';
import 'package:flutter_app/ui/dialogsss/ChangeStatusDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MainScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyAccountScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyDogsCatsScreen.dart';
import 'package:flutter_app/ui/screen/services/WorkingHoursScreen.dart';
import 'package:flutter_app/ui/widget/AppBarWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/BottomSliderWidget.dart';
import 'package:flutter_app/ui/widget/CustomTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/DogCatSelectWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/HairTypeWidget.dart';
import 'package:flutter_app/ui/widget/ImagePickerWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/MainSliderWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsLargeWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsWidget.dart';
import 'package:flutter_app/ui/widget/Text1Widget.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as ColorPicker;
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share/share.dart';
import 'package:shimmer/shimmer.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String PATH = '/product-details';
  final VoidCallback? onBack;
  final String id;

  ProductDetailsScreen(this.id, {this.onBack});

  static String generatePath() {
    Map<String, dynamic> parameters = {};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends BaseStatefulState<ProductDetailsScreen> {
  ValueNotifier<bool> isDog = ValueNotifier(false);
  ValueNotifier<bool> isHybrid = ValueNotifier(false);
  ValueNotifier<List<Color>> colors = ValueNotifier([]);
  late List<dynamic> transferServices;
  final formKey = GlobalKey<FormState>();
  Map<String, dynamic> param = Map();

  Map<String, dynamic> contacts = Map();
  Map<String, dynamic> location = Map();
  Map<String, dynamic> opening_hours = Map();
  List<dynamic> images = [];

  Map<String, dynamic> settings = Map();
  late List<dynamic> days;
  Map<String, dynamic> services = Map();
  late List<dynamic> servicesData;

  getLocalService(String id) {
    for (var temp in servicesData) {
      if (temp['id'] == id) return temp;
    }
  }

  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => context
            .read(productsDetailsProvider.notifier)
            .getDetails(widget.id));

    servicesData = [
      {
        'id': 'veterinary_clinic',
        'margin-left': 42.w,
        'selected': false,
        'enable': false,
        'description': '',
        'item_count': 1,
        'doctors': [],
        'name': AppFactory.getLabel('veterinary_clinic', 'عيادة بيطرية'),
        'icon': Assets.icons.clinic.path
      },
      {
        'id': 'hotel',
        'margin-left': 48.w,
        'selected': false,
        'description': '',
        'enable': false,
        'name': AppFactory.getLabel('hotels', 'فندقة'),
        'icon': Assets.icons.hote546.path
      },
      {
        'id': 'shaving',
        'margin-left': 48.w,
        'description': '',
        'selected': false,
        'enable': false,
        'name': AppFactory.getLabel('shaving', 'حلاقة'),
        'icon': Assets.icons.dog5443.path
      },
      {
        'id': 'shower',
        'selected': false,
        'enable': false,
        'description': '',
        'margin-left': 48.w,
        'name': AppFactory.getLabel('bathroom', 'حمام'),
        'icon': Assets.icons.dog43445.path
      },
      {
        'id': 'walk',
        'margin-left': 45.w,
        'selected': false,
        'description': '',
        'enable': false,
        'name': AppFactory.getLabel('hike_and_walk', 'تنزه و تمشي'),
        'icon': Assets.icons.blind.path
      },
      {
        'id': 'training',
        'margin-left': 48.w,
        'enable': false,
        'selected': false,
        'description': '',
        'name': AppFactory.getLabel('training', 'تدريب'),
        'icon': Assets.icons.outlineA.path
      }
    ];
    settings['is_mobile'] = false;
    days = [
      {
        'id': 'friday',
        'margin-left': 42.w,
        'selected': false,
        'name': AppFactory.getLabel('friday', 'الجمعة'),
        'icon': Assets.icons.clinic.path
      },
      {
        'id': 'saturday',
        'margin-left': 48.w,
        'selected': false,
        'name': AppFactory.getLabel('saturday', 'السبت'),
        'icon': Assets.icons.hote546.path
      },
      {
        'id': 'sunday',
        'margin-left': 48.w,
        'selected': false,
        'name': AppFactory.getLabel('sunday', 'الأحد'),
        'icon': Assets.icons.dog5443.path
      },
      {
        'id': 'monday',
        'selected': false,
        'margin-left': 48.w,
        'name': AppFactory.getLabel('monday', 'الاثنين'),
        'icon': Assets.icons.dog43445.path
      },
      {
        'id': 'tuesday',
        'margin-left': 45.w,
        'selected': false,
        'name': AppFactory.getLabel('tuesday', 'الثلاثاء'),
        'icon': Assets.icons.blind.path
      },
      {
        'id': 'wednesday',
        'margin-left': 48.w,
        'selected': false,
        'name': AppFactory.getLabel('wednesday', 'الأربعاء'),
        'icon': Assets.icons.outlineA.path
      },
      {
        'id': 'thursday',
        'margin-left': 48.w,
        'selected': false,
        'name': AppFactory.getLabel('thursday', 'الخميس'),
        'icon': Assets.icons.outlineA.path
      }
    ];
    transferServices = [
      {
        'id': 'working_hours',
        'margin-left': 50.w,
        'name': AppFactory.getLabel('working_hours', 'مواعيد العمل'),
        'icon': Assets.icons.calendarA.path
      }
    ];

    super.initState();
  }

  @override
  void dispose() {
    colors.dispose();
    quantity.dispose();
    isDog.dispose();
    isHybrid.dispose();
    super.dispose();
  }

  getTarget() {
    return isDog.value ? 'الكلب' : 'القط';
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
        child: WillPopScope(
            onWillPop: () {
              if (widget.onBack != null) {
                widget.onBack!.call();
                return Future.value(false);
              }
              return Future.value(true);
            },
            child: Scaffold(
              backgroundColor: AppFactory.getColor('background', toString()),
              body: Stack(
                children: [
                  KeyboardVisibilityBuilder(
                      builder: (context, isKeyboardVisible) {
                    return !isKeyboardVisible ? RightLeftWidget() : Container();
                  }),
                  Consumer(
                    builder: (context, watch, child) {
                      final response = watch(productsDetailsProvider);
                      return response.when(idle: () {
                        return Container();
                      }, loading: () {
                        return LoaderWidget();
                      }, data: (map) {
                        ProductDataDetails data =
                            ProductDataDetails.fromMap(map);
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsetsResponsive.only(bottom: 50),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    MainSliderWidget(
                                      data: data.data!.images!
                                          .map((e) => {
                                                'url':
                                                    e.conversions!.large!.url,
                                                'id': e.id
                                              })
                                          .toList(),
                                      supportRound: true,
                                    ),
                                    Positioned(
                                      child: Column(
                                        children: [
                                          InkWell(
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsResponsive.all(5),
                                              child: data.data?.userReactions
                                                          ?.isFavorited ??
                                                      false
                                                  ? SvgPicture.string(
                                                      '<svg viewBox="26.3 361.0 15.8 13.9" ><path transform="translate(26.27, 358.75)" d="M 14.30443096160889 3.195546627044678 C 12.60875797271729 1.750511884689331 10.08691024780273 2.010432481765747 8.530481338500977 3.61637020111084 L 7.920905590057373 4.244511604309082 L 7.31132984161377 3.61637020111084 C 5.75799560546875 2.010432481765747 3.233052492141724 1.750511884689331 1.53738009929657 3.195546627044678 C -0.4058356583118439 4.854087352752686 -0.5079473853111267 7.830796241760254 1.231045126914978 9.628580093383789 L 7.218501091003418 15.81097793579102 C 7.605287551879883 16.21014213562012 8.233428955078125 16.21014213562012 8.62021541595459 15.81097793579102 L 14.60767078399658 9.628581047058105 C 16.34976005554199 7.83079719543457 16.24764633178711 4.854088306427002 14.30443000793457 3.195547580718994 Z" fill="#e31414" stroke="#e31414" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                      fit: BoxFit.fill,
                                                      width: 16.w,
                                                      height: 14.w,
                                                    )
                                                  : // Adobe XD layer: 'Icon awesome-heart' (shape)
                                                  SvgPicture.string(
                                                      '<svg viewBox="24.0 490.1 15.8 13.9" ><path transform="translate(24.0, 487.89)" d="M 14.30443096160889 3.195546627044678 C 12.60875797271729 1.750511884689331 10.08691024780273 2.010432481765747 8.530481338500977 3.61637020111084 L 7.920905590057373 4.244511604309082 L 7.31132984161377 3.61637020111084 C 5.75799560546875 2.010432481765747 3.233052492141724 1.750511884689331 1.53738009929657 3.195546627044678 C -0.4058356583118439 4.854087352752686 -0.5079473853111267 7.830796241760254 1.231045126914978 9.628580093383789 L 7.218501091003418 15.81097793579102 C 7.605287551879883 16.21014213562012 8.233428955078125 16.21014213562012 8.62021541595459 15.81097793579102 L 14.60767078399658 9.628581047058105 C 16.34976005554199 7.83079719543457 16.24764633178711 4.854088306427002 14.30443000793457 3.195547580718994 Z" fill="none" stroke="#e31414" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                                      allowDrawingOutsideViewBox:
                                                          true,
                                                      fit: BoxFit.fill,
                                                      width: 16.w,
                                                      height: 14.w,
                                                    ),
                                            ),
                                            onTap: () {
                                              if (GetStorage().hasData('token'))
                                                apiBloc.doAction(
                                                    param: BaseStatefulState
                                                        .addServiceInfo(Map(),
                                                            data: {
                                                          'method': 'post',
                                                          'url': FAVORITE_API,
                                                          'type': 'product',
                                                          'favoriateable_id':
                                                              data.data?.id
                                                                  .toString(),
                                                          'status': !(data
                                                                  .data
                                                                  ?.userReactions
                                                                  ?.isFavorited ??
                                                              false)
                                                        }),
                                                    supportLoading: true,
                                                    supportErrorMsg: false,
                                                    onResponse: (json) {
                                                      if (isSuccess(json)) {
                                                        context
                                                            .read(
                                                                productsProvider
                                                                    .notifier)
                                                            .updateFavoriteState(
                                                                data.data?.id
                                                                        ?.toString() ??
                                                                    '-1',
                                                                !(data
                                                                        .data
                                                                        ?.userReactions
                                                                        ?.isFavorited ??
                                                                    false));
                                                        context
                                                            .read(
                                                                productsDetailsProvider
                                                                    .notifier)
                                                            .updateFavoriteState(
                                                                data.data?.id
                                                                        ?.toString() ??
                                                                    '-1',
                                                                !(data
                                                                        .data
                                                                        ?.userReactions
                                                                        ?.isFavorited ??
                                                                    false));
                                                      }
                                                    });
                                              else
                                                goTo(LoginScreen.generatePath(),
                                                    transition: TransitionType
                                                        .inFromTop);
                                            },
                                          ),
                                          SizedBox(
                                            height: 15.w,
                                          ),
                                          InkWell(
                                            child: SvgPicture.string(
                                              '<svg viewBox="42.5 231.0 15.8 18.1" ><path transform="translate(42.52, 231.0)" d="M 12.44827651977539 11.31661510467529 C 11.64875888824463 11.31661510467529 10.91392135620117 11.59313106536865 10.33383941650391 12.05555534362793 L 6.709480762481689 9.790321350097656 C 6.816812038421631 9.304819107055664 6.816812038421631 8.801731109619141 6.709480762481689 8.316227912902832 L 10.33383941650391 6.050993919372559 C 10.91392135620117 6.513454914093018 11.64875888824463 6.789969444274902 12.44827651977539 6.789969444274902 C 14.32326412200928 6.789969444274902 15.84326267242432 5.269970893859863 15.84326267242432 3.394984722137451 C 15.84326267242432 1.51999819278717 14.32326412200928 0 12.44827651977539 0 C 10.57329082489014 0 9.053292274475098 1.51999831199646 9.053292274475098 3.394984722137451 C 9.053292274475098 3.648123025894165 9.081231117248535 3.894683837890625 9.133781433105469 4.132014274597168 L 5.509423732757568 6.397247791290283 C 4.929341316223145 5.934822082519531 4.194503784179688 5.658307552337646 3.394984722137451 5.658307552337646 C 1.51999831199646 5.658307552337646 0 7.178306102752686 0 9.053292274475098 C 0 10.92827796936035 1.51999831199646 12.44827651977539 3.394984722137451 12.44827651977539 C 4.194503784179688 12.44827651977539 4.929341316223145 12.17176246643066 5.509423732757568 11.70933723449707 L 9.133781433105469 13.97457027435303 C 9.08021068572998 14.21658611297607 9.053220748901367 14.46372604370117 9.053292274475098 14.7116003036499 C 9.053292274475098 16.58658599853516 10.57329082489014 18.1065845489502 12.44827651977539 18.1065845489502 C 14.32326412200928 18.1065845489502 15.84326267242432 16.58658599853516 15.84326267242432 14.7116003036499 C 15.84326267242432 12.83661365509033 14.32326412200928 11.31661510467529 12.44827651977539 11.31661510467529 Z" fill="#3876ba" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                                              allowDrawingOutsideViewBox: true,
                                              fit: BoxFit.fill,
                                              width: 16.w,
                                              height: 19.w,
                                            ),
                                            onTap: () {
                                              Share.share(
                                                  'check out my website ${data.data?.shareUrl ?? ''}',
                                                  subject: 'Look what I made!');
                                            },
                                          )
                                        ],
                                      ),
                                      left: 30.w,
                                      top: 50.w,
                                    )
                                  ],
                                ),
                                (data.data?.brand ?? null) != null
                                    ? Container(
                                        width: 327.0.w,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Expanded(
                                              child: TextResponsive(
                                                data.data?.brand?.name ?? '',
                                                style: TextStyle(
                                                  fontSize: 23,
                                                  color:
                                                      const Color(0xff3876ba),
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Container(
                                              child: CachedNetworkImage(
                                                imageUrl: data
                                                        .data
                                                        ?.brand
                                                        ?.logo
                                                        ?.conversions
                                                        ?.large
                                                        ?.url ??
                                                    '',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.contain),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    ImageLoaderPlaceholder(),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    ImageLoaderErrorWidget(),
                                              ),
                                              width: 60.w,
                                              height: 40.w,
                                            ),
                                          ],
                                        ))
                                    : Container(),
                                Container(
                                  width: 327.w,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextResponsive(
                                            'اسم المنتج:',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: const Color(0xff707070),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Flexible(
                                            child: TextResponsive(
                                              data.data?.title ?? '',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xff707070),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextResponsive(
                                            'نوع المنتج:',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: const Color(0xff707070),
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          Flexible(
                                            child: TextResponsive(
                                              data.data?.category?.name ?? '',
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xff707070),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Container(
                                            margin: EdgeInsetsResponsive.only(
                                                top: 3),
                                            child: Row(
                                              children: [
                                                RatingBar(
                                                  initialRating: double.parse(
                                                      data.data!.stats!
                                                              .reviewsAvg ??
                                                          '0.0'),
                                                  minRating: 5,
                                                  textDirection:
                                                      TextDirection.ltr,
                                                  direction: Axis.horizontal,
                                                  allowHalfRating: false,
                                                  itemCount: 5,
                                                  ignoreGestures: true,
                                                  itemSize: 14.w,
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
                                                  itemPadding:
                                                      EdgeInsets.symmetric(
                                                          horizontal: 2.w),
                                                  onRatingUpdate: (rating) {
                                                    print(rating);
                                                  },
                                                ),
                                                SizedBox(
                                                  width: 5.w,
                                                ),
                                                TextResponsive(
                                                  '[${data.data!.stats!.reviewsCount.toString()}]',
                                                  style: TextStyle(
                                                    fontSize:
                                                        AppFactory.getFontSize(
                                                            15.0, toString()),
                                                    color: AppFactory.getColor(
                                                        'gray_1', toString()),
                                                  ),
                                                  textAlign: TextAlign.right,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //
                                          TextResponsive(
                                            'السعر:',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: const Color(0xff707070),

                                              //  decoration:
                                              //  TextDecoration.lineThrough,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          TextResponsive(
                                            data.data?.price?.formatted ?? '',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontFamily: 'roboto',
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xff707070),
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 10.w,
                                      ),
                                      /*
                                       Column(
                                        children: data.data?.variations
                                                ?.map((variation) => Container(
                                                      child: Center(
                                                        child: AppTextField(
                                                          isDropDown: true,
                                                          width: 329.w,
                                                          onSelectedValue:
                                                              (city) {
                                                            context
                                                                .read(productsDetailsProvider
                                                                    .notifier)
                                                                .getDetails(city[
                                                                        'id']
                                                                    .toString());
                                                          },
                                                          supportDecoration:
                                                              true,
                                                          items:
                                                              variation.options
                                                                  ?.map((e) => {
                                                                        'name':
                                                                            e.option,
                                                                        'id': e
                                                                            .productId
                                                                      })
                                                                  .toList(),
                                                          name: variation
                                                              .property!,
                                                          validator:
                                                              RequiredValidator(
                                                                  errorText:
                                                                      errorText()),
                                                          icon: Assets.icons
                                                              .iconAwesomeCity
                                                              .svg(
                                                                  width: 12.w,
                                                                  height: 14.w,
                                                                  color: Colors
                                                                      .transparent),
                                                        ),
                                                      ),
                                                      margin:
                                                          EdgeInsetsResponsive
                                                              .only(top: 10),
                                                    ))
                                                .toList() ??
                                            [],
                                      ),
                                       */
                                      List.from((data.data?.getOptions(
                                                          widget.id) ??
                                                      []))
                                                  .length >
                                              0
                                          ? Container(
                                              child: ListView.builder(
                                                itemBuilder: (context, index) =>
                                                    VariItem(List.from(
                                                        (data.data?.getOptions(
                                                                widget.id) ??
                                                            []))[index]),
                                                itemCount: List.from((data.data
                                                            ?.getOptions(
                                                                widget.id) ??
                                                        []))
                                                    .length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                              ),
                                              height: 200.h,
                                            )
                                          : SizedBox(),
                                      SizedBox(
                                        height: 20.w,
                                      ),
                                      Row(
                                        children: [
                                          TextResponsive(
                                            'كمية الطلب :',
                                            style: TextStyle(
                                              fontSize: 19,
                                              color: const Color(0xff3876ba),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          Expanded(
                                            child: TextFormField(
                                              decoration: InputDecoration(
                                                  enabledBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff3876ba)),
                                                  ),
                                                  focusedBorder:
                                                      UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                        color:
                                                            Color(0xff3876ba)),
                                                  ),
                                                  isDense: true),
                                              controller: quantity,
                                              textInputAction:
                                                  TextInputAction.done,
                                              keyboardType:
                                                  TextInputType.number,
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xff3876ba),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 60.w,
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //
                                          TextResponsive(
                                            'السعر الكلي:',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: const Color(0xff707070),
                                              //  decoration:
                                              //  TextDecoration.lineThrough,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            width: 5.w,
                                          ),
                                          TotalPriceWidget(
                                              quantity: quantity, data: data)
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: MainAppButton(
                                            width: 250.w,
                                            name: 'إضافة إلى سلة المشتريات',
                                            bgColor: Color(0xff3876ba),
                                            onClick: () {
                                              if (GetStorage()
                                                  .hasData('token')) {
                                                if (quantity.text.length > 0)
                                                  context
                                                      .read(cartActionsProvider
                                                          .notifier)
                                                      .addToCart({
                                                    'product_id': widget.id,
                                                    'quantity': quantity.text,
                                                  }, supportNav: true);
                                                else
                                                  showFlash('ادخل كمية الطلب');
                                              } else
                                                goTo(LoginScreen.generatePath(),
                                                    transition: TransitionType
                                                        .inFromTop);
                                            }),
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      buildSectionTitle(
                                          AppFactory.getLabel(
                                              'product_description',
                                              'تفاصيل المنتج'),
                                          bottom: 5,
                                          right: 0,
                                          top: 10,
                                          left: 0),
                                      Html(data: data.data?.description ?? ''),
                                      InkWell(
                                        onTap: () {
                                          if (GetStorage().hasData('token'))
                                            showDialog(
                                                context: context,
                                                barrierColor:
                                                    Colors.transparent,
                                                barrierDismissible: true,
                                                useSafeArea: false,
                                                builder: (_) => AddRatingDialog(
                                                      data.data!.id.toString(),
                                                      type: 'product',
                                                    )).then((value) {
                                              if (value != null &&
                                                  value == 'success') {
                                                context
                                                    .read(
                                                        productsDetailsProvider
                                                            .notifier)
                                                    .updateRatingState(true);
                                              }
                                            });
                                          else
                                            goTo(LoginScreen.generatePath(),
                                                transition:
                                                    TransitionType.inFromTop);
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0.w),
                                              topRight: Radius.circular(10.0.w),
                                            ),
                                            color: AppFactory.getColor(
                                                'orange', toString()),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0x29000000),
                                                offset: Offset(0, 3),
                                                blurRadius: 6,
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: TextResponsive(
                                              (data.data?.userReactions
                                                          ?.isReviewed ??
                                                      false)
                                                  ? 'تعديل تقييمك'
                                                  : 'أضف تقييم',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: const Color(0xffffffff),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          height: 62.w,
                                        ),
                                      ),
                                      buildSectionTitle(
                                          AppFactory.getLabel(
                                                  'rating', 'التقييمات:') +
                                              ' (' +
                                              (data.data?.stats?.reviewsCount ??
                                                  '0') +
                                              ')',
                                          bottom: 5,
                                          right: 0,
                                          left: 0),
                                      SizedBox(
                                        height: 20.w,
                                      ),
                                    ],
                                  ),
                                ),
                                RatingSFWidget(
                                  data.data?.id?.toString() ?? '-1',
                                  type: 'product',
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                              ],
                            ),
                          ),
                        );
                      }, error: (e) {
                        return Container();
                      });
                    },
                  ),
                ],
              ),
            ))));
  }

  TextEditingController quantity = TextEditingController();

  Column buildDocumentType(String name, Widget icon) {
    return Column(
      children: [
        Container(
          width: 47.0.w,
          height: 43.0.w,
          child: icon,
        ),
        SizedBox(
          height: 5.h,
        ),
        TextResponsive(
          name,
          style: TextStyle(
            fontSize: 15.0,
            color: AppFactory.getColor('primary', toString()),
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Map<String, dynamic> getServices() {
    Map<String, dynamic> servicesMap = Map();

    for (var element in servicesData) {
      Map<String, dynamic> temp = Map();
      temp['description'] = element['description'];
      temp['is_enabled'] = element['enable'];
      if (element['doctors'] != null) {
        temp['doctors'] = [];
        for (int i = 0; i < element['doctors'].length; i++) {
          temp['doctors[$i]'] = element['doctors'][i];
        }
      }
      servicesMap[element['id']] = temp;
      //openingHours[element['id']][element['from']]=element['to'];

    }

    return servicesMap;
  }

  Map<String, dynamic> getImages() {
    Map<String, dynamic> imagesData = Map();

    for (var element in images) {
      Map<String, dynamic> temp = Map();
      temp['is_main'] = element['is_main'];
      imagesData[element['id'].toString()] = temp;
    }

    return imagesData;
  }

  Map<String, dynamic> getOpeningHours() {
    Map<String, dynamic> openingHours = Map();

    for (var element in days) {
      if (element['from'] != null) {
        Map<String, dynamic> temp = Map();
        temp[element['from']] = element['to'];
        openingHours[element['id']] = temp;
        //openingHours[element['id']][element['from']]=element['to'];
      }
    }

    return openingHours;
  }

  getStartLocation(ServiceDetails data) {
    try {
      return LatLng(
          double.parse(
              (data.data!.location!.coordinates!.latitude ?? 0.0).toString()),
          double.parse(
              (data.data!.location!.coordinates!.longitude ?? 0.0).toString()));
    } catch (e) {}
    return null;
  }
}

class VariItem extends StatefulWidget {
  dynamic option;

  VariItem(this.option);
  @override
  _VariItemState createState() => _VariItemState();
}

class _VariItemState extends BaseStatefulState<VariItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      child: Card(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsetsResponsive.all(10),
          child: Column(
            children: [
              Container(
                  width: 80.w,
                  height: 80.w,
                  child: CircularProfileAvatar(
                    widget.option['main_image']['conversions']['large']['url'],
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
              SizedBox(
                height: 10.w,
              ),
              TextResponsive(
                widget.option['title'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: const Color(0xff3876ba),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10.w,
              ),
              MainAppButton(
                  name: 'إضافة إلى سلة المشتريات',
                  fontSize: 12,
                  bgColor: Color(0xff3876ba),
                  onClick: () {
                    if (GetStorage().hasData('token')) {
                      context.read(cartActionsProvider.notifier).addToCart({
                        'product_id': widget.option['product_id'],
                        'quantity': 1,
                      }, supportNav: true);
                    } else
                      goTo(LoginScreen.generatePath(),
                          transition: TransitionType.inFromTop);
                  })
            ],
          ),
        ),
      ),
    );
  }
}

class TotalPriceWidget extends StatefulWidget {
  const TotalPriceWidget({
    Key? key,
    required this.quantity,
    required this.data,
  }) : super(key: key);

  final TextEditingController quantity;
  final ProductDataDetails data;

  @override
  _TotalPriceWidgetState createState() => _TotalPriceWidgetState();
}

class _TotalPriceWidgetState extends State<TotalPriceWidget> {
  @override
  void initState() {
    widget.quantity.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextResponsive(
      ((widget.quantity.text.length > 0 ? int.parse(widget.quantity.text) : 1) *
                  double.parse(widget.data.data?.price?.value ?? '0'))
              .toString() +
          ' IQD',
      //+(widget.data.data?.price?.currency ?? ''),
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'roboto',
        fontWeight: FontWeight.bold,
        color: const Color(0xff707070),
      ),
      textAlign: TextAlign.start,
    );
  }
}

class IconBtnWidget extends StatelessWidget {
  final Widget icon;
  final Color? color;

  const IconBtnWidget({Key? key, this.color, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0.w),
        border: Border.all(width: 1.0, color: color ?? const Color(0xff3876ba)),
      ),
      margin: EdgeInsetsResponsive.only(right: 5, left: 5),
      constraints: BoxConstraints(minWidth: 64.w, minHeight: 36.w),
      child: Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [icon],
        ),
      ),
    );
  }
}

class ServicesSection extends StatefulWidget {
  final List<dynamic> data;

  ServicesSection(this.data);

  @override
  _ServicesSectionState createState() => _ServicesSectionState();
}

class _ServicesSectionState extends BaseStatefulState<ServicesSection> {
  @override
  void initState() {
    super.initState();
  }

  isServiceClicked() {
    int index = -1;
    for (var d in widget.data) {
      index++;
      if (d['selected'] && index <= 2) {
        return true;
      }
    }
    return false;
  }

  getSelected() {
    for (var d in widget.data) {
      if (d['selected']) {
        return d;
      }
    }
  }

  isService2RowClicked() {
    int index = -1;
    for (var d in widget.data) {
      index++;
      if (d['selected'] && index > 2) {
        return true;
      }
    }
    return false;
  }

  getSelectedService() {
    for (var d in widget.data) {
      if (d['selected']) {
        return d;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Wrap(
                runSpacing: isServiceClicked()
                    ? 180.h +
                        (getSelectedService()['id'] == 'veterinary_clinic'
                            ? (getSelected()['item_count'] *
                                (45 + getSelected()['item_count'] / 3).h)
                            : 0)
                    : 0,
                spacing: 0,
                children: widget.data
                    .map(
                      (e) => e['enable']
                          ? InkWell(
                              onTap: () {
                                widget.data.forEach((element) {
                                  element['selected'] = false;
                                });
                                e['selected'] = true;
                                setState(() {});
                              },
                              child: Container(
                                height: 109.w,
                                width: 102.w,
                                margin: EdgeInsetsResponsive.only(
                                    left: 5, right: 5),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Assets.images.boxC.image(
                                        height: 109.w,
                                        color: e['selected']
                                            ? AppFactory.getColor(
                                                'primary', toString())
                                            : null),
                                    Column(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        SizedBox(
                                          height: 20.w,
                                        ),
                                        Container(
                                          child: SvgPicture.asset(e['icon'],
                                              height: 21.w, width: 22.w),
                                        ),
                                        SizedBox(
                                          height: 25.w,
                                        ),
                                        TextResponsive(
                                          e['name'],
                                          style: TextStyle(
                                            fontSize: 17.0,
                                            color: e['selected']
                                                ? Colors.white
                                                : AppFactory.getColor(
                                                    'primary', toString()),
                                            height: 0.47,
                                          ),
                                          textAlign: TextAlign.right,
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          : SizedBox(),
                    )
                    .toList(),
              ),
              isServiceClicked()
                  ? Container(
                      margin: EdgeInsets.only(top: 90.w), child: buildContent())
                  : Container()
            ],
          ),
        ),
        isService2RowClicked() ? buildContent() : Container()
      ],
    );
  }

  var formKey = GlobalKey<FormState>();

  buildContent() {
    return Container(
      width: 300.w,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(AppFactory.getLabel('service_desc', 'وصف الخدمة'),
              left: 0, right: 0),
          TextResponsive(
            getSelectedService()['description'],
            style: TextStyle(
              fontSize: 17,
              color: const Color(0xff707070),
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            height: 10.h,
          ),
          getSelectedService() != null &&
                  getSelectedService()['id'] == 'veterinary_clinic'
              ? Column(
                  children: [
                    buildSectionTitle('الأطباء البيطريين'),
                    ListView.builder(
                        itemCount: getSelected()['item_count'],
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsetsResponsive.only(left: 20, right: 20),
                        shrinkWrap: true,
                        itemBuilder: (context, index) => Container(
                              margin: EdgeInsets.only(top: 10.w),
                              child: Row(
                                children: [
                                  Assets.icons.doctor.svg(
                                    width: 19.w,
                                    color: AppFactory.getColor(
                                        'primary', toString()),
                                    height: 24.w,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: TextResponsive(
                                      getSelected()['doctors'][index]['name'],
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: const Color(0xff707070),
                                      ),
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ],
                )
              : Container(),
          SizedBox(
            height: 15.w,
          ),
        ],
      ),
    );
  }

  getDoctorName(int index) {
    try {
      return getSelectedService()['doctors'][index - 1];
    } catch (e) {}
    return null;
  }
}

class ImagesWidget extends StatefulWidget {
  final Function(List<dynamic>) onUpdateImages;

  ImagesWidget(this.onUpdateImages);

  @override
  _ImagesWidgetState createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends BaseStatefulState<ImagesWidget> {
  List<dynamic> mainImages = [];
  List<dynamic> otherImages = [];

  @override
  void initState() {
    mainImages = [
      {'state': 0, 'url': ''},
      {'state': 0, 'url': ''}
    ];
    otherImages = [
      {'state': 0, 'url': ''},
      {'state': 0, 'url': ''},
      {'state': 0, 'url': ''}
    ];
    super.initState();
  }

  getImages() {
    List<dynamic> temp = [];
    mainImages.forEach((element) {
      if (element['id'] != null) {
        element['is_main'] = true;
        temp.add(element);
      }
    });
    otherImages.forEach((element) {
      if (element['id'] != null) {
        element['is_main'] = false;
        temp.add(element);
      }
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: 309.w,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: mainImages
                  .map(
                    (e) => Container(
                      height: 113.0.w,
                      width: 144.w,
                      child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10.0.w),
                          ),
                          child: e['state'] != 1
                              ? ImagePickerWidget(
                                  url: e['url'],
                                  onResult: (files) {
                                    setState(() {
                                      e['state'] = 1;
                                    });
                                    files.forEach((file) async {
                                      apiBloc.doAction(
                                          param: BaseStatefulState
                                              .addServiceInfo(Map(), data: {
                                            'url': ATTACHMENTS_API,
                                            'method': 'post',
                                            'file':
                                                await getImageMultiPart(file),
                                          }),
                                          supportLoading: false,
                                          supportErrorMsg: false,
                                          onResponse: (json) {
                                            e['url'] = json['data']['url'];
                                            e['id'] = json['data']['id'];
                                            widget.onUpdateImages
                                                .call(getImages());
                                            setState(() {
                                              e['state'] = 2;
                                            });
                                          });
                                    });
                                  },
                                  emptyWidget: Center(
                                      child: Assets.icons.iconMaterialFileUpload
                                          .svg(width: 21.w, height: 26.w)),
                                )
                              : ImageLoaderPlaceholder()),
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
                  )
                  .toList(),
            )),
        SizedBox(
          height: 25.h,
        ),
        Container(
            width: 309.w,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: otherImages
                  .map(
                    (e) => Container(
                      height: 113.0.w,
                      width: 100.w,
                      child: ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(10.0.w),
                          ),
                          child: e['state'] != 1
                              ? ImagePickerWidget(
                                  url: e['url'],
                                  onResult: (files) {
                                    setState(() {
                                      e['state'] = 1;
                                    });
                                    files.forEach((file) async {
                                      apiBloc.doAction(
                                          param: BaseStatefulState
                                              .addServiceInfo(Map(), data: {
                                            'url': ATTACHMENTS_API,
                                            'method': 'post',
                                            'file':
                                                await getImageMultiPart(file),
                                          }),
                                          supportLoading: false,
                                          supportErrorMsg: false,
                                          onResponse: (json) {
                                            e['url'] = json['data']['url'];
                                            e['id'] = json['data']['id'];
                                            widget.onUpdateImages
                                                .call(getImages());
                                            setState(() {
                                              e['state'] = 2;
                                            });
                                          });
                                    });
                                  },
                                  emptyWidget: Center(
                                      child: Assets.icons.iconMaterialFileUpload
                                          .svg(width: 21.w, height: 26.w)),
                                )
                              : ImageLoaderPlaceholder()),
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
                  )
                  .toList(),
            ))
      ],
    );
  }
}

class OtherMediaWidget extends StatefulWidget {
  @override
  _OtherMediaWidgetState createState() => _OtherMediaWidgetState();
}

class _OtherMediaWidgetState extends BaseStatefulState<OtherMediaWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildSectionTitle('رفع فيديو'),
        Container(
          margin: EdgeInsetsResponsive.only(left: 5, right: 5),
          height: 113.0.w,
          width: 309.w,
          child: Stack(
            children: [
              Center(
                child: Assets.icons.iconMetroYoutubePlay
                    .svg(width: 35.w, height: 34.w),
              )
            ],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0.w),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    AppFactory.getColor('gray_1', toString()).withOpacity(0.12),
                offset: Offset(0, 2.0),
                blurRadius: 14.0,
              ),
            ],
          ),
        ),
        buildSectionTitle('رفع صورة للأم'),
        Container(
          margin: EdgeInsetsResponsive.only(left: 5, right: 5),
          height: 113.0.w,
          width: 309.w,
          child: Stack(
            children: [],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0.w),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    AppFactory.getColor('gray_1', toString()).withOpacity(0.12),
                offset: Offset(0, 2.0),
                blurRadius: 14.0,
              ),
            ],
          ),
        ),
        buildSectionTitle('رفع صورة للأب'),
        Container(
          margin: EdgeInsetsResponsive.only(left: 5, right: 5),
          height: 113.0.w,
          width: 309.w,
          child: Stack(
            children: [],
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0.w),
            ),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color:
                    AppFactory.getColor('gray_1', toString()).withOpacity(0.12),
                offset: Offset(0, 2.0),
                blurRadius: 14.0,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class SwitchWidget extends StatefulWidget {
  bool selected;
  final Function(bool) onChanged;

  SwitchWidget(this.selected, this.onChanged);

  @override
  _SwitchWidgetState createState() => _SwitchWidgetState();
}

class _SwitchWidgetState extends State<SwitchWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.selected = !widget.selected;
        });
        widget.onChanged.call(widget.selected);
      },
      child: Container(
        width: 38.w,
        height: 17.w,
        child: Stack(
          children: [
            Center(
              child: Container(
                height: 7.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(11.0),
                  color: widget.selected ? Color(0xfffeca2e) : Colors.grey,
                  border: Border.all(
                      width: 1.0,
                      color: widget.selected ? Color(0xfffeca2e) : Colors.grey),
                ),
              ),
            ),
            Align(
              alignment: !widget.selected
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                width: 17.w,
                height: 17.w,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
                  color: widget.selected ? Color(0xfffeca2e) : Colors.grey,
                  border:
                      Border.all(width: 1.0, color: const Color(0xffffffff)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsetsResponsive.only(top: 10),
            height: 158.w,
            width: 307.w,
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
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: EdgeInsetsResponsive.only(top: 3),
            height: 20.w,
            width: 307.w,
            child: SizedBox.expand(
              child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0.w),
                  ),
                  child: Shimmer.fromColors(
                      baseColor: getBaseColor(),
                      highlightColor: getHighlightColor(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                      ))),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0.w),
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
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 20.w,
              ),
              Container(
                width: 60.w,
                height: 60.w,
                child: SizedBox.expand(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(1000.0.w),
                      ),
                      child: Shimmer.fromColors(
                          baseColor: getBaseColor(),
                          highlightColor: getHighlightColor(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ))),
                ),
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: Color(0xFFe0f2f1)),
              ),
              SizedBox(
                width: 20.w,
              ),
              Container(
                margin: EdgeInsetsResponsive.only(top: 3),
                height: 15.w,
                width: 200.w,
                child: SizedBox.expand(
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0.w),
                      ),
                      child: Shimmer.fromColors(
                          baseColor: getBaseColor(),
                          highlightColor: getHighlightColor(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ))),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0.w),
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
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Column(
            children: [1, 2, 3, 4]
                .map((e) => Container(
                      margin: EdgeInsetsResponsive.only(top: 15),
                      height: 5.w,
                      width: 300.w,
                      child: SizedBox.expand(
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0.w),
                            ),
                            child: Shimmer.fromColors(
                                baseColor: getBaseColor(),
                                highlightColor: getHighlightColor(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                ))),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0.w),
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
                    ))
                .toList(),
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            margin: EdgeInsetsResponsive.only(top: 3),
            height: 158.w,
            width: 307.w,
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
          ),
        ],
      ),
    );
  }
}

class RatingSFWidget extends StatefulWidget {
  final String id;
  final String type;

  RatingSFWidget(this.id, {this.type = 'service_center'});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingSFWidget> {
  @override
  void initState() {
    Future.delayed(
        Duration.zero,
        () => context
            .read(reviewsProvider(widget.type).notifier)
            .load(widget.id));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final response = watch(reviewsProvider(widget.type));
        return response.when(idle: () {
          return Container();
        }, loading: () {
          return RatingLoaderWidget();
        }, data: (map) {
          Reviews reviews = Reviews.fromMap(map);
          return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsetsResponsive.only(bottom: 20, top: 10),
            itemBuilder: (context, index) => Container(
              padding: EdgeInsetsResponsive.all(20),
              margin: EdgeInsetsResponsive.only(top: 5),
              decoration: BoxDecoration(
                color: Color(0xfff4f4f4),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: TextResponsive(
                          reviews.data?[index].breeder?.fullName ?? '',
                          style: TextStyle(
                            fontSize: 15,
                            color: const Color(0xff3876ba),
                            height: 1.5714285714285714,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      RatingBar(
                        initialRating: double.parse(
                            reviews.data?[index].score?.toString() ?? '0.0'),
                        minRating: 5,
                        textDirection: TextDirection.ltr,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        ignoreGestures: true,
                        itemSize: 14.w,
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
                    ],
                  ),
                  SizedBox(
                    height: 20.w,
                  ),
                  TextResponsive(
                    reviews.data?[index].comment ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: const Color(0xff707070),
                      height: 1.6923076923076923,
                    ),
                    textAlign: TextAlign.right,
                  )
                ],
              ),
            ),
            itemCount: reviews.data?.length ?? 0,
          );
        }, error: (e) {
          return Container();
        });
      },
    );
  }
}

class RatingLoaderWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [1, 2, 3, 4]
            .map(
              (e) => Container(
                margin: EdgeInsetsResponsive.only(top: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 20.w,
                        ),
                        Container(
                          margin: EdgeInsetsResponsive.only(top: 3),
                          height: 15.w,
                          width: 150.w,
                          child: SizedBox.expand(
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0.w),
                                ),
                                child: Shimmer.fromColors(
                                    baseColor: getBaseColor(),
                                    highlightColor: getHighlightColor(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                    ))),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0.w),
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
                        SizedBox(
                          width: 20.w,
                        ),
                        Container(
                          margin: EdgeInsetsResponsive.only(top: 3),
                          height: 10.w,
                          width: 50.w,
                          child: SizedBox.expand(
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10.0.w),
                                ),
                                child: Shimmer.fromColors(
                                    baseColor: getBaseColor(),
                                    highlightColor: getHighlightColor(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                      ),
                                    ))),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0.w),
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
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Column(
                      children: [1, 2, 3, 4]
                          .map((e) => Container(
                                margin: EdgeInsetsResponsive.only(top: 15),
                                height: 5.w,
                                width: 300.w,
                                child: SizedBox.expand(
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10.0.w),
                                      ),
                                      child: Shimmer.fromColors(
                                          baseColor: getBaseColor(),
                                          highlightColor: getHighlightColor(),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                          ))),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0.w),
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
                              ))
                          .toList(),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
