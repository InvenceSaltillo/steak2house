import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:steak2house/src/constants.dart';
import 'package:steak2house/src/models/product_model.dart';
import 'package:steak2house/src/screens/main/main_screen.dart';
import 'package:steak2house/src/utils/utils.dart';
import 'package:steak2house/src/widgets/rounded_small_button.dart';

class ProductDetailImage extends StatelessWidget {
  const ProductDetailImage({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    late AnimationController _animationController;
    final _utils = Utils.instance;

    return Container(
      width: _utils.getWidthPercent(1),
      padding: EdgeInsets.only(
        top: _utils.getHeightPercent(.05),
        bottom: _utils.getHeightPercent(.03),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Center(
              // heightFactor: .77,
              child: Image.network(
                // 'https://cdn.pixabay.com/photo/2018/02/08/15/02/meat-3139641_960_720.jpg',
                product.picture!,
                // height: _utils.getHeightPercent(.125),
                // width: 200,
                fit: BoxFit.fitWidth,
                loadingBuilder: (ctx, child, _) {
                  if (_ == null) return child;
                  return Center(
                    child: Lottie.asset(
                      'assets/animations/loading.json',
                      width: _utils.getWidthPercent(.3),
                      height: _utils.getWidthPercent(.3),
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: RoundedSmallButton(
              onTap: () {
                Get.off(() => MainScreen());
              },
              utils: _utils,
              width: .08,
              height: .08,
              icon: Icon(
                Icons.arrow_back_ios_outlined,
                size: _utils.getWidthPercent(.055),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: RoundedSmallButton(
              onTap: () {
                _animationController.forward(from: 0);
              },
              utils: _utils,
              width: .08,
              height: .08,
              icon: Swing(
                animate: false,
                controller: (controller) => _animationController = controller,
                child: Icon(
                  Icons.favorite_outline,
                  size: _utils.getWidthPercent(.055),
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
