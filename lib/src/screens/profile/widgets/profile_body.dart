import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/screens/profile/widgets/profile_image_user.dart';
import 'package:steak2house/src/services/user_service.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';
import 'package:steak2house/src/widgets/rounded_button.dart';

import '../../../constants.dart';
import 'profile_email_user.dart';

class ProfileBody extends StatefulWidget {
  @override
  _ProfileBodyState createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  final TextEditingController _textControllerName = TextEditingController();
  final TextEditingController _textControllerEmail = TextEditingController();
  final TextEditingController _textControllerPhone = TextEditingController();
  final TextEditingController _textControllerBirthDate =
      TextEditingController();

  final _utils = Utils.instance;
  final _userCtrl = Get.find<UserController>();

  String birthDatetemp = '';
  String telTemp = '';

  DateTime selectedDate = DateTime.now();
  var maskFormatter = new MaskTextInputFormatter(mask: '(###) ###-##-##');

  @override
  void initState() {
    _userCtrl.changeInfo.value = false;

    birthDatetemp = _userCtrl.user.value.birthday!;
    telTemp = _userCtrl.user.value.tel!;

    print('telTemp $telTemp');

    _textControllerName.text = '${_userCtrl.user.value.name}';
    _textControllerEmail.text = '${_userCtrl.user.value.email}';
    _textControllerBirthDate.text = _userCtrl.user.value.birthday == null
        ? '--/--/----'
        : DateFormat.yMMMMd('es_MX')
            .format(DateTime.parse(_userCtrl.user.value.birthday!));

    _textControllerPhone.text =
        '${maskFormatter.maskText(_userCtrl.user.value.tel!)}';

    _userCtrl.userGender.value = _userCtrl.user.value.gender ?? '';

    super.initState();
  }

  bool enableList = false;
  int _selectedIndex = 0;
  _onhandleTap() {
    setState(() {
      enableList = !enableList;
    });
  }

  List<Map> _testList = [
    {'no': 1, 'keyword': 'Hombre'},
    {'no': 2, 'keyword': 'Mujer'},
    {'no': 3, 'keyword': 'Otro'},
  ];

