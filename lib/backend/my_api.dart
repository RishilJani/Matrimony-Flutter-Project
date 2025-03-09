import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:matrimony_application/utils/string_constants.dart';

class MyApi {
  final String url = 'https://67b41d0c392f4aa94fa9642a.mockapi.io/';

  Future<List<Map<String, dynamic>>> getAll() async {
    http.Response res = await http.get(Uri.parse('${url}Users'));
    if (res.statusCode == 200) {
      List<Map<String, dynamic>> ans =  List<Map<String, dynamic>>.from(jsonDecode(res.body));
      return ans;
    }
    return [];
  }

  Future<Map<String, dynamic>> getByID(int id) async {
    http.Response res = await http.get(Uri.parse('${url}Users/$id'));
    if (res.statusCode == 200) {
      Map<String, dynamic> temp =
          Map<String, dynamic>.from(jsonDecode(res.body));
      return temp;
    } else {
      return {};
    }
  }

  Future<void> insertAPI(Map<String, dynamic> mp) async {
    var data = jsonEncode(mp);
    await http.post(
      Uri.parse('${url}Users'),
      body: data,
      headers: {"Content-Type": "application/json"},
    );
  }

  Future<void> deleteAPI(int id) async {
    await http.delete(
      Uri.parse('${url}Users/$id'),
    );
  }

  Future<void> updateAPI(int id, data) async {
    await http.put(Uri.parse('${url}Users/$id'),
        headers: {'Content-Type': 'application/json'}, body: data);
  }

  Future<void> changeFavourite(int id, int value) async {
    var data = jsonEncode({isFavourite: value});
    await http.patch(Uri.parse('${url}Users/$id'),
        headers: {"Content-Type": "application/json"},
        body: data
    );
  }

}
