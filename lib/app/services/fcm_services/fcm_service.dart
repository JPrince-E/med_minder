import 'package:firebase_database/firebase_database.dart';
import 'package:med_minder/app/resources/app.locator.dart';
import 'package:med_minder/app/resources/app.logger.dart';
import 'package:med_minder/app/services/fcm_services/network_service.dart';
import 'package:med_minder/app/services/fcm_services/push_notification_model.dart';
import 'package:med_minder/app/services/fcm_services/push_notification_service.dart';
import 'package:med_minder/app/services/navigation_service.dart';
import 'package:med_minder/app/services/snackbar_service.dart';
import 'package:med_minder/ui/shared/global_variables.dart';
import 'package:med_minder/utils/app_constants/app_colors.dart';

var log = getLogger('FcmService');

class FcmService {
  Future sendPushNotification({
    required String receipientDeviceToken,
    required String message,
  }) async {
    try {
      log.w("Attempting to send notification");
      var data = await _sendIndiePushNotification(
        receipientDeviceToken: receipientDeviceToken,
        message: message,
      );
      log.wtf("sendIndiePushNotification resp: ${data.toString()}");
      PushNotificationModel pushNotificationModel =
          PushNotificationModel.fromJson(data);
      if (pushNotificationModel.success == 1) {
        return data;
      }
    } catch (e) {
      log.w("Error sending notifications");
      showCustomSnackBar(
        NavigationService.navigatorKey.currentContext!,
        "An error occured",
        () {},
        AppColors.fullBlack,
        2,
      );
    }
  }

  final _pushMessagingNotification = locator<PushNotificationService>();
  final _networkHelper = locator<NetworkServiceRepository>();

  final url = "https://fcm.googleapis.com/fcm/send";
  final _domain = "fcm.googleapis.com";
  final _subDomain = "fcm/send";

  // Method to send push notification
  Future _sendIndiePushNotification({
    required String receipientDeviceToken,
    required String message,
  }) async {
    var serverKey = await getFcmServerKey();
    log.wtf("serverKey resp: $serverKey");
    if (serverKey == null) {
      return;
    }

    Map<String, String> header = {
      'Authorization': 'key=$serverKey',
      'Content-type': 'application/json',
      'Accept': '/',
    };
    log.w("Okay -----------");

    var deviceToken = _pushMessagingNotification.deviceToken;
    GlobalVariables.myDeviceToken = deviceToken;

    var body = {
      "to": receipientDeviceToken,
      "priority": "high",
      "notification": {
        "title": "HSMS",
        "body": message,
        "sound": "default",
      },
      "data": {
        "title": "HSMS Notification",
      },
    };
    log.w("Body: ${body.toString()}");

    var data = await _networkHelper.postData(
      domain: _domain,
      subDomain: _subDomain,
      header: header,
      isJson: true,
      body: body,
    );
    log.wtf("_networkHelper.postData resp: ${data.toString()}");
    return data;
  }

  getFcmServerKey() async {
    final getDataRef = FirebaseDatabase.instance.ref();
    final getDataSnapshot = await getDataRef.child('keys/fcmServerKey').get();

    if (getDataSnapshot.exists) {
      log.wtf("FCM Server Key: ${getDataSnapshot.value}");
      return getDataSnapshot.value;
    } else {
      return null;
    }
  }
}
