import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_app/config/ApplicationCore.dart';
import 'package:flutter_app/models/api/AuthResponse.dart';
import 'package:flutter_app/models/api/ErrorsResponse.dart';
import 'package:flutter_app/ui/screen/accounts/CompleteAccountScreen.dart';
import 'package:flutter_app/ui/screen/accounts/LoginScreen.dart';
import 'package:flutter_app/ui/screen/services/ActivateServicesScreen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';

import 'APIRepository.dart';

part 'NetworkExceptions.freezed.dart';

@freezed
abstract class NetworkExceptions with _$NetworkExceptions {
  const factory NetworkExceptions.requestCancelled() = RequestCancelled;

  const factory NetworkExceptions.unauthorisedRequest() = UnauthorisedRequest;

  const factory NetworkExceptions.badRequest() = BadRequest;

  const factory NetworkExceptions.notFound(String reason) = NotFound;

  const factory NetworkExceptions.methodNotAllowed() = MethodNotAllowed;

  const factory NetworkExceptions.notAcceptable() = NotAcceptable;

  const factory NetworkExceptions.requestTimeout() = RequestTimeout;

  const factory NetworkExceptions.sendTimeout() = SendTimeout;

  const factory NetworkExceptions.conflict() = Conflict;

  const factory NetworkExceptions.internalServerError() = InternalServerError;

  const factory NetworkExceptions.notImplemented() = NotImplemented;

  const factory NetworkExceptions.serviceUnavailable() = ServiceUnavailable;

  const factory NetworkExceptions.noInternetConnection() = NoInternetConnection;

  const factory NetworkExceptions.formatException() = FormatException;

  const factory NetworkExceptions.unableToProcess() = UnableToProcess;

  const factory NetworkExceptions.defaultError(String error) = DefaultError;

  const factory NetworkExceptions.unexpectedError() = UnexpectedError;

  static NetworkExceptions getDioException(error) {
    if (error is Exception) {
      try {
        NetworkExceptions networkExceptions;
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              networkExceptions = NetworkExceptions.requestCancelled();
              break;
            case DioErrorType.connectTimeout:
              networkExceptions = NetworkExceptions.requestTimeout();
              break;
            case DioErrorType.other:
              networkExceptions = NetworkExceptions.noInternetConnection();
              break;
            case DioErrorType.receiveTimeout:
              networkExceptions = NetworkExceptions.sendTimeout();
              break;
            case DioErrorType.response:
              switch (error.response!.statusCode) {
                case 422:
                  networkExceptions = NetworkExceptions.defaultError(
                      ErrorsResponse.fromMap(error.response!.data)
                          .getErrorText());
                  break;
                case 429:
                  networkExceptions = NetworkExceptions.defaultError(
                      ErrorsResponse.fromMap(error.response!.data)
                          .getErrorText());
                  break;
                case 449:
                  networkExceptions = NetworkExceptions.defaultError('');
                  GetIt.I<APIRepository>().stopLoadingDialog();
                  try {
                    var authResponse;

                    authResponse =
                        AuthResponse.fromMap(GetStorage().read('account'));

                    if (error.response!.data['step'] == 'account_step') {
                      GetIt.I<ApplicationCore>().goTo(
                          CompleteAccountScreen.generatePath(),
                          data: authResponse);
                    } else {
                      GetIt.I<ApplicationCore>()
                          .goTo(ActivateServicesScreen.generatePath());
                    }
                  } catch (e) {}

                  break;
                case 401:
                  networkExceptions = NetworkExceptions.defaultError(
                      ErrorsResponse.fromMap(error.response!.data)
                          .getErrorText());
                  GetIt.I<APIRepository>().stopLoadingDialog();
                  GetStorage().remove('token');
                  GetStorage().remove('account');
                  GetIt.I<ApplicationCore>().goTo(LoginScreen.generatePath());
                  break;
                case 400:
                  networkExceptions = NetworkExceptions.unauthorisedRequest();
                  break;

                case 403:
                  networkExceptions = NetworkExceptions.defaultError(
                      ErrorsResponse.fromMap(error.response!.data)
                          .getErrorText());
                  break;
                case 404:
                  networkExceptions = NetworkExceptions.defaultError(
                      ErrorsResponse.fromMap(error.response!.data)
                          .getErrorText());
                  break;
                case 409:
                  networkExceptions = NetworkExceptions.defaultError(
                      ErrorsResponse.fromMap(error.response!.data)
                          .getErrorText());
                  break;
                case 408:
                  networkExceptions = NetworkExceptions.requestTimeout();
                  break;
                case 500:
                  // networkExceptions = NetworkExceptions.internalServerError();
                  networkExceptions = NetworkExceptions.defaultError(
                      ErrorsResponse.fromMap(error.response!.data)
                          .getErrorText());
                  break;
                case 503:
                  // networkExceptions = NetworkExceptions.serviceUnavailable();
                  networkExceptions = NetworkExceptions.defaultError(
                      ErrorsResponse.fromMap(error.response!.data)
                          .getErrorText());
                  break;
                default:
                  var responseCode = error.response!.statusCode;
                  networkExceptions = NetworkExceptions.defaultError(
                    "Received invalid status code: $responseCode",
                  );
              }
              break;
            case DioErrorType.sendTimeout:
              networkExceptions = NetworkExceptions.sendTimeout();
              break;
          }
        } else if (error is SocketException) {
          networkExceptions = NetworkExceptions.noInternetConnection();
        } else {
          networkExceptions = NetworkExceptions.unexpectedError();
        }
        return networkExceptions;
      } on FormatException catch (e) {
        // Helper.printError(e.toString());
        return NetworkExceptions.formatException();
      } catch (_) {
        return NetworkExceptions.unexpectedError();
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return NetworkExceptions.unableToProcess();
      } else {
        return NetworkExceptions.unexpectedError();
      }
    }
  }

  static String getErrorMessage(NetworkExceptions networkExceptions) {
    var errorMessage = "";
    if (networkExceptions == null) {
      errorMessage = "Not Internet";
    } else
      networkExceptions.when(notImplemented: () {
        errorMessage = "Not Implemented";
      }, requestCancelled: () {
        errorMessage = "Request Cancelled";
      }, internalServerError: () {
        errorMessage = "Internal Server Error";
      }, notFound: (String reason) {
        errorMessage = reason;
      }, serviceUnavailable: () {
        errorMessage = "Service unavailable";
      }, methodNotAllowed: () {
        errorMessage = "Method Allowed";
      }, badRequest: () {
        errorMessage = "Bad request";
      }, unauthorisedRequest: () {
        errorMessage = "Unauthorised request";
      }, unexpectedError: () {
        errorMessage = "Unexpected error occurred";
      }, requestTimeout: () {
        errorMessage = "Connection request timeout";
      }, noInternetConnection: () {
        errorMessage = "No internet connection";
      }, conflict: () {
        errorMessage = "Error due to a conflict";
      }, sendTimeout: () {
        errorMessage = "Send timeout in connection with API server";
      }, unableToProcess: () {
        errorMessage = "Unable to process the data";
      }, defaultError: (String error) {
        errorMessage = error;
      }, formatException: () {
        errorMessage = "Unexpected error occurred";
      }, notAcceptable: () {
        errorMessage = "Not acceptable";
      });
    return errorMessage;
  }
}
