import 'dart:async';

import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:flutter_app/models/api/AnimalDetailsModel.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/models/api/RemindersResponse.dart';
import 'package:flutter_app/providers/AnimalsProvider.dart';
import 'package:flutter_app/providers/RemindersProvider.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogs/AddNoteDialog.dart';
import 'package:flutter_app/ui/dialogs/AddReminderDialog.dart';
import 'package:flutter_app/ui/dialogsss/ChangeStatusDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
import 'package:flutter_app/ui/screen/home/articles/ArticalsScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MainScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyAccountScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyDogsCatsScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/animals/AnimalsDetailsScreen.dart';
import 'package:flutter_app/ui/widget/AppBarWidget.dart';
import 'package:flutter_app/ui/widget/AppBtnWidget.dart';
import 'package:flutter_app/ui/widget/AppTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/BottomSliderWidget.dart';
import 'package:flutter_app/ui/widget/CustomTextFieldWidget.dart';
import 'package:flutter_app/ui/widget/DogCatSelectWidget.dart';
import 'package:flutter_app/ui/widget/FilterWidget.dart';
import 'package:flutter_app/ui/widget/FooterWidget.dart';
import 'package:flutter_app/ui/widget/LogoWidget.dart';
import 'package:flutter_app/ui/widget/MainSliderWidget.dart';
import 'package:flutter_app/ui/widget/RadioButtonsLargeWidget.dart';
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
import 'package:share/share.dart';
import 'dart:js' as js;

import 'AddDogsCatsScreen.dart';
import 'OwnershipChangeScreen.dart';

class DetailsScreen extends StatefulWidget {
  static const String PATH = '/dogs-cat-details';
  final String id;

  DetailsScreen(this.id);

