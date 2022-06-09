import 'dart:convert';

import 'package:http/http.dart' as http;

class PhpApi {
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
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return jsonDecode('status'':''network');
      }
    } catch (e) {
      print('catch get Requset error ${e}');
      return e;
    }
  }

}
