import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

String? getFormattedDate(DateTime? dt, {String pattern = 'yyyy-MM-dd'}) {
  if (dt == null) return null;
  return DateFormat(pattern).format(dt);
}

showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));
}

/*
Future<void> launchPhone(String phoneNumber) async {
  final Uri url = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}

Future<void> launchSms(String phoneNumber) async {
  final Uri url = Uri(scheme: 'sms', path: phoneNumber);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}

Future<void> launchMail(String email) async {
  final Uri url = Uri(scheme: 'mailto', path: email);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}

Future<void> launchWeb(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  }
}

// Future<void> launchMap(String location) async {
//   final Uri url = Uri(scheme: 'geo', path: location);
//   if (await canLaunchUrl(url)) {
//     await launchUrl(url);
//   }
// }
Future<void> launchMap(String location) async {
  Uri url;
  if (Platform.isAndroid) {
    url = Uri(scheme: 'geo', path: location);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      url = Uri.parse('http//maps.apple.com/?q=$location');
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      }
    }
  }
}

 */



