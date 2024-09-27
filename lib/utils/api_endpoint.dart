import 'dart:convert';

String baseApiUrl = 'http://bmapitest.somee.com/api/v1';
String newBaseApiUrl = 'https://vinhtc191-001-site1.gtempurl.com/api/v1';
// String newBaseApiUrl = 'https://congvinh2024-001-site1.dtempurl.com/api/v1';



Map<String, String> getHeaders(String jwtToken) {
  const String username = '11190907';
  const String password = '60-dayfreetrial';
  final String basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';

  final String jwtAuth = 'Bearer $jwtToken';

  if(jwtToken != '' || jwtToken.isNotEmpty) {
    return {
      'Content-Type': 'application/json; charset=utf-8',
      'ngrok-skip-browser-warning': 'true',
      'Authorization': jwtAuth,
    };
  }

  return {
    'Content-Type': 'application/json; charset=utf-8',
    'ngrok-skip-browser-warning': 'true',
  };
}