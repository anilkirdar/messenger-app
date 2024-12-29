import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

import '../models/user_model.dart';

class NotificationService {
  static void initializeFCMNotification() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
    late NotificationSettings notificationSettings;

    await firebaseMessaging.subscribeToTopic('all');
    await firebaseMessaging.setAutoInitEnabled(true);
    notificationSettings = await firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: true,
    );

    Future<void> showNotification(Map<String, dynamic> message) async {
      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();

      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails(
        '1234',
        'Test notification',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      );
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
        0,
        message['data']['title'],
        message['data']['body'],
        notificationDetails,
        payload: 'item x',
      );
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('onMessage TRIGGERED: ${message.data}');
      showNotification(message.data);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('onMessageOpenedApp TRIGGERED: ${message.data}');
      showNotification(message.data);
    });

    // void showNotification() {
    //   final List<DarwinNotificationCategory> darwinNotificationCategories =
    //       <DarwinNotificationCategory>[
    //     DarwinNotificationCategory(
    //       'textCategory',
    //       actions: <DarwinNotificationAction>[
    //         DarwinNotificationAction.text(
    //           'text_1',
    //           'Action 1',
    //           buttonTitle: 'Send',
    //           placeholder: 'Placeholder',
    //         ),
    //       ],
    //     ),
    //     DarwinNotificationCategory(
    //       'plainCategory',
    //       actions: <DarwinNotificationAction>[
    //         DarwinNotificationAction.plain('id_1', 'Action 1'),
    //         DarwinNotificationAction.plain(
    //           'id_2',
    //           'Action 2 (destructive)',
    //           options: <DarwinNotificationActionOption>{
    //             DarwinNotificationActionOption.destructive,
    //           },
    //         ),
    //         DarwinNotificationAction.plain(
    //           'id_3',
    //           'Action 3 (foreground)',
    //           options: <DarwinNotificationActionOption>{
    //             DarwinNotificationActionOption.foreground,
    //           },
    //         ),
    //         DarwinNotificationAction.plain(
    //           'id_4',
    //           'Action 4 (auth required)',
    //           options: <DarwinNotificationActionOption>{
    //             DarwinNotificationActionOption.authenticationRequired,
    //           },
    //         ),
    //       ],
    //       options: <DarwinNotificationCategoryOption>{
    //         DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
    //       },
    //     )
    //   ];

    //   const AndroidInitializationSettings initializationSettingsAndroid =
    //       AndroidInitializationSettings('app_icon');
    //   final DarwinInitializationSettings initializationSettingsDarwin =
    //       DarwinInitializationSettings(
    //     requestAlertPermission: false,
    //     requestBadgePermission: false,
    //     requestSoundPermission: false,
    //     notificationCategories: darwinNotificationCategories,
    //   );

    //   final InitializationSettings initializationSettings =
    //       InitializationSettings(
    //     android: initializationSettingsAndroid,
    //     iOS: initializationSettingsDarwin,
    //   );
    // }
  }

  static Future<String> getAccessToken() async {
    final Map<String, String> serviceAccountJSON = {
      "type": "service_account",
      "project_id": "messenger-app-8556c",
      "private_key_id": "85d2c07bfd9bbc0cd4834daa5a24509247501068",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDQQlHr5Cn4BvjS\nwH5aUxNHBswEiaY0twNIsg7zqTrD8AG9rnpxU9i4hiO8Qrr3EUSRfoSG462zt4RA\nMmE5NMu+FCPOY1UTi9Pbvy2p5sP4uV7IVm6F8+qT/0l3oSuU7NXc3LJHzTYU0chM\n+io56BCEJOiugCrPCaIaEtmnFJW/KRspcwrDmoxaL2r+iQV9IumZeWhjPHLNPH6B\n31YvVEaEom22VKkOEgwnDZ/iyzg6Mh1QSUKTUQPm9z5tOeI0KLngFRWimxFS9PyH\nHkBDg3JHvTpqSfU/0ItDcPTNMLfhE3feTv7Ml4wKYtXosZmxjyHpgybpcYLrDFFg\nQRfiwcCDAgMBAAECggEATbW5iNqSGIVNeqKuYzjllBbCsRzF4py5wnoCn0Qx8+QO\nWj+NW9VMJIqVMg36Yu/UFLBPdl/ltI5RcHz8D1MWhX5RYBVrrQf7jV9YhDHiRWCy\nL/IkeqJqEUBsoxGGSCNZp/jII4e82ubupV6hvArOguic1GRp1OiEztLi2XgSaooY\naiAZ8JRmyPcT6G+U3ZpSA0l4/HfeKhr+r/Wf7FIgOGl07aKU2bL/R5lh+nTGm1nA\nYYvN3UIu0HeXStrZi0/xBny8GagnUdwubAmnkqK+NT+YkU0hT6/Qz9n2kZii47ss\nyiIhevYCdpxkta4YhA7puxeSfxebZliyDiYLwAQ1IQKBgQD/zCHvYRmr38Q9/66o\n/GRfPnSpgnDJ2DM+4BLwK1LYLFvqRcfApOoniQcj9r4+5/f3Do4qfjb9tOIaAI6H\n5YPy9e/fw0v2PgePuCbH1bgosMYZChhKsZOTZuzI7J6eIHCGF+hSmX1kuWv6Ps1j\nXmZ6cf2k3qg6qVP1G+oVlHVPoQKBgQDQbIxXg3RWTTpY3lfpQ7zVOCX8N+umbJFw\njSrJym3DV8ALAo2qvlwiyyB3Q+uBdjFhNOEATCpBNbSlmvmUP4sJb9xq1/klBCF/\nSxxi2wy40m7qzhGIQKUXpaH5z7bjA7ZU7GWj7GICdf9xrOMwgg2HB8n0bx//XEBZ\n+dsjIljtowKBgQDZ7vVKmZPhl3f+yoPofYCWlQOYGAY4MfcXLplz/bVLcB+vbVxO\niTLmFBz9Sw+zULc2yjPdiEMZzK6GMMs+hRDyQw7nueBSH28Zx29i+nc4U8OzOaKQ\noNJ2104NsWtClajI1j2dgiAPXNreDfu3GYp97/iGKx1xPSrGvc2mLSH1gQKBgQDO\n8FfPtFdYMMmT3v9OPdFJqrwcVrGExhsJs0AepvygjYnB5MEgHG2CpkgP4sH8Aow4\nxbX5A6aYpGg+XUccqJK1xfkFpHZdCGLx7nO6u19ASr+SJxRFQlooxm2yiUg+0jrA\nyw6H2XXel6YPCedxDE++GD+ukH8mnkPOkkO/+KRvHQKBgQCBcWPpxaPYF02d2n+K\nlIZ+QkmNgXCTIRxDCcraQ6yQM8Rcytf3x4jZSpbHPY85lAbbHyBND+sfuldb0XQ/\ncM1LI8C55bmDA3iEahp0FqFypEph+QEDdwwaPKEY26ZDgFQwdiJI2QsydQYd53TV\nuiOBTnWdw2hRI6a51xelfaPYtg==\n-----END PRIVATE KEY-----\n",
      "client_email":
          "flutter-messaging-app@messenger-app-8556c.iam.gserviceaccount.com",
      "client_id": "104446436778487836638",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/flutter-messaging-app%40messenger-app-8556c.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging",
    ];

    http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJSON), scopes);

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJSON),
      scopes,
      client,
    );

    client.close();

    return credentials.accessToken.data;
  }

  static void sendNotification(
      {required UserModel currentUser, required String messageToBeSent}) async {
    final String serverKey = await getAccessToken();
    String endpointFirebaseCloudMessaging =
        "https://fcm.googleapis.com/v1/projects/messenger-app-8556c/messages:send";
    var deviceToken = await FirebaseMessaging.instance.getToken();

    final Map<String, dynamic> message = {
      'message': {
        'token': deviceToken,
        'topic': 'all',
        'notification': {
          'title': 'Test message title',
          'body': 'Test message body',
        },
        'data': {
          'currentUser': {
            // 'userID': currentUser.userID,
            // 'email': currentUser.email,
            'userName': currentUser.userName,
            'profilePhotoURL': currentUser.profilePhotoURL,
          },
          'message': messageToBeSent,
        },
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFirebaseCloudMessaging),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $serverKey',
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      debugPrint('Notification sent successfully');
    } else {
      debugPrint('Failed sending notification! Status: ${response.statusCode}');
    }
  }
}


//   static final NotificationService _singleton = NotificationService._internal();
//   factory NotificationService() {
//     return _singleton;
//   }
//   NotificationService._internal();