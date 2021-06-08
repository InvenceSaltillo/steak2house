import 'package:flutter/material.dart';
import 'package:steak2house/src/utils/utils.dart';

import '../../../constants.dart';

class ProfileEmailUser extends StatelessWidget {
  const ProfileEmailUser({
    Key? key,
    required Utils utils,
    required TextEditingController textControllerEmail,
  })   : _utils = utils,
        _textControllerEmail = textControllerEmail,
        super(key: key);

  final Utils _utils;
  final TextEditingController _textControllerEmail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'E-mail',
            style: TextStyle(
              fontSize: _utils.getHeightPercent(.03),
            ),
          ),
          Container(
            height: 40,
            child: TextField(
              onChanged: (value) {},
              controller: _textControllerEmail,
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
    );
  }
}
