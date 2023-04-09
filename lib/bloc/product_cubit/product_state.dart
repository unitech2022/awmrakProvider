part of 'product_cubit.dart';

@immutable
abstract class ProductState {}

class ProductInitial extends ProductState {}
class GetProductDataLoad extends ProductState {}
class GetProductDataSuccess extends ProductState {}
class GetProductDataError extends ProductState {}



class AddProductDataLoad extends ProductState {}
class AddProductDataSuccess extends ProductState {}
class AddProductDataError extends ProductState {}

class UpdateProductDataLoad extends ProductState {}
class UpdateProductDataSuccess extends ProductState {}
class UpdateProductDataError extends ProductState {}
//
//
//
class RemoveProductOfferDataLoad extends ProductState {}
class RemoveProductOfferDataSuccess extends ProductState {}
class RemoveProductOfferDataError extends ProductState {}
//
//
 class ChangeCheckBox extends ProductState {}




class GetProductOfferDataLoad extends ProductState {}
class GetProductOfferDataSuccess extends ProductState {}
class GetProductOfferDataError extends ProductState {}