  static String generatePath(String id) {
    Map<String, dynamic> parameters = {'id': id};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends BaseStatefulState<DetailsScreen> {
  AuthResponse? authResponse;

  @override
  void initState() {
    authResponse = AuthResponse.fromMap(GetStorage().read('account'));

    Future.delayed(
        Duration.zero,
        () => context
            .read(animalsDetailsProvider.notifier)
            .getDetails(widget.id));
    Future.delayed(Duration.zero,
        () => context.read(remindersProvider(widget.id).notifier).load());

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
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 50.h,
                  ),
                  AppBarWidget('', (pageId) {
                    goTo(
                        HomeScreen.generatePath(
                          pageId: pageId,
                        ),
                        clearStack: true);
                  }),
                  Expanded(child: Consumer(
                    builder: (context, watch, child) {
                      final response = watch(animalsDetailsProvider);
                      return response.when(idle: () {
                        return Container();
                      }, loading: () {
                        return LoaderWidget();
                      }, data: (map) {
                        AnimalsDetails data = AnimalsDetails.fromJson(map);
                        return SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsetsResponsive.only(bottom: 50),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20.h,
                                ),
                                Container(
                                  padding: EdgeInsetsResponsive.only(
                                      left: 10, right: 10, top: 3, bottom: 5),
                                  child: TextResponsive(
                                    data.data?.code ?? '',
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: AppFactory.getColor(
                                          'primary', toString()),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                data.data?.getMedia().length > 0
                                    ? MainSliderWidget(
                                        data: data.data?.getMedia(),
                                        supportAuto: false,
                                        supportRound: true,
                                      )
                                    : SizedBox(),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    InkWell(
                                      child: buildCircleIconBtn(
                                        Padding(
                                          padding: EdgeInsetsResponsive.all(5),
                                          child: Assets
                                              .icons.iconAwesomeShareAlt
                                              .svg(
                                            width: 11.w,
                                            height: 11.w,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Share.share(
                                            'check out my website ${data.data?.shareUrl ?? ''}',
                                            subject: 'Look what I made!');
                                      },
                                    ),
                                    InkWell(
                                      child: buildCircleIconBtn(
                                        Padding(
                                          padding: EdgeInsetsResponsive.all(5),
                                          child:
                                              Assets.icons.iconMaterialEdit.svg(
                                            width: 11.w,
                                            height: 11.w,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        goTo(AddDogsCatsScreen.generatePath(
                                            id: widget.id));
                                      },
                                    ),
                                    InkWell(
                                      child: buildCircleIconBtn(
                                        Padding(
                                          padding: EdgeInsetsResponsive.all(5),
                                          child: Assets.icons.iconMaterialDelete
                                              .svg(
                                            width: 11.w,
                                            height: 11.w,
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        GetIt.I<APIRepository>()
                                            .showConfirmDialog(
                                                'هل تريد الحذف بالتأكيد',
                                                onDone: () {
                                          apiBloc.doAction(
                                              param: BaseStatefulState
                                                  .addServiceInfo(Map(), data: {
                                                'method': 'delete',
                                                'url': ANIMALS_LIST_API +
                                                    '/${widget.id}',
                                              }),
                                              supportLoading: true,
                                              supportErrorMsg: false,
                                              onResponse: (json) {
                                                Future.delayed(
                                                    Duration.zero,
                                                    () => context
                                                        .read(animalsProvider
                                                            .notifier)
                                                        .load(
                                                            idBreeder: authResponse
                                                                    ?.data
                                                                    ?.user
                                                                    ?.id
                                                                    ?.toString() ??
                                                                null));
                                                Navigator.pop(context);
                                              });
                                        });
                                      },
                                    ),

                                    /*

                                     */
                                    SizedBox(
                                      width: 10.w,
                                    )
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsResponsive.only(
                                      left: 25, right: 25),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: buildKeyValue(
                                            '', data.data?.offer?.desc ?? ''),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 10.w,
                                ),
                                Container(
                                  width: 327.w,
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: buildKeyValue('الاسم:',
                                                data.data?.name ?? ''),
                                          ),
                                          data.data?.properties?.isHybrid !=
                                                  null
                                              ? Expanded(
                                                  flex: 1,
                                                  child: buildKeyValue(
                                                      'النقاوة:',
                                                      (data.data?.properties
                                                                  ?.isHybrid ??
                                                              false)
                                                          ? 'هجين'
                                                          : 'نقي'),
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      Row(
                                        children: [
                                          data.data?.species != null
                                              ? Expanded(
                                                  flex: 1,
                                                  child: buildKeyValue(
                                                      'الفصيلة الأولى :',
                                                      data.data?.species
                                                              ?.name ??
                                                          ''),
                                                )
                                              : SizedBox(),
                                          data.data?.hybridSpecies != null
                                              ? Expanded(
                                                  flex: 1,
                                                  child: buildKeyValue(
                                                      'الفصيلة الثانية :',
                                                      data.data?.hybridSpecies
                                                              ?.name ??
                                                          ''),
                                                )
                                              : SizedBox()
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: buildKeyValue('العمر :',
                                                data.data?.age?.friendly ?? '',
                                                forceView: true),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: buildKeyValue('الجنس :',
                                                data.data?.gender?.desc ?? ''),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      Row(
                                        children: [
                                          data.data?.properties?.isSterilized !=
                                                  null
                                              ? Expanded(
                                                  flex: 1,
                                                  child: buildKeyValue(
                                                      'القابلية للتكاثر :',
                                                      (data.data?.properties
                                                                  ?.isSterilized ??
                                                              false)
                                                          ? 'معقم'
                                                          : 'طبيعي'),
                                                )
                                              : SizedBox(),
                                          Expanded(
                                            flex: 1,
                                            child: buildKeyValue('اللون :',
                                                data.data?.color?.name ?? ''),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15.w,
                                      ),
                                      Row(
                                        children: [
                                          data.data?.properties?.hairStyle !=
                                                  null
                                              ? Expanded(
                                                  flex: 1,
                                                  child: buildKeyValue(
                                                      'طول الشعر :',
                                                      data
                                                              .data
                                                              ?.properties
                                                              ?.hairStyle
                                                              ?.desc ??
                                                          ''),
                                                )
                                              : SizedBox(),
                                          Expanded(
                                            flex: 1,
                                            child: buildKeyValue(
                                                'نمط توزيع لون الفرو :',
                                                data.data?.colorPattern?.name ??
                                                    ''),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 25.w,
                                ),
                                Container(
                                  width: 309.w,
                                  height: 0.1,
                                  color: AppFactory.getColor(
                                      'primary', toString()),
                                ),
                                (data.data?.extraDescription ?? '').length > 0
                                    ? Column(
                                        children: [
                                          SizedBox(
                                            height: 15.w,
                                          ),
                                          InfoSLWidget(
                                            desc: data.data?.extraDescription ??
                                                '',
                                            title: 'تفاصيل أخرى',
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                                Container(
                                  width: 319.w,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      data.data?.fatherImage != null
                                          ? Expanded(
                                              child: Column(
                                                children: [
                                                  buildSectionTitle(
                                                      AppFactory.getLabel(
                                                          'father_img',
                                                          'صورة الأب'),
                                                      top: 15.w,
                                                      right: 0,
                                                      left: 0),
                                                  buildImageWidget(data
                                                          .data
                                                          ?.fatherImage
                                                          ?.conversions
                                                          ?.large
                                                          ?.url ??
                                                      ''),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      data.data?.motherImage != null
                                          ? Expanded(
                                              child: Column(
                                              children: [
                                                buildSectionTitle(
                                                    AppFactory.getLabel(
                                                        'mother_img',
                                                        'صورة الأم'),
                                                    top: 15.w,
                                                    right: 0,
                                                    left: 0),
                                                buildImageWidget(data
                                                        .data
                                                        ?.motherImage
                                                        ?.conversions
                                                        ?.large
                                                        ?.url ??
                                                    ''),
                                              ],
                                            ))
                                          : Container(),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 330.w,
                                  child: data.data?.documents != null &&
                                          (data.data?.documents?.length ?? 0) >
                                              0
                                      ? Column(
                                          children: [
                                            buildSectionTitle(
                                                AppFactory.getLabel('doc_pdf',
                                                    'وثائق ( صور أو pdf )'),
                                                right: 0,
                                                left: 0),
                                            DocumentsWidget(
                                                data.data?.documents ?? []),
                                          ],
                                        )
                                      : Container(),
                                ),
                                false
                                    ? Column(
                                        children: [
                                          buildSectionTitle(
                                              'هل تريد تغيير حالة الكلب إلى:'),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          FilterWidget(
                                            onSelected: (data) {
                                              status.value = data;
                                            },
                                          ),
                                          SizedBox(
                                            height: 30.h,
                                          ),
                                          ValueListenableBuilder(
                                            valueListenable: status,
                                            builder: (context, value, child) =>
                                                Visibility(
                                              visible: value != null &&
                                                  (status.value['id'] ==
                                                          'sale' ||
                                                      status.value['id'] ==
                                                          'marriage'),
                                              child: Container(
                                                width: AppFactory.getDimensions(
                                                        303, toString())
                                                    .w,
                                                margin:
                                                    EdgeInsetsResponsive.only(
                                                        bottom: 25),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      width: 28.0.w,
                                                      height: 58.0.w,
                                                      padding:
                                                          EdgeInsetsResponsive
                                                              .all(6),
                                                      child: Assets.icons
                                                          .iconIonicIosPricetag
                                                          .svg(),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .vertical(
                                                          top: Radius.circular(
                                                              10.0),
                                                        ),
                                                        color:
                                                            AppFactory.getColor(
                                                                'orange',
                                                                toString()),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 15.w,
                                                    ),
                                                    Expanded(
                                                        child: Row(
                                                      children: [
                                                        TextResponsive(
                                                          AppFactory.getLabel(
                                                                  'price',
                                                                  'السعر') +
                                                              ':',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color: const Color(
                                                                0xfffeca2e),
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        TextResponsive(
                                                          '1000\$',
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            color: const Color(
                                                                0xff707070),
                                                          ),
                                                          textAlign:
                                                              TextAlign.right,
                                                        )
                                                      ],
                                                    )),
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top:
                                                        Radius.circular(10.0.w),
                                                  ),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: AppFactory.getColor(
                                                        'orange', toString()),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          InfoSLWidget(
                                            desc:
                                                'هاسكي ابيض للبيع باعلى سعر ممكن',
                                            title: 'ملاحظة',
                                          ),
                                        ],
                                      )
                                    : SizedBox(),
                                (data.data?.notes ?? []).length > 0
                                    ? buildSectionTitle('الملاحظات',
                                        bottom: 5.w)
                                    : SizedBox(),
                                Column(
                                  children: data.data?.notes
                                          ?.map((e) => Container(
                                                margin:
                                                    EdgeInsetsResponsive.only(
                                                        top: 10),
                                                child: InfoSLWidget(
                                                  desc: e?.text ?? '',
                                                  title: 'ملاحظة',
                                                  txtColor: Colors.white,
                                                  actions: [
                                                    InkWell(
                                                      child: buildCircleIconBtnSmall(
                                                          Assets.icons
                                                              .iconMaterialDelete
                                                              .svg(
                                                        width: 9.w,
                                                        height: 9.w,
                                                      )),
                                                      onTap: () {
                                                        apiBloc.doAction(
                                                            param: BaseStatefulState
                                                                .addServiceInfo(
                                                                    Map(),
                                                                    data: {
                                                                  'method':
                                                                      'delete',
                                                                  'url': ANIMALS_NOTE_API +
                                                                      '/${e?.id}',
                                                                }),
                                                            supportLoading:
                                                                true,
                                                            supportErrorMsg:
                                                                false,
                                                            onResponse: (json) {
                                                              Future.delayed(
                                                                  Duration.zero,
                                                                  () => context
                                                                      .read(animalsDetailsProvider
                                                                          .notifier)
                                                                      .getDetails(
                                                                          widget
                                                                              .id));
                                                            });
                                                      },
                                                    ),
                                                  ],
                                                  bgColor: AppFactory.getColor(
                                                      'orange', toString()),
                                                ),
                                              ))
                                          .toList() ??
                                      [],
                                ),
                                Consumer(
                                  builder: (context, watch, child) {
                                    final response =
                                        watch(remindersProvider(widget.id));
                                    return response.when(idle: () {
                                      return Container();
                                    }, loading: () {
                                      return ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        padding: EdgeInsetsResponsive.only(
                                            bottom: 40, top: 10),
                                        itemBuilder: (context, index) =>
                                            ArticleLoaderItem(),
                                        itemCount: 10,
                                      );
                                    }, data: (map) {
                                      RemindersResponse data =
                                          RemindersResponse.fromJson(map);
                                      return Column(
                                        children: [
                                          (data.data ?? []).length > 0
                                              ? buildSectionTitle('التذكيرات',
                                                  bottom: 5.w)
                                              : SizedBox(),
                                          Column(
                                            children: data.data
                                                    ?.map((e) => Container(
                                                          margin:
                                                              EdgeInsetsResponsive
                                                                  .only(
                                                                      top: 10),
                                                          child: InfoSLWidget(
                                                            desc: e?.text ?? '',
                                                            title: 'تذكير',
                                                            txtColor:
                                                                Colors.white,
                                                            actions: [
                                                              InkWell(
                                                                child:
                                                                    buildCircleIconBtnSmall(
                                                                        Assets
                                                                            .icons
                                                                            .iconMaterialDelete
                                                                            .svg(
                                                                          width:
                                                                              9.w,
                                                                          height:
                                                                              9.w,
                                                                        ),
                                                                        color: AppFactory.getColor(
                                                                            'primary_1',
                                                                            toString())),
                                                                onTap: () {
                                                                  apiBloc.doAction(
                                                                      param: BaseStatefulState.addServiceInfo(Map(), data: {
                                                                        'method':
                                                                            'delete',
                                                                        'url':
                                                                            'v1/reminders/${e?.id}',
                                                                      }),
                                                                      supportLoading: true,
                                                                      supportErrorMsg: false,
                                                                      onResponse: (json) {
                                                                        Future.delayed(
                                                                            Duration
                                                                                .zero,
                                                                            () =>
                                                                                context.read(remindersProvider(widget.id).notifier).load());
                                                                      });
                                                                },
                                                              ),
                                                            ],
                                                            bgColor: AppFactory
                                                                .getColor(
                                                                    'primary_1',
                                                                    toString()),
                                                          ),
                                                        ))
                                                    .toList() ??
                                                [],
                                          ),
                                        ],
                                      );
                                    }, error: (e) {
                                      return Container();
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 25.h,
                                ),
                                Container(
                                  width: 309.w,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              barrierColor: Colors.transparent,
                                              barrierDismissible: true,
                                              useSafeArea: false,
                                              builder: (_) => AddNoteDialog(
                                                  data.data?.id ?? ''));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0.w),
                                              topRight: Radius.circular(10.0.w),
                                            ),
                                            color: const Color(0xff3876ba),
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
                                              'إضافة ملاحظة',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: const Color(0xffffffff),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          width: 143.w,
                                          height: 62.w,
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              barrierColor: Colors.transparent,
                                              barrierDismissible: true,
                                              useSafeArea: false,
                                              builder: (_) =>
                                                  AddReminderDialog(widget.id));
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0.w),
                                              topRight: Radius.circular(10.0.w),
                                            ),
                                            color: const Color(0xff3876ba),
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
                                              'تذكير',
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: const Color(0xffffffff),
                                              ),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          width: 143.w,
                                          height: 62.w,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),
                                InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        barrierColor: Colors.transparent,
                                        barrierDismissible: true,
                                        useSafeArea: false,
                                        builder: (_) => ChangeStatusDialog(
                                              widget.id,
                                              selectedId:
                                                  data.data?.status?.id ?? '',
                                            ));
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: AppFactory.getColor(
                                              'orange', toString())),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0.w),
                                        topRight: Radius.circular(10.0.w),
                                      ),
                                      color: const Color(0xff3876ba),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x29000000),
                                          offset: Offset(0, 3),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Assets.icons.group741
                                              .svg(width: 39.w, height: 32.w),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          TextResponsive(
                                            'تغيير الحالة',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: AppFactory.getColor(
                                                  'orange', toString()),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                    width: 309.w,
                                    height: 62.w,
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                )
                                /*InkWell(
                                  onTap: () {
                                    goTo(OwnershipChangeScreen.generatePath());
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 2,
                                          color: AppFactory.getColor(
                                              'orange', toString())),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10.0.w),
                                        topRight: Radius.circular(10.0.w),
                                      ),
                                      color: const Color(0xff3876ba),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0x29000000),
                                          offset: Offset(0, 3),
                                          blurRadius: 6,
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Assets.icons.group741
                                              .svg(width: 39.w, height: 32.w),
                                          SizedBox(
                                            width: 20.w,
                                          ),
                                          TextResponsive(
                                            'نقل الملكية',
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: AppFactory.getColor(
                                                  'orange', toString()),
                                            ),
                                            textAlign: TextAlign.right,
                                          ),
                                        ],
                                      ),
                                    ),
                                    width: 309.w,
                                    height: 62.w,
                                  ),
                                ),
                                SizedBox(
                                  height: 15.h,
                                ),*/
                              ],
                            ),
                          ),
                        );
                      }, error: (e) {
                        return Container();
                      });
                    },
                  )),
                ],
              ),
            ],
          ),
        )));
  }

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
            color: AppFactory.getColor('gray_1', toString()),
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }

  Column buildHireType(String name, Widget icon) {
    return Column(
      children: [
        Container(
          width: 62.0.w,
          height: 62.0.w,
          padding: EdgeInsetsResponsive.all(7),
          child: icon,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: Colors.white,
            border: Border.all(
              width: 1.0,
              color: AppFactory.getColor('gray_1', toString()),
            ),
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
        TextResponsive(
          name,
          style: TextStyle(
            fontSize: 15.0,
            color: AppFactory.getColor('gray_1', toString()),
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class InfoSLWidget extends StatelessWidget {
  final String title;
  final String desc;
  final Color? bgColor;
  final Color? txtColor;
  final List<Widget>? actions;

  const InfoSLWidget(
      {Key? key,
      this.txtColor,
      this.actions,
      required this.title,
      required this.desc,
      this.bgColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 311.w,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.w),
                topRight: Radius.circular(10.w),
              ),
              color: bgColor ?? Color(0xffffffff),
              border: Border.all(width: 1.0, color: const Color(0xfffeca2e)),
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsetsResponsive.only(
                      right: 20, top: 20, left: 20, bottom: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextResponsive(
                          desc,
                          style: TextStyle(
                            fontSize: 17,
                            color: txtColor ?? Color(0xff707070),
                          ),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48.w,
            height: 43.w,
            child: Stack(
              children: [
                Assets.icons.group730.svg(),
                Positioned(
                  top: 10.w,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextResponsive(
                          title,
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xfffeca2e),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          actions != null
              ? Positioned(
                  top: 10.w,
                  left: 5.w,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: actions!,
                  ))
              : Container()
        ],
      ),
    );
  }
}

class ImagesWidget extends StatefulWidget {
  @override
  _ImagesWidgetState createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends BaseStatefulState<ImagesWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: 309.w,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [1, 2]
              .map(
                (e) => Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildSectionTitle(
                        e == 1
                            ? AppFactory.getLabel('father_img', 'صورة الأب')
                            : AppFactory.getLabel('mother_img', 'صورة الأم'),
                      ),
                      Container(
                        height: 101.0.w,
                        width: 136.w,
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
                ),
              )
              .toList(),
        ));
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
