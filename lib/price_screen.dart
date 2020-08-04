import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String _selectedCurrency = 'USD';
  Map<String, String> _coinValues =  {};
  bool isWaiting = false;

  void _getCryptoData() async {
    isWaiting = true;
    try {
      var data = await CoinData().getCoinData(_selectedCurrency);
      isWaiting = false;
      setState(() {
        _coinValues = data;
      });
    } catch (e) {
      print (e);
      throw e;
    }
  }

  List<DropdownMenuItem> _getDropdownItems() {
    List<DropdownMenuItem<String>> dropdownMenuItems = [];
    for(String currency in currenciesList) {
      var newDrowpdownItem =  DropdownMenuItem(
        value: currency,
        child: Text(
          currency,
          style: TextStyle(color: Color(0xfffdfdfd)),
        ),
      );
      dropdownMenuItems.add(newDrowpdownItem);
    }
    return dropdownMenuItems;
  }

  List<Text> _getPickerItems() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency,  style: TextStyle(color: Color(0xfffdfdfd))));
    }
    return pickerItems;
  }

  Widget _dropdownStyler() {
    if (Platform.isIOS) return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (int i) {
        setState(() => _selectedCurrency = currenciesList[i]);
        _getCryptoData();
      },
      children: _getPickerItems()
    );
    else return DropdownButton<String>(
      value: _selectedCurrency,
      items: _getDropdownItems(),
      onChanged: (String val) {
        setState(() => _selectedCurrency = val);
        _getCryptoData();
      }
    );
  }

  List <Widget> _widgetList() {
    List<Widget> list = [];
    for(String crypto in cryptoList) {
      list.add(CoinCard(
        crypto: crypto,
        currency: _selectedCurrency,
        convert: isWaiting ? '?' : _coinValues[crypto],
      ));
    }
    list.add(Spacer());
    list.add(
      Container(
        height: 150.0,
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 30.0),
        color: Colors.lightBlue,
        child: _dropdownStyler(),
    ));
    return list;
  }

  @override
  void initState() {
    super.initState();
    _getCryptoData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _widgetList(),
      ),
    );
  }
}

class CoinCard extends StatelessWidget {
  const CoinCard({
    this.crypto,
    this.currency,
    this.convert
  });

  final String crypto;
  final String currency;
  final String convert;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = ${convert ?? 0} $currency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
