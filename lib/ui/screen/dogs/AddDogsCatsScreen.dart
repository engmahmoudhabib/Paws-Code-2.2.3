import 'dart:async';
import 'dart:io';
import 'package:flutter_app/api/APIRepository.dart';
import 'package:flutter_app/bloc/ImagePathMultipartMapper.dart';
import 'package:flutter_app/models/api/AnimalDetailsModel.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/providers/AnimalsProvider.dart';
import 'package:flutter_app/ui/screen/home/screens/animals/AnimalsDetailsScreen.dart';
import 'package:path/path.dart' as path;

import 'package:carousel_slider/carousel_slider.dart';
import 'package:expandable/expandable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/api/ResultState.dart';
import 'package:flutter_app/config/AppConstants.dart';
import 'package:flutter_app/config/AppFactory.dart';
import 'package:flutter_app/gen/assets.gen.dart';
import 'package:flutter_app/gen/fonts.gen.dart';
import 'package:flutter_app/providers/SignInProvider.dart';
import 'package:flutter_app/tools/responsive_widgets/responsive_widgets.dart';
import 'package:flutter_app/ui/dialogs/AccountTypeDialog.dart';
import 'package:flutter_app/ui/dialogsss/ChangeStatusDialog.dart';
import 'package:flutter_app/ui/screen/BaseStateWidget.dart';
import 'package:flutter_app/ui/screen/accounts/password/ForgetPasswordScreen.dart';
import 'package:flutter_app/ui/screen/home/HomeScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MainScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyAccountScreen.dart';
import 'package:flutter_app/ui/screen/home/screens/MyDogsCatsScreen.dart';
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
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:fullscreen/fullscreen.dart';
import 'package:get_storage/get_storage.dart';

class AddDogsCatsScreen extends StatefulWidget {
  static const String PATH = '/dogs-cat-add';
  final String? id;

  AddDogsCatsScreen({this.id});

  static String generatePath({String? id}) {
    Map<String, dynamic> parameters = {'id': id};
    Uri uri = Uri(path: PATH, queryParameters: parameters);
    return uri.toString();
  }

  @override
  _AddDogsCatsScreenState createState() => _AddDogsCatsScreenState();
}

class DocumentModel {
  String name;
  String id;
  String url;

  DocumentModel(this.id, this.url, this.name, this.path);

  String path;
}

class _AddDogsCatsScreenState extends BaseStatefulState<AddDogsCatsScreen> {
  ValueNotifier<bool> isDog = ValueNotifier(true);
  ValueNotifier<bool> isHybrid = ValueNotifier(false);
  ValueNotifier<List<Color>> colors = ValueNotifier([]);
  Map<String, dynamic> param = Map();
  Map<String, dynamic> properties = Map();
  ValueNotifier<List<DocumentModel>> documents = ValueNotifier([]);
  bool firstCall = false;
  AuthResponse? authResponse;

  @override
  void initState() {
    authResponse = AuthResponse.fromMap(GetStorage().read('account'));

    //  properties['is_sterilized'] = true;
    // properties['is_hybrid'] = false;
    //  properties['hair_style'] = 'short_hair';
    if (widget.id != null && widget.id!.length > 0)
      Future.delayed(
          Duration.zero,
          () => context
              .read(animalsDetailsProvider.notifier)
              .getDetails(widget.id ?? ''));
    else {
      param['gender'] = 'male';
      param['animal_type'] = 'dog';
    }

    super.initState();
  }

  @override
  void dispose() {
    documents.dispose();
    colors.dispose();
    isDog.dispose();
    isHybrid.dispose();
    super.dispose();
  }

  getTarget() {
    return isDog.value ? 'الكلب' : 'القط';
  }

