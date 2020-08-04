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
  final String _apiKey = 'YOUR API KEY HERE';
  final String _coinURL = 'https://rest.coinapi.io/v1/exchangerate';

  Future getCoinData(String currency) async {
    Map<String, String> cryptoRates = {};

    for (String crypto in cryptoList) {
      String url = '$_coinURL/$crypto/$currency?apiKey=$_apiKey';
      http.Response response = await http.get(url);
      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        double lastPrice = decodedData['rate'];
        cryptoRates[crypto] = lastPrice.toStringAsFixed(0);
      } else {
        print(response.statusCode);
        throw "Error fetching data";
      }
    }

    return cryptoRates;
  }
}
