import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'package:med_minder/app/resources/app.logger.dart';
import 'package:med_minder/app/services/navigation_service.dart';
import 'package:med_minder/app/services/snackbar_service.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';

var log = getLogger('NetworkServiceRepository');

abstract class NetworkServiceRepository {
  Future getData(
      {required String domain,
      required String subDomain,
      Map<String, String>? queryParameter,
      Map<String, String>? header});
  Future postData(
      {required String domain,
      required String subDomain,
      required var body,
      required bool isJson,
      Map<String, String>? queryParameter,
      Map<String, String>? header});
}

class NetworkServiceRepositoryImpl extends NetworkServiceRepository {
  final client = RetryClient(http.Client());

  //All GET calls both internally and externally goes through this method
  @override
  Future getData(
      {required String domain,
      required String subDomain,
      Map<String, String>? queryParameter,
      Map<String, String>? header}) async {
    var url = Uri.https(domain, '$subDomain/', queryParameter);

    var response = await client.get(url, headers: header);

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);

      return decodedData;
    } else {
      log.w('Request failed with status: ${response.statusCode}.');
    }
  }

  //All POST calls both internally and externally goes through this method
  @override
  Future postData(
      {required String domain,
      required String subDomain,
      required var body,
      required bool isJson,
      Map<String, String>? queryParameter,
      Map<String, String>? header}) async {
    var url = Uri.https(domain, subDomain, queryParameter);

    var response = await client.post(url,
        headers: header, body: isJson ? jsonEncode(body) : body);

    if (response.statusCode == 200) {
      String data = response.body;
      var decodedData = jsonDecode(data);

      return decodedData;
    } else {
      log.w('Request failed with status: ${response.statusCode}.');
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        "An error occured.",
        () {},
        AppColors.fullBlack,
        2,
      );
    }
  }
}
