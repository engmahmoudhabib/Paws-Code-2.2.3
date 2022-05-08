import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'NetworkExceptions.dart';
part 'ApiResult.freezed.dart';

@freezed
abstract class ApiResult<T> with _$ApiResult<T> {

  const factory ApiResult.success({required T data}) = Success<T>;
  const factory ApiResult.failure({required NetworkExceptions error}) =Failure<T>;

}