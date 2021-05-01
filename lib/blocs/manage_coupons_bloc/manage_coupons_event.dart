part of 'manage_coupons_bloc.dart';

@immutable
abstract class ManageCouponsEvent {}

class AddNewCoupon extends ManageCouponsEvent {
  final Map map;

  AddNewCoupon(this.map);
}

class EditCoupon extends ManageCouponsEvent {
  final Map map;

  EditCoupon(this.map);
}

class GetAllCoupons extends ManageCouponsEvent {}
