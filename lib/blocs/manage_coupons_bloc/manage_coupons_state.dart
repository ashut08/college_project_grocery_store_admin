part of 'manage_coupons_bloc.dart';

@immutable
abstract class ManageCouponsState {}

class ManageCouponsInitial extends ManageCouponsState {}

class AddNewCouponCompletedState extends ManageCouponsState {
  final String res;

  AddNewCouponCompletedState(this.res);
}

class AddNewCouponFailedState extends ManageCouponsState {}

class AddNewCouponInProgressState extends ManageCouponsState {}

class EditCouponCompletedState extends ManageCouponsState {
  final String res;

  EditCouponCompletedState(this.res);
}

class EditCouponFailedState extends ManageCouponsState {}

class EditCouponInProgressState extends ManageCouponsState {}

class GetAllCouponsCompletedState extends ManageCouponsState {
  final List<Coupon> coupons;

  GetAllCouponsCompletedState(this.coupons);
}

class GetAllCouponsFailedState extends ManageCouponsState {}

class GetAllCouponsInProgressState extends ManageCouponsState {}
