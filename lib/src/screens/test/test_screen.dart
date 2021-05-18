import 'package:flutter/material.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/dialogs.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _utils = Utils.instance;
    return Scaffold(
      body: Container(
        height: _utils.getHeightPercent(.9),
        // height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Spacer(),
                IconButton(
                  onPressed: () {
                    Dialogs.instance.dismiss();
                  },
                  icon: Icon(Icons.clear),
                )
              ],
            ),
            Text(
              'Agrega o elige una dirección',
              style: TextStyle(
                fontSize: _utils.getHeightPercent(.038),
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: _utils.getWidthPercent(.06),
                vertical: _utils.getHeightPercent(.03),
              ),
              // child: SearchTextField(
              //   icon: Icons.location_on_outlined,
              //   hintText: 'Escribe una dirección', controller: null,
              // ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) => ListTile(
                  // leading: Icon(Icons.location_on),
                  title: Text('Ubicación actual'),
                  onTap: () {},
                  // selected: true,
                  // selectedTileColor: kSecondaryColor,
                  // tileColor: kSecondaryColor,
                  // focusColor: kSecondaryColor,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