  final formKey = GlobalKey<FormState>();
  AnimalsDetails? data;

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
              SizedBox.expand(
                child: Column(
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
                    Consumer(
                      builder: (context, watch, child) {
                        final response = watch(animalsDetailsProvider);
                        response.when(
                            idle: () {},
                            loading: () {},
                            data: (map) {
                              try {
                                data = AnimalsDetails.fromJson(map);
                              } catch (e) {}
                            },
                            error: (e) {});

                        if (!firstCall &&
                            data != null &&
                            widget.id == data?.data?.id) {
                          firstCall = true;
                          if (param['animal_type'] == null) {
                            isDog.value = data?.data?.type?.id == 'dog';
                            param['animal_type'] = data?.data?.type?.id;
                          }
                          if (param['gender'] == null) {
                            param['gender'] = data?.data?.gender?.id;
                          }

                          if (param['name'] == null) {
                            param['name'] = data?.data?.name;
                          }
                          if (param['id'] == null) {
                            param['id'] = data?.data?.id;
                          }
                          if (param['species_id'] == null) {
                            param['species_id'] = data?.data?.species?.id;
                            param['species_name'] = data?.data?.species?.name;
                          }

                          if (param['color_id'] == null) {
                            param['color_id'] = data?.data?.color?.id;
                            param['color_name'] = data?.data?.color?.name;
                          }

                          if (param['birth_date'] == null) {
                            param['birth_date'] = data?.data?.birthDate;
                          }
                          if (param['avatar_url'] == null) {
                            param['avatar'] = data?.data?.avatar?.id;
                            param['avatar_url'] =
                                data?.data?.avatar?.conversions?.large?.url;
                          }
                          try {
                            if (param['video_url'] == null) {
                              param['video'] = data?.data?.video?['id'];
                              param['video_url'] = data?.data?.video?['url'];
                            }
                          } catch (e) {}

                          if (param['father_image_url'] == null) {
                            param['father_image'] = data?.data?.fatherImage?.id;
                            param['father_image_url'] = data
                                ?.data?.fatherImage?.conversions?.large?.url;
                          }
                          if (param['mother_image_url'] == null) {
                            param['mother_image'] = data?.data?.motherImage?.id;
                            param['mother_image_url'] = data
                                ?.data?.motherImage?.conversions?.large?.url;
                          }
                          if (properties['is_hybrid'] == null) {
                            properties['is_hybrid'] =
                                data?.data?.properties?.isHybrid;
                            isHybrid.value =
                                data?.data?.properties?.isHybrid ?? false;
                          }

                          if (properties['is_sterilized'] == null) {
                            properties['is_sterilized'] =
                                data?.data?.properties?.isSterilized;
                          }

                          if (properties['hair_style'] == null) {
                            properties['hair_style'] =
                                data?.data?.properties?.hairStyle?.id;
                          }

                          if (param['hybrid_species_id'] == null) {
                            param['hybrid_species_id'] =
                                data?.data?.hybridSpecies?.id;
                            param['hybrid_species_name'] =
                                data?.data?.hybridSpecies?.name;
                          }

                          if (param['extra_description'] == null) {
                            param['extra_description'] =
                                data?.data?.extraDescription;
                          }

                          if (param['color_pattern_id'] == null) {
                            param['color_pattern_id'] =
                                data?.data?.colorPattern?.id;
                            param['color_pattern_name'] =
                                data?.data?.colorPattern?.name;
                          }
                          try {
                            if (param['images_url[0]'] == null) {
                              int index = 0;
                              data?.data?.images?.forEach((element) {
                                param['images[${index}]'] = element?.id;
                                param['images_url[${index}]'] =
                                    element?.conversions?.large?.url;
                                index++;
                              });
                            }
                          } catch (e) {}

                          try {
                            if (documents.value.length == 0) {
                              data?.data?.documents?.forEach((element) {
                                print(element.id ?? '');
                                documents.value.add(DocumentModel(
                                    element.id ?? '',
                                    element.url ?? '',
                                    element.name ?? '',
                                    ''));
                              });
                              documents.value = List.from(documents.value);
                            }
                          } catch (e) {}
                        }

                        if (data == null &&
                            widget.id != null &&
                            (widget.id?.length ?? 0) > 0)
                          return LoaderWidget();
                        else
                          return Expanded(
                            child: SingleChildScrollView(
                              child: Padding(
                                padding: EdgeInsetsResponsive.only(bottom: 50),
                                child: Form(
                                  key: formKey,
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 20.h,
                                      ),
                                      Container(
                                        padding: EdgeInsetsResponsive.only(
                                            left: 10,
                                            right: 10,
                                            top: 3,
                                            bottom: 5),
                                        child: TextResponsive(
                                          AppFactory.getLabel(
                                              'add_dog_cat', 'إضافة قط أو كلب'),
                                          style: TextStyle(
                                            fontSize: 20.0,
                                            color: AppFactory.getColor(
                                                'primary', toString()),
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      Padding(
                                        padding: EdgeInsetsResponsive.only(
                                            left: 10, right: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: TextResponsive(
                                                'ماذا تريد أن تضيف؟',
                                                style: TextStyle(
                                                  fontSize: 22.0,
                                                  color: AppFactory.getColor(
                                                      'primary', toString()),
                                                ),
                                                textAlign: TextAlign.right,
                                              ),
                                            ),
                                            DogCatSelectWidget(
                                              onSelected: (item) {
                                                param.remove('species_id');
                                                param.remove('species_name');
                                                param.remove(
                                                    'hybrid_species_id');
                                                param.remove(
                                                    'hybrid_species_name');

                                                param['animal_type'] =
                                                    item['id'];
                                                isDog.value =
                                                    item['id'] == 'dog';
                                              },
                                              data: [
                                                {
                                                  'id': 'cat',
                                                  'selected': !isDog.value,
                                                  'name': AppFactory.getLabel(
                                                      'cat', 'قط'),
                                                  'icon':
                                                      Assets.icons.happy.path,
                                                  'height':
                                                      AppFactory.getDimensions(
                                                              67, toString())
                                                          .w
                                                },
                                                {
                                                  'id': 'dog',
                                                  'name': AppFactory.getLabel(
                                                      'dogs', 'كلب'),
                                                  'selected': isDog.value,
                                                  'icon': Assets.icons.pet.path,
                                                  'height':
                                                      AppFactory.getDimensions(
                                                              67, toString())
                                                          .w
                                                },
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      RadioButtonsLargeWidget(
                                        onSelected: (item) {
                                          param['gender'] = item['id'];
                                        },
                                        data: [
                                          {
                                            'selected':
                                                param['gender'] == 'male',
                                            'title': 'ذكر',
                                            'id': 'male'
                                          },
                                          {
                                            'selected':
                                                param['gender'] == 'female',
                                            'title': 'انثى',
                                            'id': 'female'
                                          }
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      ValueListenableBuilder(
                                          valueListenable: isDog,
                                          builder: (context, value, child) =>
                                              CustomTextFieldWidget(
                                                onSaved: (value) {
                                                  param['name'] = value;
                                                },
                                                value: param['name'],
                                                name: AppFactory.getLabel(
                                                    'dog_name',
                                                    'اسم ${getTarget()}'),
                                                validator: RequiredValidator(
                                                    errorText: errorText()),
                                                supportDecoration: true,
                                                icon: Assets.icons.dog111.svg(
                                                    width: 12.w,
                                                    color: Colors.white,
                                                    height: 14.w),
                                              )),
                                      SizedBox(
                                        height: 25.h,
                                      ),
                                      ValueListenableBuilder(
                                          valueListenable: isDog,
                                          builder: (context, value, child) =>
                                              CustomTextFieldWidget(
                                                name: AppFactory.getLabel(
                                                    'dog_cat_type', 'الفصيلة'),
                                                validator: RequiredValidator(
                                                    errorText: errorText()),
                                                supportDecoration: true,
                                                isDropDown: true,
                                                shouldChange: isDog,
                                                value: param['species_name'],
                                                onSelectedValue: (item) {
                                                  param['species_id'] =
                                                      item['id'];
                                                  param['species_name'] =
                                                      item['name'];
                                                  formKey.currentState!
                                                      .validate();
                                                },
                                                items: copy(GetStorage().read(
                                                                'basics')?[
                                                            'species'] ??
                                                        [])
                                                    .where((element) =>
                                                        //!element['is_hybrid'] &&
                                                        element['animal_type'] ==
                                                            (isDog.value
                                                                ? 'dog'
                                                                : 'cat'))
                                                    .toList(),
                                                iconBackground:
                                                    AppFactory.getColor(
                                                        'orange', toString()),
                                                icon: Assets.icons.dog2222.svg(
                                                    width: 12.w,
                                                    color: Colors.white,
                                                    height: 14.w),
                                              )),
                                      SizedBox(
                                        height: 25.h,
                                      ),
                                      ValueListenableBuilder(
                                          valueListenable: isDog,
                                          builder: (context, value, child) =>
                                              CustomTextFieldWidget(
                                                /*  onTap: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: TextResponsive(
                                                    'اختر لون ${getTarget()}',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                  content: SingleChildScrollView(
                                                    child: ColorPicker
                                                        .MultipleChoiceBlockPicker(
                                                      pickerColors: colors.value,
                                                      onColorsChanged: (d) {
                                                        colors.value = [];
                                                        colors.value = d;
                                                      },
                                                    ),
                                                  ),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                      child: TextResponsive(
                                                        'موافق',
                                                        style: TextStyle(
                                                            fontFamily: FontFamily
                                                                .araHamahAlislam,
                                                            color: Colors.white),
                                                      ),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },*/
                                                name: AppFactory.getLabel(
                                                    'dog_color',
                                                    'لون ${getTarget()}'),
                                                validator: RequiredValidator(
                                                    errorText: errorText()),
                                                value: param['color_name'],
                                                onSelectedValue: (item) {
                                                  param['color_id'] =
                                                      item['id'];
                                                  param['color_name'] =
                                                      item['name'];
                                                  formKey.currentState!
                                                      .validate();
                                                },
                                                items: copy(GetStorage().read(
                                                        'basics')?['colors'] ??
                                                    []),
                                                supportDecoration: true,
                                                isDropDown: true,
                                                icon: Assets
                                                    .icons.colorPalette
                                                    .svg(
                                                        width: AppFactory
                                                                .getDimensions(
                                                                    12,
                                                                    toString())
                                                            .w,
                                                        color: Colors.white,
                                                        height: AppFactory
                                                                .getDimensions(
                                                                    14,
                                                                    toString())
                                                            .w),
                                              )),
                                      SizedBox(
                                        height: 10.h,
                                      ),
                                      ValueListenableBuilder(
                                          valueListenable: colors,
                                          builder: (context, value, child) =>
                                              colors.value.length > 0
                                                  ? Container(
                                                      margin:
                                                          EdgeInsetsResponsive
                                                              .only(
                                                                  left: 20,
                                                                  right: 20),
                                                      child: Wrap(
                                                        children: colors.value
                                                            .map((e) =>
                                                                Container(
                                                                  color: e,
                                                                  margin: EdgeInsetsResponsive
                                                                      .only(
                                                                          left:
                                                                              3,
                                                                          top:
                                                                              5,
                                                                          right:
                                                                              3),
                                                                  width: 20.w,
                                                                  height: 20.w,
                                                                ))
                                                            .toList(),
                                                      ),
                                                    )
                                                  : Container()),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      CustomTextFieldWidget(
                                        name: AppFactory.getLabel(
                                            'birthday', 'تاريخ الميلاد'),
                                        validator: RequiredValidator(
                                            errorText: errorText()),
                                        supportDecoration: true,
                                        isBtn: true,
                                        forDate: true,
                                        value: param['birth_date'],
                                        onSelectedValue: (data) {
                                          param['birth_date'] = data;
                                          formKey.currentState!.validate();
                                        },
                                        isDropDown: true,
                                        icon: Assets.icons.iconMaterialDateRange
                                            .svg(
                                                width: 12.w,
                                                color: Colors.white,
                                                height: 14.w),
                                      ),
                                      SizedBox(
                                        height: 25.h,
                                      ),
                                      ImagesWidget(param),
                                      SizedBox(
                                        height: 25.h,
                                      ),
                                      Container(
                                        width: 310.w,
                                        child: ExpandablePanel(
                                          theme: ExpandableThemeData(
                                              hasIcon: true,
                                              iconColor: AppFactory.getColor(
                                                  'primary', toString()),
                                              iconPadding: EdgeInsets.zero,
                                              bodyAlignment:
                                                  ExpandablePanelBodyAlignment
                                                      .center,
                                              headerAlignment:
                                                  ExpandablePanelHeaderAlignment
                                                      .center,
                                              iconPlacement:
                                                  ExpandablePanelIconPlacement
                                                      .right),
                                          header: TextResponsive(
                                            'معلومات إضافية اختيارية',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              color: AppFactory.getColor(
                                                  'primary', toString()),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          collapsed: Container(),
                                          expanded: Column(
                                            children: [
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              RadioButtonsLargeWidget(
                                                onSelected: (item) {
                                                  if (!item['selected']) {
                                                    properties[
                                                            'is_sterilized'] =
                                                        item['id'] == '2';
                                                  } else {
                                                    properties.remove(
                                                        'is_sterilized');
                                                  }
                                                },
                                                data: [
                                                  {
                                                    'selected': properties[
                                                                'is_sterilized'] !=
                                                            null
                                                        ? !(properties[
                                                                'is_sterilized'] ??
                                                            false)
                                                        : false,
                                                    'title': 'طبيعي',
                                                    'id': '1'
                                                  },
                                                  {
                                                    'selected': properties[
                                                                'is_sterilized'] !=
                                                            null
                                                        ? (properties[
                                                                    'is_sterilized'] !=
                                                                null
                                                            ? properties[
                                                                'is_sterilized']
                                                            : false)
                                                        : false,
                                                    'title':
                                                        'معقم ( تمت إزالة الأعضاء التناسلية)',
                                                    'id': '2'
                                                  }
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child:
                                                        RadioButtonsLargeWidget(
                                                      onSelected: (item) {
                                                        print(item);
                                                        if (!item['selected']) {
                                                          properties[
                                                                  'is_hybrid'] =
                                                              item['id'] == '1';
                                                          isHybrid.value =
                                                              item['id'] == '1';
                                                        } else {
                                                          properties.remove(
                                                              'is_hybrid');
                                                        }
                                                      },
                                                      data: [
                                                        {
                                                          'selected': properties[
                                                                      'is_hybrid'] !=
                                                                  null
                                                              ? !properties[
                                                                  'is_hybrid']
                                                              : false,
                                                          'title': 'نقي      ',
                                                          'id': '2'
                                                        },
                                                        {
                                                          'selected': properties[
                                                                      'is_hybrid'] !=
                                                                  null
                                                              ? (properties[
                                                                      'is_hybrid'] ??
                                                                  false)
                                                              : false,
                                                          'title': 'هجين',
                                                          'id': '1'
                                                        }
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 25.h,
                                              ),
                                              ValueListenableBuilder(
                                                  valueListenable: isHybrid,
                                                  builder: (context, value,
                                                          child) =>
                                                      Visibility(
                                                          visible:
                                                              isHybrid.value,
                                                          child:
                                                              ValueListenableBuilder(
                                                                  valueListenable:
                                                                      isDog,
                                                                  builder: (context,
                                                                          value,
                                                                          child) =>
                                                                      CustomTextFieldWidget(
                                                                        shouldChange:
                                                                            isDog,
                                                                        name: AppFactory.getLabel(
                                                                            'dogs_cats_type',
                                                                            'نوع الفصيلة المهجنة'),
                                                                        validator:
                                                                            RequiredValidator(errorText: errorText()),
                                                                        value: param[
                                                                            'hybrid_species_name'],
                                                                        onSelectedValue:
                                                                            (item) {
                                                                          param['hybrid_species_id'] =
                                                                              item['id'];
                                                                          param['hybrid_species_name'] =
                                                                              item['name'];
                                                                          formKey
                                                                              .currentState!
                                                                              .validate();
                                                                        },
                                                                        items: copy(GetStorage().read('basics')?['species'] ??
                                                                                [])
                                                                            .where((element) =>
                                                                                element['is_hybrid'] &&
                                                                                element['animal_type'] == (isDog.value ? 'dog' : 'cat'))
                                                                            .toList(),
                                                                        supportDecoration:
                                                                            true,
                                                                        isDropDown:
                                                                            true,
                                                                        iconBackground: AppFactory.getColor(
                                                                            'orange',
                                                                            toString()),
                                                                        icon: Assets.icons.dog2222.svg(
                                                                            width:
                                                                                12.w,
                                                                            color: Colors.white,
                                                                            height: 14.w),
                                                                      )))),
                                              SizedBox(
                                                height: 25.h,
                                              ),
                                              HairTypeWidget(
                                                selectedId:
                                                    properties['hair_style'],
                                                onSelected: (item) {
                                                  properties['hair_style'] =
                                                      item['id'];
                                                },
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              ValueListenableBuilder(
                                                  valueListenable: isDog,
                                                  builder: (context, value,
                                                          child) =>
                                                      Visibility(
                                                          visible: !isDog.value,
                                                          child: Container(
                                                            margin:
                                                                EdgeInsetsResponsive
                                                                    .only(
                                                                        top:
                                                                            20),
                                                            child:
                                                                CustomTextFieldWidget(
                                                              name: AppFactory.getLabel(
                                                                  'distribution_pattern_color',
                                                                  'نمط توزيع لون الفرو'),
                                                              /*   validator:
                                                            RequiredValidator(
                                                                errorText:
                                                                    errorText()),*/
                                                              value: param[
                                                                  'color_pattern_name'],
                                                              onSelectedValue:
                                                                  (item) {
                                                                param['color_pattern_id'] =
                                                                    item['id'];
                                                                param['color_pattern_name'] =
                                                                    item[
                                                                        'name'];
                                                              },
                                                              items: copy(GetStorage()
                                                                          .read(
                                                                              'basics')?[
                                                                      'color_patterns'] ??
                                                                  []),
                                                              supportDecoration:
                                                                  true,
                                                              isDropDown: true,
                                                              icon: Assets.icons
                                                                  .colorPalette
                                                                  .svg(
                                                                      width:
                                                                          12.w,
                                                                      color: Colors
                                                                          .white,
                                                                      height:
                                                                          14.w),
                                                            ),
                                                          ))),
                                              buildSectionTitle('تفاصيل أخرى'),
                                              Container(
                                                width: 300.0.w,
                                                height: 70.0.w,
                                                child: AppTextField(
                                                  supportUnderLine: false,
                                                  value: param[
                                                      'extra_description'],
                                                  name: '',
                                                  onSaved: (value) {
                                                    param['extra_description'] =
                                                        value;
                                                  },
                                                  //  validator: RequiredValidator(
                                                  //    errorText: errorText()),
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(10.0),
                                                  ),
                                                  border: Border.all(
                                                    width: 0.3,
                                                    color: AppFactory.getColor(
                                                        'gray_1', toString()),
                                                  ),
                                                ),
                                              ),
                                              OtherMediaWidget(param),
                                              buildSectionTitle(
                                                  'تحميل وثائق ( صور أو pdf)'),
                                              Container(
                                                width: 329.0.w,
                                                padding:
                                                    EdgeInsetsResponsive.only(
                                                        top: 10,
                                                        bottom: 10,
                                                        left: 5,
                                                        right: 5),
                                                margin:
                                                    EdgeInsetsResponsive.only(
                                                        left: 5, right: 5),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    InkWell(
                                                      child: Assets
                                                          .icons.group731
                                                          .svg(),
                                                      onTap: () async {
                                                        FilePickerResult?
                                                            result =
                                                            await FilePicker
                                                                .platform
                                                                .pickFiles(
                                                          type: FileType.custom,
                                                          allowMultiple: true,
                                                          allowCompression:
                                                              true,
                                                          allowedExtensions: [
                                                            'jpg',
                                                            'pdf',
                                                            'png'
                                                          ],
                                                        );
                                                        if (result != null) {
                                                          try {
                                                            var response =
                                                                await uploadFile(File(
                                                                    result.paths[
                                                                            0] ??
                                                                        ''));

                                                            documents.value.add(DocumentModel(
                                                                response['id']
                                                                    .toString(),
                                                                response['url'],
                                                                path.basename(
                                                                    result.paths[
                                                                        0]!),
                                                                result.paths[
                                                                        0] ??
                                                                    ''));
                                                          } catch (e) {}

                                                          documents.value =
                                                              List.from(
                                                                  documents
                                                                      .value);
                                                        }
                                                      },
                                                    ),
                                                    SizedBox(
                                                      width: 20.w,
                                                    ),
                                                    Expanded(
                                                      child:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child:
                                                            ValueListenableBuilder(
                                                                valueListenable:
                                                                    documents,
                                                                builder: (context,
                                                                        value,
                                                                        child) =>
                                                                    Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize
                                                                                .max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                        children: documents
                                                                            .value
                                                                            .map(
                                                                              (e) => Container(
                                                                                margin: EdgeInsetsResponsive.only(left: 10, right: 10),
                                                                                child: buildDocumentType(e.name, (e.url).toLowerCase().contains('.pdf') ? Assets.icons.add.svg() : Assets.icons.image.svg(), onRemove: () {
                                                                                  documents.value.removeWhere((element) => e.id == element.id);
                                                                                  documents.value = List.from(documents.value);
                                                                                }),
                                                                              ),
                                                                            )
                                                                            .toList())),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.vertical(
                                                    top: Radius.circular(10.0),
                                                  ),
                                                  color: Colors.white,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color:
                                                          AppFactory.getColor(
                                                                  'gray_1',
                                                                  toString())
                                                              .withOpacity(
                                                                  0.16),
                                                      offset: Offset(0, 3.0),
                                                      blurRadius: 6.0,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: 20.h,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                      MainAppButton(
                                          bgColor: AppFactory.getColor(
                                              'primary', toString()),
                                          name: param['id'] == null
                                              ? 'إضافة'
                                              : 'تعديل',
                                          onClick: () {
                                            print(param);
                                            if (formKey.currentState!
                                                .validate()) {
                                              if (param['avatar_url'] == null &&
                                                  param['avatar'] == null) {
                                                showFlash(AppFactory.getLabel(
                                                    'avatar_msg',
                                                    'اختر الصورة الرئيسية'));
                                                return;
                                              }

                                              bool check = false;
                                              for (int i = 0; i < 4; i++)
                                                if (param['images[${i}]'] !=
                                                    null) {
                                                  check = true;
                                                }

                                              /*  if (!check) {
                                                showFlash(AppFactory.getLabel(
                                                    'image_msg',
                                                    'اختر صورة ثانية'));
                                                return;
                                              }*/

                                              /* if (properties['is_sterilized'] ==
                                                  null) {
                                                showFlash(AppFactory.getLabel(
                                                    'hybrid_msg',
                                                    'اختر طبيعي أو معقم'));
                                                return;
                                              }*/

                                              /*  if (properties['is_hybrid'] ==
                                                  null) {
                                                showFlash(AppFactory.getLabel(
                                                    'hybrid_msg',
                                                    'اختر نقي أو هجين'));
                                                return;
                                              }*/

                                              //
                                              /*  if (properties['hair_style'] ==
                                                  null) {
                                                showFlash(AppFactory.getLabel(
                                                    'hybrid_msg',
                                                    'اختر نوع الشعر'));
                                                return;
                                              }*/

                                              formKey.currentState!.save();
                                              int index = 0;
                                              try {
                                                for (int i = 0; i < 20; i++)
                                                  param['documents[${i}]'] =
                                                      null;
                                              } catch (e) {}
                                              try {
                                                for (int i = 0; i < 20; i++)
                                                  param['images_url[${i}]'] =
                                                      null;
                                              } catch (e) {}

                                              documents.value
                                                  .forEach((element) {
                                                param['documents[${index}]'] =
                                                    element.id;
                                                index++;
                                              });
                                              apiBloc.doAction(
                                                  param: BaseStatefulState
                                                      .addServiceInfo(param,
                                                          data: {
                                                        'method': 'post',
                                                        '_method':
                                                            param['id'] == null
                                                                ? null
                                                                : 'PUT',
                                                        'properties':
                                                            properties,
                                                        'url': ANIMALS_LIST_API +
                                                            (param['id'] == null
                                                                ? ''
                                                                : '/${param['id']}'),
                                                      }),
                                                  onPreCall: (param) async {
                                                    return new Map<String,
                                                        dynamic>.from(param)
                                                      ..remove('color_name')
                                                      ..remove('avatar_url')
                                                      ..remove(
                                                          'hybrid_species_name')
                                                      ..remove(!isHybrid.value
                                                          ? 'hybrid_species_id'
                                                          : 'images_url')
                                                      ..remove('video_url')
                                                      ..remove(
                                                          'father_image_url')
                                                      ..remove(
                                                          'mother_image_url')
                                                      ..remove('species_name');
                                                  },
                                                  supportLoading: true,
                                                  supportErrorMsg: false,
                                                  onResponse: (json) {
                                                    Future.delayed(
                                                        Duration.zero,
                                                        () => context
                                                            .read(
                                                                animalsProvider
                                                                    .notifier)
                                                            .load(
                                                                idBreeder: authResponse
                                                                        ?.data
                                                                        ?.user
                                                                        ?.id
                                                                        ?.toString() ??
                                                                    null));
                                                    Future.delayed(
                                                        Duration.zero,
                                                        () => context
                                                            .read(
                                                                animalsDetailsProvider
                                                                    .notifier)
                                                            .getDetails(
                                                                widget.id ??
                                                                    ''));
                                                    Navigator.pop(context);
                                                    String id = '';
                                                    try {
                                                      id = json['data']['id']
                                                          .toString();
                                                    } catch (e) {
                                                      id = widget.id ?? '';
                                                    }
                                                    if (id.length > 0)
                                                      try {
                                                        showDialog(
                                                            context: context,
                                                            barrierColor: Colors
                                                                .transparent,
                                                            barrierDismissible:
                                                                true,
                                                            useSafeArea: false,
                                                            builder: (_) =>
                                                                ChangeStatusDialog(
                                                                    id));
                                                      } catch (e) {}
                                                  });
                                            }
                                          }),
                                      SizedBox(
                                        height: 15.h,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        )));
  }

  Column buildDocumentType(String name, Widget icon, {VoidCallback? onRemove}) {
    return Column(
      children: [
        onRemove != null
            ? InkWell(
                onTap: onRemove,
                child: Container(
                  margin: EdgeInsetsResponsive.all(5),
                  child: SvgPicture.string(
                    '<svg viewBox="16.0 181.0 19.1 19.1" ><path transform="translate(13.0, 178.0)" d="M 12.55151557922363 3 C 7.269526481628418 3 3 7.269526481628418 3 12.55151557922363 C 3 17.83350563049316 7.269526481628418 22.10302734375 12.55151557922363 22.10302734375 C 17.83350563049316 22.10302734375 22.10302734375 17.83350563049316 22.10302734375 12.55151557922363 C 22.10302734375 7.269526481628418 17.83350563049316 3 12.55151557922363 3 Z M 17.3272705078125 15.98051071166992 L 15.98051071166992 17.3272705078125 L 12.55151557922363 13.89827823638916 L 9.12252140045166 17.3272705078125 L 7.7757568359375 15.98051071166992 L 11.20475101470947 12.55151557922363 L 7.7757568359375 9.12252140045166 L 9.12252140045166 7.7757568359375 L 12.55151557922363 11.20475101470947 L 15.98051071166992 7.7757568359375 L 17.3272705078125 9.12252140045166 L 13.89827823638916 12.55151557922363 L 17.3272705078125 15.98051071166992 Z" fill="#707070" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
                    allowDrawingOutsideViewBox: true,
                    fit: BoxFit.fill,
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
              )
            : SizedBox(),
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
}

class ImagesWidget extends StatefulWidget {
  final Map<String, dynamic> param;

  ImagesWidget(this.param);

  @override
  _ImagesWidgetState createState() => _ImagesWidgetState();
}

class _ImagesWidgetState extends BaseStatefulState<ImagesWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            height: 113.0.w,
            width: 309.w,
            child: ClipRect(
                child: Banner(
                    message: AppFactory.getLabel('main_img', 'الصورة الرئيسية'),
                    textStyle: TextStyle(
                      fontFamily: FontFamily.araHamahAlislam,
                      fontSize: 10.0.h,
                      color: Colors.white,
                    ),
                    location: BannerLocation.topEnd,
                    color: AppFactory.getColor('orange', toString()),
                    child: Container(
                      height: 113.0.w,
                      width: 309.w,
                      child: ImagePickerWidget(
                        supportCropper: true,
                        onRemove: (data) {
                          widget.param.remove('avatar_url');
                          widget.param.remove('avatar');
                        },
                        data: {},
                        url: widget.param['avatar_url'],
                        onResult: (files) async {
                          try {
                            var result = await uploadFile(files[0]);
                            widget.param['avatar'] = result['id'];
                            widget.param['avatar_url'] = result['url'];
                          } catch (e) {}
                        },
                        emptyWidget: Center(
                            child: Assets.icons.iconMaterialFileUpload
                                .svg(width: 21.w, height: 26.w)),
                      ),
                      margin: EdgeInsetsResponsive.all(2),
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
                            blurRadius: 14.0,
                          ),
                        ],
                      ),
                    )))),
        SizedBox(
          height: 25.h,
        ),
        Container(
            width: 309.w,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [0, 1, 2, 3]
                  .map(
                    (e) => Container(
                      height: 86.0.w,
                      width: 70.w,
                      child: ImagePickerWidget(
                        url: widget.param['images_url[${e}]'],
                        onResult: (files) async {
                          try {
                            var result = await uploadFile(files[0]);
                            widget.param['images[${e}]'] = result['id'];
                            widget.param['images_url[${e}]'] = result['url'];
                          } catch (e) {}
                        },
                        onRemove: (data) {
                          widget.param.remove('images[${e}]');
                          widget.param.remove('images_url[${e}]');
                        },
                        emptyWidget: Center(
                            child: Assets.icons.iconMaterialFileUpload
                                .svg(width: 21.w, height: 26.w)),
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
                  )
                  .toList(),
            ))
      ],
    );
  }
}

class OtherMediaWidget extends StatefulWidget {
  final Map<String, dynamic> param;

  OtherMediaWidget(this.param);

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
          child: ImagePickerWidget(
            isVideo: true,
            url: widget.param['video_url'],
            onResult: (files) async {
              try {
                var result = await uploadFile(files[0]);
                widget.param['video'] = result['id'];
                widget.param['video_url'] = result['url'];
              } catch (e) {}
            },
            onRemove: (data) {
              try {
                widget.param.remove('video');
                widget.param.remove('video_url');
              } catch (e) {}
            },
            emptyWidget: Center(
                child: Assets.icons.iconMetroYoutubePlay
                    .svg(width: 35.w, height: 34.w)),
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
          child: ImagePickerWidget(
            url: widget.param['mother_image_url'],
            onResult: (files) async {
              try {
                var result = await uploadFile(files[0]);
                widget.param['mother_image'] = result['id'];
                widget.param['mother_image_url'] = result['url'];
              } catch (e) {}
            },
            onRemove: (data) {
              try {
                widget.param.remove('mother_image');
                widget.param.remove('mother_image_url');
              } catch (e) {}
            },
            emptyWidget: Center(
                child: Assets.icons.iconMaterialFileUpload
                    .svg(width: 21.w, height: 26.w)),
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
          child: ImagePickerWidget(
            url: widget.param['father_image_url'],
            onResult: (files) async {
              try {
                var result = await uploadFile(files[0]);
                widget.param['father_image'] = result['id'];
                widget.param['father_image_url'] = result['url'];
              } catch (e) {}
            },
            onRemove: (data) {
              try {
                widget.param.remove('father_image');
                widget.param.remove('father_image_url');
              } catch (e) {}
            },
            emptyWidget: Center(
                child: Assets.icons.iconMaterialFileUpload
                    .svg(width: 21.w, height: 26.w)),
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
