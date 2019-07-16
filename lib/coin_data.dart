import 'constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NGN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {

  final String selectedCurrency;

  CoinData(this.selectedCurrency);

  Future getCoinData() async {
    Map<String, String> prices = {};
    for(String cryptos in cryptoList) {
      http.Response response = await http.get(url + cryptos + selectedCurrency);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['last'];
        prices[cryptos] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
      }
    }

    return prices;

  }

}