  _onChanged(int position) {
    setState(() {
      if (_testList[position]['keyword'] != _userCtrl.user.value.gender) {
        _userCtrl.changeInfo.value = true;
      } else {
        _userCtrl.changeInfo.value = false;
      }
      _userCtrl.userGender.value = _testList[position]['keyword'];
      _selectedIndex = position;
      enableList = !enableList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print('_textControllerName ${_textControllerName.text}');
        print('_userCtrl ${_userCtrl.user.value.name}');
        if (_userCtrl.changeInfo.value) {
          Get.defaultDialog(
            title: 'Guardar cambios',
            middleText: '¿Hubo cambios en tu perfil, quieres guardarlos?',
            confirmTextColor: Colors.red,
            confirm: ElevatedButton(
              onPressed: () {
                Get.back();
                _updateUser();
              },
              child: Text('Si'),
              style: ElevatedButton.styleFrom(
                primary: kSecondaryColor,
              ),
            ),
            cancel: ElevatedButton(
              onPressed: () {
                Get.back();
                Get.back();
              },
              child: Text('No'),
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
              ),
            ),
          );
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileImageUser(
                utils: _utils,
                userCtrl: _userCtrl,
                textControllerName: _textControllerName,
              ),
              SizedBox(height: _utils.getHeightPercent(.03)),
              ProfileEmailUser(
                utils: _utils,
                textControllerEmail: _textControllerEmail,
              ),
              SizedBox(height: _utils.getHeightPercent(.03)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Teléfono',
                      style: TextStyle(
                        fontSize: _utils.getHeightPercent(.03),
                      ),
                    ),
                    Container(
                      // width: _utils.getWidthPercent(.9),
                      height: 40,
                      child: TextField(
                        inputFormatters: [maskFormatter],
                        onChanged: (value) {
                          if (value != _userCtrl.user.value.tel) {
                            _userCtrl.changeInfo.value = true;
                          } else {
                            _userCtrl.changeInfo.value = false;
                          }
                        },
                        controller: _textControllerPhone,
                        onSubmitted: (_) {},
                        cursorColor: kPrimaryColor,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black38,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.black38,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () async {
                              _textControllerPhone.clear();
                            },
                            icon: Icon(
                              Icons.clear,
                              color: kPrimaryColor,
                            ),
                          ),
                          contentPadding: EdgeInsets.only(
                            left: 15,
                            bottom: 5,
                            top: 5,
                            right: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: _utils.getHeightPercent(.03)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fecha de nacimiento',
                          style: TextStyle(
                            fontSize: _utils.getHeightPercent(.03),
                          ),
                        ),
                        Container(
                          width: _utils.getWidthPercent(.5),
                          height: 40,
                          child: TextField(
                            onChanged: (value) {},
                            controller: _textControllerBirthDate,
                            onSubmitted: (_) {},
                            readOnly: true,
                            cursorColor: kPrimaryColor,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.black38,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.black38,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: selectedDate,
                                    firstDate: DateTime(1960),
                                    locale: Locale('es', ''),
                                    lastDate: DateTime(
                                        2021, DateTime.now().month + 1),
                                  );
                                  if (date != null) {
                                    birthDatetemp = date.toString();
                                    print('birthDatetemp $birthDatetemp');
                                    final dateTemp =
                                        DateFormat.yMMMMd('es_MX').format(date);
                                    final birthDayTemp = DateFormat.yMMMMd(
                                            'es_MX')
                                        .format(DateTime.parse(
                                            _userCtrl.user.value.birthday!));

                                    if (dateTemp != birthDayTemp) {
                                      _userCtrl.changeInfo.value = true;
                                    } else {
                                      _userCtrl.changeInfo.value = false;
                                    }
                                    selectedDate = date;
                                    _textControllerBirthDate.text =
                                        DateFormat.yMMMMd('es_MX')
                                            .format(selectedDate);
                                  }
                                },
                                icon: Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  color: kPrimaryColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.only(
                                left: 5,
                                bottom: 5,
                                top: 5,
                                right: 5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Género',
                          style: TextStyle(
                            fontSize: _utils.getHeightPercent(.03),
                          ),
                        ),
                        Container(
                          width: _utils.getWidthPercent(.4),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: _onhandleTap,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: enableList
                                            ? Colors.black
                                            : Colors.grey,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(8),
                                      ),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0,
                                    ),
                                    height: 40.0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Obx(
                                          () => Expanded(
                                            child: Text(
                                              _userCtrl.user.value.gender !=
                                                      null
                                                  ? _userCtrl.userGender.value
                                                  : "Género",
                                              style: TextStyle(fontSize: 16.0),
                                            ),
                                          ),
                                        ),
                                        Icon(
                                          Icons.expand_more,
                                          size: 24.0,
                                          color: kPrimaryColor,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                enableList ? _buildSearchList() : Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: _utils.getHeightPercent(.1)),
              Container(
                child: RoundedButton(
                  text: 'Guardar cambios',
                  fontSize: .025,
                  onTap: () async {
                    _updateUser();
                  },
                  width: .5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateUser() async {
    _userCtrl.user.value.name = _textControllerName.text.trim();
    _userCtrl.user.value.email = _textControllerEmail.text;
    _userCtrl.user.value.tel = maskFormatter.getUnmaskedText() == ''
        ? _userCtrl.user.value.tel
        : maskFormatter.getUnmaskedText();

    _userCtrl.user.value.birthday = birthDatetemp;
    _userCtrl.user.value.gender = _userCtrl.userGender.value;
    print('USER ${_userCtrl.user.value.gender}');

    // _userCtrl.user.value.gender = _textController.text;

    final update = await UserService.instance.update();

    if (update) {
      Get.back();
      Dialogs.instance.showSnackBar(
        DialogType.success,
        '¡Se actualizaron tus datos!',
        false,
      );
    }
  }

  Widget _buildSearchList() => Container(
        height: 150.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400]!, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white,
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        margin: EdgeInsets.only(top: 5.0),
        child: ListView.builder(
          padding: const EdgeInsets.all(0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          itemCount: _testList.length,
          itemBuilder: (context, position) {
            return InkWell(
              onTap: () {
                _onChanged(position);
              },
              child: Container(
                // padding: widget.padding,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                decoration: BoxDecoration(
                  color: position == _selectedIndex
                      ? Colors.grey[100]
                      : Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
                child: Text(
                  _testList[position]['keyword'],
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        ),
      );
}
