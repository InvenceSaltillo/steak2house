import 'package:conekta_flutter/conekta_flutter.dart';
import 'package:get/get.dart';
import 'package:steak2house/src/models/conekta/payment_sources_model.dart';
import 'package:steak2house/src/utils/shared_prefs.dart';

class PaymentController extends GetxController {
  final conekta = ConektaFlutter();

  RxList<ConecktaPaymentSource> cardsList = RxList<ConecktaPaymentSource>();

  var lastUsedCard = ConecktaPaymentSource().obs;
  var cardSelectedIdx = 0.obs;
  var pageControllerPage = 0.0.obs;

  Future<void> getCardsList() async {
    try {
      final cardListTemp =
          await SharedPrefs.instance.getKey('cardList') as List;

      final List<ConecktaPaymentSource> myCardList = cardListTemp
          .map((item) => new ConecktaPaymentSource.fromJson(item))
          .toList();
      cardsList.value = myCardList;

      print('CARDLIST ${cardsList.length}');
    } catch (e) {
      print('No hay Lista de Tarjetas========= myCardList $e');
    }
  }

  Future<void> getLastUsedCard() async {
    try {
      final lastUsedCardTemp =
          await SharedPrefs.instance.getKey('lastUsedCard');

      lastUsedCard.value = ConecktaPaymentSource.fromJson(lastUsedCardTemp);

      print('lastUsedCard ${lastUsedCard.value.id}');
    } catch (e) {
      print('No ultima tarjeta usada========= getLastUsedCard');
    }
  }

  @override
  void onReady() {
    conekta.setApiKey('key_syg4GCFA3rp7CuXnrvzn7A');
    // getCardsList();
    getLastUsedCard();
    super.onReady();
  }
}
