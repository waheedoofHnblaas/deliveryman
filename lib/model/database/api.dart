import 'dart:convert';
import 'dart:io';

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
        headers: {
          //  'Content-Type': 'application/json',
          'Accept-Encoding': 'gzip, deflate, br',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: data,
      );
      if (response.statusCode == 200) {
        print('postRequest======== error ${response}');
        return jsonDecode(response.body);
      } else {
        return jsonDecode('status' ':' 'network');
      }
    } catch (e) {
      print('catch postRequest error $e');
      return e;
    }
  }
}
