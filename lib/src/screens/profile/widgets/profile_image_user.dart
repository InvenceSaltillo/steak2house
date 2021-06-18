import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:steak2house/src/controllers/user_controller.dart';
import 'package:steak2house/src/utils/utils.dart';

class ProfileImageUser extends StatelessWidget {
  const ProfileImageUser({
    Key? key,
    required Utils utils,
    required UserController userCtrl,
    required TextEditingController textControllerName,
  })   : _utils = utils,
        _userCtrl = userCtrl,
        _textControllerName = textControllerName,
        super(key: key);

  final Utils _utils;
  final UserController _userCtrl;
  final TextEditingController _textControllerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: _utils.getHeightPercent(.4),
      decoration: BoxDecoration(
        color: Colors.red,
      ),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              _userCtrl.user.value.avatar!,
            ),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              top: 0,
              child: Container(
                width: double.infinity,
                height: _utils.getHeightPercent(.2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                ),
              ),
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
              child: Column(
                children: [
                  SizedBox(height: _utils.getHeightPercent(.12)),
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: _utils.getWidthPercent(.35),
                          height: _utils.getWidthPercent(.35),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                            ),
                          ),
                          child: ClipOval(
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/animations/loading.gif',
                              fit: BoxFit.cover,
                              image: _userCtrl.user.value.avatar!,
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/img/noAvatar.png',
                                height: _utils.getHeightPercent(.1),
                                width: _utils.getHeightPercent(.1),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        // Positioned(
                        //   bottom: 10,
                        //   right: 4,
                        //   child: Container(
                        //     width: _utils.getWidthPercent(.08),
                        //     height: _utils.getWidthPercent(.08),
                        //     decoration: BoxDecoration(
                        //       color: kSecondaryColor,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     child: Center(
                        //       child: IconButton(
                        //         onPressed: () {},
                        //         icon: Icon(
                        //           Icons.camera_alt_outlined,
                        //           color: Colors.white,
                        //           size: _utils.getWidthPercent(.04),
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // )
                      ],
                    ),
                  ),
                  Container(
                    width: _utils.getWidthPercent(.8),
                    child: TextField(
                      controller: _textControllerName,
                      onChanged: (value) {
                        if (value != _userCtrl.user.value.name) {
                          // _userCtrl.user.value.name = _textControllerName.text;
                          _userCtrl.changeInfo.value = true;
                        } else {
                          _userCtrl.changeInfo.value = false;
                        }
                      },
                      onSubmitted: (_) {
                        print('TEXT');
                      },
                      cursorColor: Colors.white,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: _utils.getHeightPercent(.032),
                      ),
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            width: 1,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          color: Colors.white,
                          onPressed: () {
                            _textControllerName.clear();
                          },
                        ),
                        contentPadding: EdgeInsets.only(
                          left: 15,
                          bottom: 11,
                          top: 11,
                          right: 15,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
