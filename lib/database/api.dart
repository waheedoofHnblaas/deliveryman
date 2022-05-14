import 'dart:convert';

import 'package:http/http.dart' as http;

class Api {
  getRequest(url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        print('response.statusCode == 200');
        return jsonDecode(response.body);
      } else {
        print('error ${response.statusCode}');
      }
    } catch (e) {
      print('catch getRequset error $e}');
    }
  }

  postRequest(url, data) async {
    print('postRequest');
    try {
      var response = await http.post(
        Uri.parse(url),
        body: data,
      );
      print('statusCode : ${response.statusCode}');
      return jsonDecode(response.body);
    } catch (e) {
      print('catch get Requset error $e}');
    }
  }
}
