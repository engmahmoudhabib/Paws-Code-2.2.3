/// data : {"id":62,"mobile":null,"account_type":{"id":"breeder","desc":"????"},"contacts":null,"service_provider":null,"user":{"id":62,"status":{"id":"uncompleted","desc":"??? ?????"},"name":{"first":"Yazan","last":"Habeb","full":"Yazan Habeb"},"user_type":{"id":2,"desc":"????"},"username_type":{"id":"facebook","desc":"??????"}},"location":null}
/// token : "1|09xmaUTCZccheGfi8XJqMAiMUOXTQkjGpgoMKVCm"
/// unread_notifications_count : 0
/// message : {"text":"Logged in successfully","type":"success"}

class AuthResponse {
  final DataBean? data;
  final String? token;
  final int? unreadNotificationsCount;
  final MessageBean? message;

  AuthResponse(
      this.data, this.token, this.unreadNotificationsCount, this.message);

  static AuthResponse fromMap(Map<String, dynamic> map) {
    AuthResponse authResponseBean = AuthResponse(
      map['data'] != null ? DataBean.fromMap(map['data']) : null,
      map['token'],
      map['unread_notifications_count'],
      map['message'] != null ? MessageBean.fromMap(map['message']) : null,
    );
    return authResponseBean;
  }

  Map toJson() => {
        "data": data?.toJson(),
        "token": token,
        "unread_notifications_count": unreadNotificationsCount,
        "message": message?.toJson(),
      }..removeWhere((k, v) => v == null);
}

/// text : "Logged in successfully"
/// type : "success"

class MessageBean {
  final String? text;
  final String? type;

  isSuccess() {
    return type == 'success';
  }

  MessageBean(this.text, this.type);

  static MessageBean fromMap(Map<String, dynamic> map) {
    MessageBean messageBean = MessageBean(
      map['text'],
      map['type'],
    );
    return messageBean;
  }

  Map toJson() => {
        "text": text,
        "type": type,
      }..removeWhere((k, v) => v == null);
}

/// id : 62
/// mobile : null
/// account_type : {"id":"breeder","desc":"????"}
/// contacts : null
/// service_provider : null
/// user : {"id":62,"status":{"id":"uncompleted","desc":"??? ?????"},"name":{"first":"Yazan","last":"Habeb","full":"Yazan Habeb"},"user_type":{"id":2,"desc":"????"},"username_type":{"id":"facebook","desc":"??????"}}
/// location : null

class DataBean {
  final int? id;
  final dynamic? mobile;
  final Account_typeBean? accountType;
  final dynamic? contacts;
  final dynamic? serviceProvider;
  final UserBean? user;
  final dynamic? location;

  DataBean(this.id, this.mobile, this.accountType, this.contacts,
      this.serviceProvider, this.user, this.location);

  static DataBean fromMap(Map<String, dynamic> map) {
    DataBean dataBean = DataBean(
      map['id'],
      map['mobile'],
      map['account_type'] != null
          ? Account_typeBean.fromMap(map['account_type'])
          : null,
      map['contacts'],
      map['service_provider'],
      map['user'] != null ? UserBean.fromMap(map['user']) : null,
      map['location'],
    );
    return dataBean;
  }

  Map toJson() => {
        "id": id,
        "mobile": mobile,
        "account_type": accountType?.toJson(),
        "contacts": contacts,
        "service_provider": serviceProvider,
        "user": user?.toJson(),
        "location": location,
      }..removeWhere((k, v) => v == null);
}

/// id : 62
/// status : {"id":"uncompleted","desc":"??? ?????"}
/// name : {"first":"Yazan","last":"Habeb","full":"Yazan Habeb"}
/// user_type : {"id":2,"desc":"????"}
/// username_type : {"id":"facebook","desc":"??????"}

class UserBean {
  final int? id;

  final String? username;

  final StatusBean? status;
  final NameBean? name;
  final User_typeBean? userType;
  final Username_typeBean? usernameType;

  UserBean(this.id, this.username, this.status, this.name, this.userType,
      this.usernameType);

  static UserBean fromMap(Map<String, dynamic> map) {
    UserBean userBean = UserBean(
      map['id'],
      map['username'],
      map['status'] != null ? StatusBean.fromMap(map['status']) : null,
      map['name'] != null ? NameBean.fromMap(map['name']) : null,
      map['user_type'] != null ? User_typeBean.fromMap(map['user_type']) : null,
      map['username_type'] != null
          ? Username_typeBean.fromMap(map['username_type'])
          : null,
    );
    return userBean;
  }

  Map toJson() => {
        "id": id,
        "username": username,
        "status": status?.toJson(),
        "name": name?.toJson(),
        "user_type": userType?.toJson(),
        "username_type": usernameType?.toJson(),
      }..removeWhere((k, v) => v == null);
}

/// id : "facebook"
/// desc : "??????"

class Username_typeBean {
  final String? id;
  final String? desc;

  isSocial() {
    return id == 'facebook' || id == 'google' || id == 'apple';
  }

  Username_typeBean(this.id, this.desc);

  static Username_typeBean fromMap(Map<String, dynamic> map) {
    Username_typeBean username_typeBean = Username_typeBean(
      map['id'],
      map['desc'],
    );
    return username_typeBean;
  }

  Map toJson() => {
        "id": id,
        "desc": desc,
      }..removeWhere((k, v) => v == null);
}

/// id : 2
/// desc : "????"

class User_typeBean {
  final int? id;
  final String? desc;

  User_typeBean(this.id, this.desc);

  static User_typeBean fromMap(Map<String, dynamic> map) {
    User_typeBean user_typeBean = User_typeBean(
      map['id'],
      map['desc'],
    );
    return user_typeBean;
  }

  Map toJson() => {
        "id": id,
        "desc": desc,
      }..removeWhere((k, v) => v == null);
}

/// first : "Yazan"
/// last : "Habeb"
/// full : "Yazan Habeb"

class NameBean {
  final String? first;
  final String? last;
  final String? full;

  NameBean(this.first, this.last, this.full);

  static NameBean fromMap(Map<String, dynamic> map) {
    NameBean nameBean = NameBean(
      map['first'],
      map['last'],
      map['full'],
    );
    return nameBean;
  }

  Map toJson() => {
        "first": first,
        "last": last,
        "full": full,
      }..removeWhere((k, v) => v == null);
}

/// id : "uncompleted"
/// desc : "??? ?????"

class StatusBean {
  final String? id;
  final String? desc;

  StatusBean(this.id, this.desc);

  static StatusBean fromMap(Map<String, dynamic> map) {
    StatusBean statusBean = StatusBean(
      map['id'],
      map['desc'],
    );
    return statusBean;
  }

  Map toJson() => {
        "id": id,
        "desc": desc,
      }..removeWhere((k, v) => v == null);
}

/// id : "breeder"
/// desc : "????"

class Account_typeBean {
  final String? id;
  final String? desc;

  Account_typeBean(this.id, this.desc);

  static Account_typeBean fromMap(Map<String, dynamic> map) {
    Account_typeBean account_typeBean = Account_typeBean(
      map['id'],
      map['desc'],
    );
    return account_typeBean;
  }

  Map toJson() => {
        "id": id,
        "desc": desc,
      }..removeWhere((k, v) => v == null);
}
