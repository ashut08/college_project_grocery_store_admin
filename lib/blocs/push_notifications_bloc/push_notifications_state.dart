part of 'push_notifications_bloc.dart';

@immutable
abstract class PushNotificationsState {}

class PushNotificationsInitial extends PushNotificationsState {}

class SendNewNotificationCompletedState extends PushNotificationsState {
  final String res;

  SendNewNotificationCompletedState(this.res);
}

class SendNewNotificationFailedState extends PushNotificationsState {}

class SendNewNotificationInProgressState extends PushNotificationsState {}
