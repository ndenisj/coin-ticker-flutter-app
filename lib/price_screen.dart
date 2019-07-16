import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'package:flutter_money_formatter/flutter_money_formatter.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'NGN';
  String lastPrice;
  Map<String, String> coinValues = {};
  bool isWaiting = false;

  String currencyFormat(String currency){
    MoneyFormatterOutput fo = FlutterMoneyFormatter(
        amount: 12345678.9012345
    ).output;
  }

  Column makeCard() {
    List<CryptoCard> cryptoCards = [];
    for (String cryptos in cryptoList) {
      cryptoCards.add(CryptoCard(
          cryptoCurrency: cryptos,
          lastPrice: isWaiting ? '?' : coinValues[cryptos],
          selectedCurrency: selectedCurrency));
      print(coinValues[cryptos]);
    }
    return Column(
      children: cryptoCards,
    );
  }

  void getPrice(String selectedCurrency) async {

    isWaiting = true;

    CoinData coinData = CoinData(selectedCurrency);

    var data = await coinData.getCoinData();
    isWaiting = false;
    setState(() {
      coinValues = data;
    });
  }

  DropdownButton<String> androidDropDown() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );

      dropDownItems.add(newItem);
    }

    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownItems,
      onChanged: (value) {
        setState(
          () {
            selectedCurrency = value;
            getPrice(selectedCurrency);
          },
        );
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];

    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
      },
      children: pickerItems,
    );
  }

  @override
  void initState() {
    super.initState();
    getPrice(selectedCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCard(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iOSPicker() : androidDropDown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    @required this.cryptoCurrency,
    @required this.lastPrice,
    @required this.selectedCurrency,
  });

  final String cryptoCurrency;
  final String lastPrice;
  final String selectedCurrency;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlueAccent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
        child: Text(
          '1 $cryptoCurrency = $lastPrice $selectedCurrency',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
