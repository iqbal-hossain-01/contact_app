import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String? getFormattedDate(DateTime? dt, {String pattern = 'yyyy-MM-dd'}) {
  if (dt == null) return null;
  return DateFormat(pattern).format(dt);
}

showMsg(BuildContext context, String msg) {
  ScaffoldMessenger.of(context)
      .showSnackBar(SnackBar(content: Text(msg)));
}