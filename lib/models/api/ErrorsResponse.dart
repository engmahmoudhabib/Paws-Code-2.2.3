/// message : "The given data was invalid."
/// errors : {"account_type":["The value you have entered is invalid."],"mobile":["???? ?? ?? ??? ???????? ?? ??? ???? ???? ??? ????"],"contacts":["contacts ?????."],"contacts.whatsapp_same_as_mobile":["?? ???? ?????? ??? ??? ?????? ?????."],"contacts.viber_same_as_mobile":["?? ???? ????? ??? ??? ?????? ?????."]}

class ErrorsResponse {
  final String? message;
  final dynamic errors;
  final String? error;

  ErrorsResponse(this.message, this.errors, this.error);

  getErrorText() {
    String text = '';

    try {
      text = error! + '\n';
    } catch (e) {}

    try {
      if (errors != null)
        errors.forEach((key, value) {
          value.forEach((element) {
            text += element + '\n';
          });
        });
      else
        text = message!;
    } catch (e) {
      return e.toString();
    }
    return text;
  }

  static ErrorsResponse fromMap(Map<String, dynamic> map) {
    ErrorsResponse errorsResponseBean;

    try {
      errorsResponseBean =
          ErrorsResponse(map['message'], map['errors'], map['error']);
    } catch (e) {
      errorsResponseBean = ErrorsResponse(map.toString(), null, null);
    }
    return errorsResponseBean;
  }

  Map toJson() => {
        "message": message,
      }..removeWhere((k, v) => v == null);
}
