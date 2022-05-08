///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class OrdersResponseMetaLinks {
/*
{
  "url": null,
  "label": "&laquo; Previous",
  "active": false
}
*/

  String? url;
  String? label;
  bool? active;
  Map<String, dynamic> __origJson = {};

  OrdersResponseMetaLinks({
    this.url,
    this.label,
    this.active,
  });
  OrdersResponseMetaLinks.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    url = json["url"]?.toString();
    label = json["label"]?.toString();
    active = json["active"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["url"] = url;
    data["label"] = label;
    data["active"] = active;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class OrdersResponseMeta {
/*
{
  "current_page": 1,
  "from": 1,
  "last_page": 1,
  "links": [
    {
      "url": null,
      "label": "&laquo; Previous",
      "active": false
    }
  ],
  "path": "http://paws.test/api/v1/orders",
  "per_page": "5",
  "to": 1,
  "total": 1
}
*/

  String? currentPage;
  String? from;
  String? lastPage;
  List<OrdersResponseMetaLinks?>? links;
  String? path;
  String? perPage;
  String? to;
  String? total;
  Map<String, dynamic> __origJson = {};

  OrdersResponseMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });
  OrdersResponseMeta.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    currentPage = json["current_page"]?.toString();
    from = json["from"]?.toString();
    lastPage = json["last_page"]?.toString();
    if (json["links"] != null && (json["links"] is List)) {
      final v = json["links"];
      final arr0 = <OrdersResponseMetaLinks>[];
      v.forEach((v) {
        arr0.add(OrdersResponseMetaLinks.fromJson(v));
      });
      links = arr0;
    }
    path = json["path"]?.toString();
    perPage = json["per_page"]?.toString();
    to = json["to"]?.toString();
    total = json["total"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["current_page"] = currentPage;
    data["from"] = from;
    data["last_page"] = lastPage;
    if (links != null) {
      final v = links;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["links"] = arr0;
    }
    data["path"] = path;
    data["per_page"] = perPage;
    data["to"] = to;
    data["total"] = total;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class OrdersResponseLinks {
/*
{
  "first": "http://paws.test/api/v1/orders?perpage=5&status=pending&page=1",
  "last": "http://paws.test/api/v1/orders?perpage=5&status=pending&page=1",
  "prev": null,
  "next": null
}
*/

  String? first;
  String? last;
  String? prev;
  String? next;
  Map<String, dynamic> __origJson = {};

  OrdersResponseLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });
  OrdersResponseLinks.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    first = json["first"]?.toString();
    last = json["last"]?.toString();
    prev = json["prev"]?.toString();
    next = json["next"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["first"] = first;
    data["last"] = last;
    data["prev"] = prev;
    data["next"] = next;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class OrdersResponseDataTotalAmountIqd {
/*
{
  "value": "782499.200",
  "currency": "IQD",
  "formatted": "782,499 IQD"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  OrdersResponseDataTotalAmountIqd({
    this.value,
    this.currency,
    this.formatted,
  });
  OrdersResponseDataTotalAmountIqd.fromJson(Map<String, dynamic> json) {
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

class OrdersResponseDataTotalAmount {
/*
{
  "value": "782499.200",
  "currency": "IQD",
  "formatted": "782,499 IQD"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  OrdersResponseDataTotalAmount({
    this.value,
    this.currency,
    this.formatted,
  });
  OrdersResponseDataTotalAmount.fromJson(Map<String, dynamic> json) {
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

class OrdersResponseDataPromocodeDiscountAmount {
/*
{
  "value": "826.800",
  "currency": "IQD",
  "formatted": "827 IQD"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  OrdersResponseDataPromocodeDiscountAmount({
    this.value,
    this.currency,
    this.formatted,
  });
  OrdersResponseDataPromocodeDiscountAmount.fromJson(
      Map<String, dynamic> json) {
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

class OrdersResponseDataShippingCosts {
/*
{
  "value": "780570.000",
  "currency": "IQD",
  "formatted": "780,570 IQD"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  OrdersResponseDataShippingCosts({
    this.value,
    this.currency,
    this.formatted,
  });
  OrdersResponseDataShippingCosts.fromJson(Map<String, dynamic> json) {
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

class OrdersResponseDataProductsPrice {
/*
{
  "value": "2756.000",
  "currency": "IQD",
  "formatted": "2,756 IQD"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  OrdersResponseDataProductsPrice({
    this.value,
    this.currency,
    this.formatted,
  });
  OrdersResponseDataProductsPrice.fromJson(Map<String, dynamic> json) {
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

class OrdersResponseDataItemsTotalPrice {
/*
{
  "value": "2756.000",
  "currency": "IQD",
  "formatted": "2,756 IQD"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  OrdersResponseDataItemsTotalPrice({
    this.value,
    this.currency,
    this.formatted,
  });
  OrdersResponseDataItemsTotalPrice.fromJson(Map<String, dynamic> json) {
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

class OrdersResponseDataItemsUnitPriceOriginal {
/*
{
  "value": "689.000",
  "currency": "IQD",
  "formatted": "689 IQD"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  OrdersResponseDataItemsUnitPriceOriginal({
    this.value,
    this.currency,
    this.formatted,
  });
  OrdersResponseDataItemsUnitPriceOriginal.fromJson(Map<String, dynamic> json) {
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

class OrdersResponseDataItemsUnitPrice {
/*
{
  "value": "689.000",
  "currency": "IQD",
  "formatted": "689 IQD"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  OrdersResponseDataItemsUnitPrice({
    this.value,
    this.currency,
    this.formatted,
  });
  OrdersResponseDataItemsUnitPrice.fromJson(Map<String, dynamic> json) {
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

class OrdersResponseDataItems {
/*
{
  "id": 1,
  "unit_price": {
    "value": "689.000",
    "currency": "IQD",
    "formatted": "689 IQD"
  },
  "unit_price_original": {
    "value": "689.000",
    "currency": "IQD",
    "formatted": "689 IQD"
  },
  "total_price": {
    "value": "2756.000",
    "currency": "IQD",
    "formatted": "2,756 IQD"
  },
  "total_quantity": 4,
  "is_deleted": false,
  "is_quantity_available": true
}
*/

  String? id;
  OrdersResponseDataItemsUnitPrice? unitPrice;
  OrdersResponseDataItemsUnitPriceOriginal? unitPriceOriginal;
  OrdersResponseDataItemsTotalPrice? totalPrice;
  String? totalQuantity;
  bool? isDeleted;
  bool? isQuantityAvailable;
  Map<String, dynamic> __origJson = {};

  OrdersResponseDataItems({
    this.id,
    this.unitPrice,
    this.unitPriceOriginal,
    this.totalPrice,
    this.totalQuantity,
    this.isDeleted,
    this.isQuantityAvailable,
  });
  OrdersResponseDataItems.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    id = json["id"]?.toString();
    unitPrice = (json["unit_price"] != null && (json["unit_price"] is Map))
        ? OrdersResponseDataItemsUnitPrice.fromJson(json["unit_price"])
        : null;
    unitPriceOriginal = (json["unit_price_original"] != null &&
            (json["unit_price_original"] is Map))
        ? OrdersResponseDataItemsUnitPriceOriginal.fromJson(
            json["unit_price_original"])
        : null;
    totalPrice = (json["total_price"] != null && (json["total_price"] is Map))
        ? OrdersResponseDataItemsTotalPrice.fromJson(json["total_price"])
        : null;
    totalQuantity = json["total_quantity"]?.toString();
    isDeleted = json["is_deleted"];
    isQuantityAvailable = json["is_quantity_available"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    if (unitPrice != null) {
      data["unit_price"] = unitPrice!.toJson();
    }
    if (unitPriceOriginal != null) {
      data["unit_price_original"] = unitPriceOriginal!.toJson();
    }
    if (totalPrice != null) {
      data["total_price"] = totalPrice!.toJson();
    }
    data["total_quantity"] = totalQuantity;
    data["is_deleted"] = isDeleted;
    data["is_quantity_available"] = isQuantityAvailable;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class OrdersResponseDataState {
/*
{
  "id": "pending",
  "desc": "Pending"
}
*/

  String? id;
  String? desc;
  Map<String, dynamic> __origJson = {};

  OrdersResponseDataState({
    this.id,
    this.desc,
  });
  OrdersResponseDataState.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    id = json["id"]?.toString();
    desc = json["desc"]?.toString();
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["desc"] = desc;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class OrdersResponseData {
/*
{
  "id": 1,
  "state": {
    "id": "pending",
    "desc": "Pending"
  },
  "requested_at": "2021-11-30",
  "items": [
    {
      "id": 1,
      "unit_price": {
        "value": "689.000",
        "currency": "IQD",
        "formatted": "689 IQD"
      },
      "unit_price_original": {
        "value": "689.000",
        "currency": "IQD",
        "formatted": "689 IQD"
      },
      "total_price": {
        "value": "2756.000",
        "currency": "IQD",
        "formatted": "2,756 IQD"
      },
      "total_quantity": 4,
      "is_deleted": false,
      "is_quantity_available": true
    }
  ],
  "products_price": {
    "value": "2756.000",
    "currency": "IQD",
    "formatted": "2,756 IQD"
  },
  "shipping_costs": {
    "value": "780570.000",
    "currency": "IQD",
    "formatted": "780,570 IQD"
  },
  "promocode_discount_amount": {
    "value": "826.800",
    "currency": "IQD",
    "formatted": "827 IQD"
  },
  "total_amount": {
    "value": "782499.200",
    "currency": "IQD",
    "formatted": "782,499 IQD"
  },
  "usd_iqd_conversion_rate": 1470,
  "total_amount_iqd": {
    "value": "782499.200",
    "currency": "IQD",
    "formatted": "782,499 IQD"
  }
}
*/

  String? id;
  OrdersResponseDataState? state;
  String? requestedAt;
  List<OrdersResponseDataItems?>? items;
  OrdersResponseDataProductsPrice? productsPrice;
  OrdersResponseDataShippingCosts? shippingCosts;
  OrdersResponseDataPromocodeDiscountAmount? promocodeDiscountAmount;
  OrdersResponseDataTotalAmount? totalAmount;
  String? usdIqdConversionRate;
  OrdersResponseDataTotalAmountIqd? totalAmountIqd;
  Map<String, dynamic> __origJson = {};

  OrdersResponseData({
    this.id,
    this.state,
    this.requestedAt,
    this.items,
    this.productsPrice,
    this.shippingCosts,
    this.promocodeDiscountAmount,
    this.totalAmount,
    this.usdIqdConversionRate,
    this.totalAmountIqd,
  });
  OrdersResponseData.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    id = json["id"]?.toString();
    state = (json["state"] != null && (json["state"] is Map))
        ? OrdersResponseDataState.fromJson(json["state"])
        : null;
    requestedAt = json["requested_at"]?.toString();
    if (json["items"] != null && (json["items"] is List)) {
      final v = json["items"];
      final arr0 = <OrdersResponseDataItems>[];
      v.forEach((v) {
        arr0.add(OrdersResponseDataItems.fromJson(v));
      });
      items = arr0;
    }
    productsPrice =
        (json["products_price"] != null && (json["products_price"] is Map))
            ? OrdersResponseDataProductsPrice.fromJson(json["products_price"])
            : null;
    shippingCosts =
        (json["shipping_costs"] != null && (json["shipping_costs"] is Map))
            ? OrdersResponseDataShippingCosts.fromJson(json["shipping_costs"])
            : null;
    promocodeDiscountAmount = (json["promocode_discount_amount"] != null &&
            (json["promocode_discount_amount"] is Map))
        ? OrdersResponseDataPromocodeDiscountAmount.fromJson(
            json["promocode_discount_amount"])
        : null;
    totalAmount =
        (json["total_amount"] != null && (json["total_amount"] is Map))
            ? OrdersResponseDataTotalAmount.fromJson(json["total_amount"])
            : null;
    usdIqdConversionRate = json["usd_iqd_conversion_rate"]?.toString();
    totalAmountIqd = (json["total_amount_iqd"] != null &&
            (json["total_amount_iqd"] is Map))
        ? OrdersResponseDataTotalAmountIqd.fromJson(json["total_amount_iqd"])
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    if (state != null) {
      data["state"] = state!.toJson();
    }
    data["requested_at"] = requestedAt;
    if (items != null) {
      final v = items;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["items"] = arr0;
    }
    if (productsPrice != null) {
      data["products_price"] = productsPrice!.toJson();
    }
    if (shippingCosts != null) {
      data["shipping_costs"] = shippingCosts!.toJson();
    }
    if (promocodeDiscountAmount != null) {
      data["promocode_discount_amount"] = promocodeDiscountAmount!.toJson();
    }
    if (totalAmount != null) {
      data["total_amount"] = totalAmount!.toJson();
    }
    data["usd_iqd_conversion_rate"] = usdIqdConversionRate;
    if (totalAmountIqd != null) {
      data["total_amount_iqd"] = totalAmountIqd!.toJson();
    }
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class OrdersResponse {
/*
{
  "data": [
    {
      "id": 1,
      "state": {
        "id": "pending",
        "desc": "Pending"
      },
      "requested_at": "2021-11-30",
      "items": [
        {
          "id": 1,
          "unit_price": {
            "value": "689.000",
            "currency": "IQD",
            "formatted": "689 IQD"
          },
          "unit_price_original": {
            "value": "689.000",
            "currency": "IQD",
            "formatted": "689 IQD"
          },
          "total_price": {
            "value": "2756.000",
            "currency": "IQD",
            "formatted": "2,756 IQD"
          },
          "total_quantity": 4,
          "is_deleted": false,
          "is_quantity_available": true
        }
      ],
      "products_price": {
        "value": "2756.000",
        "currency": "IQD",
        "formatted": "2,756 IQD"
      },
      "shipping_costs": {
        "value": "780570.000",
        "currency": "IQD",
        "formatted": "780,570 IQD"
      },
      "promocode_discount_amount": {
        "value": "826.800",
        "currency": "IQD",
        "formatted": "827 IQD"
      },
      "total_amount": {
        "value": "782499.200",
        "currency": "IQD",
        "formatted": "782,499 IQD"
      },
      "usd_iqd_conversion_rate": 1470,
      "total_amount_iqd": {
        "value": "782499.200",
        "currency": "IQD",
        "formatted": "782,499 IQD"
      }
    }
  ],
  "links": {
    "first": "http://paws.test/api/v1/orders?perpage=5&status=pending&page=1",
    "last": "http://paws.test/api/v1/orders?perpage=5&status=pending&page=1",
    "prev": null,
    "next": null
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 1,
    "links": [
      {
        "url": null,
        "label": "&laquo; Previous",
        "active": false
      }
    ],
    "path": "http://paws.test/api/v1/orders",
    "per_page": "5",
    "to": 1,
    "total": 1
  }
}
*/

  List<OrdersResponseData>? data;
  OrdersResponseLinks? links;
  OrdersResponseMeta? meta;
  Map<String, dynamic> __origJson = {};

  OrdersResponse({
    this.data,
    this.links,
    this.meta,
  });
  OrdersResponse.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    if (json["data"] != null && (json["data"] is List)) {
      final v = json["data"];
      final arr0 = <OrdersResponseData>[];
      v.forEach((v) {
        arr0.add(OrdersResponseData.fromJson(v));
      });
      this.data = arr0;
    }
    links = (json["links"] != null && (json["links"] is Map))
        ? OrdersResponseLinks.fromJson(json["links"])
        : null;
    meta = (json["meta"] != null && (json["meta"] is Map))
        ? OrdersResponseMeta.fromJson(json["meta"])
        : null;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v.toJson());
      });
      data["data"] = arr0;
    }
    if (links != null) {
      data["links"] = links!.toJson();
    }
    if (meta != null) {
      data["meta"] = meta!.toJson();
    }
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}
