part of 'order_cubit.dart';

@immutable
abstract class OrderState {}

class OrderInitial extends OrderState {}




class AddOrderGetDataLoad extends OrderState {}
class AddOrderLoadDataSuccess extends OrderState {
}
class AddOrderLoadDataError extends OrderState {}



//orderDetails
class UpdateOrderDetailsLoad extends OrderState {}
class UpdateOrderDetailsSuccess extends OrderState {
}
class UpdateOrderDetailsError extends OrderState {}


class GetOrderGetDataLoad extends OrderState {}
class GetOrderLoadDataSuccess extends OrderState {
}
class GetOrderLoadDataError extends OrderState {}



//delete
class DeleteOrderGetDataLoad extends OrderState {}
class DeleteOrderLoadDataSuccess extends OrderState {

  final String success;

  DeleteOrderLoadDataSuccess(this.success);
}
class DeleteOrderLoadDataError extends OrderState {}

class ChangeStepperOrderStae extends OrderState {}

class ChangeStatus extends OrderState {}

