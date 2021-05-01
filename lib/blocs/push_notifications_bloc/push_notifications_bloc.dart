import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'push_notifications_event.dart';
part 'push_notifications_state.dart';

class PushNotificationsBloc
    extends Bloc<PushNotificationsEvent, PushNotificationsState> {
  final UserDataRepository userDataRepository;

  PushNotificationsBloc({this.userDataRepository})
      : super(PushNotificationsInitial());

  @override
  Stream<PushNotificationsState> mapEventToState(
    PushNotificationsEvent event,
  ) async* {
    if (event is SendNewNotification) {
      yield* mapSendNewNotificationToState(event.map);
    }
  }

  Stream<PushNotificationsState> mapSendNewNotificationToState(Map map) async* {
    yield SendNewNotificationInProgressState();
    try {
      String res = await userDataRepository.sendNewNotification(map);
      if (res != null) {
        yield SendNewNotificationCompletedState(res);
      } else {
        yield SendNewNotificationFailedState();
      }
    } catch (e) {
      print(e);
      yield SendNewNotificationFailedState();
    }
  }
}
