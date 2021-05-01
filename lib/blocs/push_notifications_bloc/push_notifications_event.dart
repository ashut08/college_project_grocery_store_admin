part of 'push_notifications_bloc.dart';

@immutable
abstract class PushNotificationsEvent {}

class SendNewNotification extends PushNotificationsEvent {
  final Map map;

  SendNewNotification(this.map);
}
