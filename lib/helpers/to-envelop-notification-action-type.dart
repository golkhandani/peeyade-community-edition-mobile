import 'package:pyd/enums/envelop-notification-action-type.dart';

EnvelopNotificationActionType toEnvelopNotificationActionType(String str) {
  switch (str) {
    case 'alert':
      return EnvelopNotificationActionType.alert;
    case 'banner':
      return EnvelopNotificationActionType.banner;
    default:
      return EnvelopNotificationActionType.alert;
  }
}
