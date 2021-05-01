import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:ecommerce_store_admin/models/coupon.dart';
import 'package:ecommerce_store_admin/repositories/user_data_repository.dart';
import 'package:meta/meta.dart';

part 'manage_coupons_event.dart';
part 'manage_coupons_state.dart';

class ManageCouponsBloc extends Bloc<ManageCouponsEvent, ManageCouponsState> {
  final UserDataRepository userDataRepository;

  ManageCouponsBloc({this.userDataRepository}) : super(ManageCouponsInitial());

  @override
  Stream<ManageCouponsState> mapEventToState(
    ManageCouponsEvent event,
  ) async* {
    if (event is AddNewCoupon) {
      yield* mapAddNewCouponToState(event.map);
    }
    if (event is EditCoupon) {
      yield* mapEditCouponToState(event.map);
    }
    if (event is GetAllCoupons) {
      yield* mapGetAllCouponsToState();
    }
  }

  Stream<ManageCouponsState> mapAddNewCouponToState(Map map) async* {
    yield AddNewCouponInProgressState();
    try {
      String res = await userDataRepository.addNewCoupon(map);
      if (res != null) {
        yield AddNewCouponCompletedState(res);
      } else {
        yield AddNewCouponFailedState();
      }
    } catch (e) {
      print(e);
      yield AddNewCouponFailedState();
    }
  }

  Stream<ManageCouponsState> mapEditCouponToState(Map map) async* {
    yield EditCouponInProgressState();
    try {
      String res = await userDataRepository.editCoupon(map);
      if (res != null) {
        yield EditCouponCompletedState(res);
      } else {
        yield EditCouponFailedState();
      }
    } catch (e) {
      print(e);
      yield EditCouponFailedState();
    }
  }

  Stream<ManageCouponsState> mapGetAllCouponsToState() async* {
    yield GetAllCouponsInProgressState();
    try {
      List<Coupon> res = await userDataRepository.getAllCoupons();
      if (res != null) {
        yield GetAllCouponsCompletedState(res);
      } else {
        yield GetAllCouponsFailedState();
      }
    } catch (e) {
      print(e);
      yield GetAllCouponsFailedState();
    }
  }
}
