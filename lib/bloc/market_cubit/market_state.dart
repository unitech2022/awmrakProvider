part of 'market_cubit.dart';

@immutable
abstract class MarketState {}

class MarketInitial extends MarketState {}

class GetMarketLoad extends MarketState {}

class GetMarketSuccess extends MarketState {}

class GetMarketError extends MarketState {}





class AddMarketLoad extends MarketState {}

class AddMarketSuccess extends MarketState {}

class AddMarketError extends MarketState {}
