///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class CartActionDataCartTotalAmountIqd {
/*
{
  "value": "5944680.000",
  "currency": "د.ع",
  "formatted": "5,944,680 د.ع"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  CartActionDataCartTotalAmountIqd({
    this.value,
    this.currency,
    this.formatted,
  });

  CartActionDataCartTotalAmountIqd.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    value = json["value"]?.toString();
    currency = json["currency"]?.toString();
    formatted = json["formatted"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["value"] = value;
    data["currency"] = currency;
    data["formatted"] = formatted;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class CartActionDataCartTotalAmount {
/*
{
  "value": "5944680.000",
  "currency": "د.ع",
  "formatted": "5,944,680 د.ع"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  CartActionDataCartTotalAmount({
    this.value,
    this.currency,
    this.formatted,
  });

  CartActionDataCartTotalAmount.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    value = json["value"]?.toString();
    currency = json["currency"]?.toString();
    formatted = json["formatted"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["value"] = value;
    data["currency"] = currency;
    data["formatted"] = formatted;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class CartActionDataCart {
/*
{
  "id": 1,
  "total_items": 1,
  "total_amount": {
    "value": "5944680.000",
    "currency": "د.ع",
    "formatted": "5,944,680 د.ع"
  },
  "total_amount_iqd": {
    "value": "5944680.000",
    "currency": "د.ع",
    "formatted": "5,944,680 د.ع"
  }
}
*/

  String? id;
  String? totalItems;
  CartActionDataCartTotalAmount? totalAmount;
  CartActionDataCartTotalAmountIqd? totalAmountIqd;
  Map<String, dynamic> __origJson = {};

  CartActionDataCart({
    this.id,
    this.totalItems,
    this.totalAmount,
    this.totalAmountIqd,
  });

  CartActionDataCart.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    id = json["id"]?.toString();
    totalItems = json["total_items"]?.toString();
    totalAmount =
        (json["total_amount"] != null && (json["total_amount"] is Map))
            ? CartActionDataCartTotalAmount.fromJson(json["total_amount"])
            : null;
    totalAmountIqd = (json["total_amount_iqd"] != null &&
            (json["total_amount_iqd"] is Map))
        ? CartActionDataCartTotalAmountIqd.fromJson(json["total_amount_iqd"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["total_items"] = totalItems;
    if (totalAmount != null) {
      data["total_amount"] = totalAmount!.toJson();
    }
    if (totalAmountIqd != null) {
      data["total_amount_iqd"] = totalAmountIqd!.toJson();
    }
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class CartActionDataItem {
/*
{
  "id": 1
}
*/

  String? id;
  Map<String, dynamic> __origJson = {};

  CartActionDataItem({
    this.id,
  });

  CartActionDataItem.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    id = json["id"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class CartActionData {
/*
{
  "item": {
    "id": 1
  },
  "cart": {
    "id": 1,
    "total_items": 1,
    "total_amount": {
      "value": "5944680.000",
      "currency": "د.ع",
      "formatted": "5,944,680 د.ع"
    },
    "total_amount_iqd": {
      "value": "5944680.000",
      "currency": "د.ع",
      "formatted": "5,944,680 د.ع"
    }
  }
}
*/

  CartActionDataItem? item;
  CartActionDataCart? cart;
  Map<String, dynamic> __origJson = {};

  CartActionData({
    this.item,
    this.cart,
  });

  CartActionData.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    item = (json["item"] != null && (json["item"] is Map))
        ? CartActionDataItem.fromJson(json["item"])
        : null;
    cart = (json["cart"] != null && (json["cart"] is Map))
        ? CartActionDataCart.fromJson(json["cart"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (item != null) {
      data["item"] = item!.toJson();
    }
    if (cart != null) {
      data["cart"] = cart!.toJson();
    }
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class CartAction {
/*
{
  "data": {
    "item": {
      "id": 1
    },
    "cart": {
      "id": 1,
      "total_items": 1,
      "total_amount": {
        "value": "5944680.000",
        "currency": "د.ع",
        "formatted": "5,944,680 د.ع"
      },
      "total_amount_iqd": {
        "value": "5944680.000",
        "currency": "د.ع",
        "formatted": "5,944,680 د.ع"
      }
    }
  }
}
*/

  bool? isShow;
  CartActionData? data;
  Map<String, dynamic> __origJson = {};

  CartAction({
    this.data,
    this.isShow = true,
  });

  bool shouldShow() {
    return (isShow ?? true) && int.parse(data?.cart?.totalItems ?? '0') > 0;
  }

  CartAction.fromJson(Map<String, dynamic> json) {
    __origJson = json;

    data = (json["data"] != null && (json["data"] is Map))
        ? CartActionData.fromJson(json["data"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (data != null) {
      data["data"] = this.data!.toJson();
    }
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}
