///
/// Code generated by jsonToDartModel https://ashamp.github.io/jsonToDartModel/
///
class AnimalsListDataMetaLinks {
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

  AnimalsListDataMetaLinks({
    this.url,
    this.label,
    this.active,
  });

  AnimalsListDataMetaLinks.fromJson(Map<String, dynamic> json) {
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

class AnimalsListDataMeta {
/*
{
  "current_page": 1,
  "from": 1,
  "last_page": 5,
  "links": [
    {
      "url": null,
      "label": "&laquo; Previous",
      "active": false
    }
  ],
  "path": "https://api.thepaws.app/api/v1/animals",
  "per_page": "10",
  "to": 10,
  "total": 50
}
*/

  String? currentPage;
  String? from;
  String? lastPage;
  List<AnimalsListDataMetaLinks?>? links;
  String? path;
  String? perPage;
  String? to;
  String? total;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataMeta({
    this.currentPage,
    this.from,
    this.lastPage,
    this.links,
    this.path,
    this.perPage,
    this.to,
    this.total,
  });

  AnimalsListDataMeta.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    currentPage = json["current_page"]?.toString();
    from = json["from"]?.toString();
    lastPage = json["last_page"]?.toString();
    if (json["links"] != null && (json["links"] is List)) {
      final v = json["links"];
      final arr0 = <AnimalsListDataMetaLinks>[];
      v.forEach((v) {
        arr0.add(AnimalsListDataMetaLinks.fromJson(v));
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

class AnimalsListDataLinks {
/*
{
  "first": "https://api.thepaws.app/api/v1/animals?perpage=10&page=1",
  "last": "https://api.thepaws.app/api/v1/animals?perpage=10&page=5",
  "prev": null,
  "next": "https://api.thepaws.app/api/v1/animals?perpage=10&page=2"
}
*/

  String? first;
  String? last;
  String? prev;
  String? next;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataLinks({
    this.first,
    this.last,
    this.prev,
    this.next,
  });

  AnimalsListDataLinks.fromJson(Map<String, dynamic> json) {
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

class AnimalsListDataDataAvatarConversionsMedium {
/*
{
  "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-medium.jpg"
}
*/

  String? url;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataAvatarConversionsMedium({
    this.url,
  });

  AnimalsListDataDataAvatarConversionsMedium.fromJson(
      Map<String, dynamic> json) {
    __origJson = json;
    url = json["url"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["url"] = url;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataAvatarConversionsSmall {
/*
{
  "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-small.jpg"
}
*/

  String? url;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataAvatarConversionsSmall({
    this.url,
  });

  AnimalsListDataDataAvatarConversionsSmall.fromJson(
      Map<String, dynamic> json) {
    __origJson = json;
    url = json["url"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["url"] = url;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataAvatarConversionsLarge {
/*
{
  "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-large.jpg"
}
*/

  String? url;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataAvatarConversionsLarge({
    this.url,
  });

  AnimalsListDataDataAvatarConversionsLarge.fromJson(
      Map<String, dynamic> json) {
    __origJson = json;
    url = json["url"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["url"] = url;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataAvatarConversions {
/*
{
  "large": {
    "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-large.jpg"
  },
  "small": {
    "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-small.jpg"
  },
  "medium": {
    "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-medium.jpg"
  }
}
*/

  AnimalsListDataDataAvatarConversionsLarge? large;
  AnimalsListDataDataAvatarConversionsSmall? small;
  AnimalsListDataDataAvatarConversionsMedium? medium;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataAvatarConversions({
    this.large,
    this.small,
    this.medium,
  });

  AnimalsListDataDataAvatarConversions.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    large = (json["large"] != null && (json["large"] is Map))
        ? AnimalsListDataDataAvatarConversionsLarge.fromJson(json["large"])
        : null;
    small = (json["small"] != null && (json["small"] is Map))
        ? AnimalsListDataDataAvatarConversionsSmall.fromJson(json["small"])
        : null;
    medium = (json["medium"] != null && (json["medium"] is Map))
        ? AnimalsListDataDataAvatarConversionsMedium.fromJson(json["medium"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (large != null) {
      data["large"] = large!.toJson();
    }
    if (small != null) {
      data["small"] = small!.toJson();
    }
    if (medium != null) {
      data["medium"] = medium!.toJson();
    }
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataAvatar {
/*
{
  "id": 302,
  "conversions": {
    "large": {
      "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-large.jpg"
    },
    "small": {
      "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-small.jpg"
    },
    "medium": {
      "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-medium.jpg"
    }
  },
  "file_name": "meeting-new-dogs.jpg",
  "properties": [
    null
  ]
}
*/

  String? id;
  AnimalsListDataDataAvatarConversions? conversions;
  String? fileName;
  List<String?>? properties;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataAvatar({
    this.id,
    this.conversions,
    this.fileName,
    this.properties,
  });

  AnimalsListDataDataAvatar.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    id = json["id"]?.toString();
    conversions = (json["conversions"] != null && (json["conversions"] is Map))
        ? AnimalsListDataDataAvatarConversions.fromJson(json["conversions"])
        : null;
    fileName = json["file_name"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    if (conversions != null) {
      data["conversions"] = conversions!.toJson();
    }
    data["file_name"] = fileName;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataOfferPrice {
/*
{
  "value": "0.00",
  "currency": "USD",
  "formatted": "$0.00"
}
*/

  String? value;
  String? currency;
  String? formatted;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataOfferPrice({
    this.value,
    this.currency,
    this.formatted,
  });

  AnimalsListDataDataOfferPrice.fromJson(Map<String, dynamic> json) {
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

class AnimalsListDataDataOfferType {
/*
{
  "id": "adoption",
  "desc": "????????"
}
*/

  String? id;
  String? desc;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataOfferType({
    this.id,
    this.desc,
  });

  AnimalsListDataDataOfferType.fromJson(Map<String, dynamic> json) {
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

class AnimalsListDataDataOffer {
/*
{
  "id": 1,
  "type": {
    "id": "adoption",
    "desc": "????????"
  },
  "is_active": true,
  "description": "Quo qui consequatur impedit in praesentium similique voluptatem. Quo atque quam vero laborum consequatur a autem eum. Quasi qui iste quidem dicta sint deleniti laudantium. Velit voluptatem blanditiis aut quae consequuntur ut.",
  "price": {
    "value": "0.00",
    "currency": "USD",
    "formatted": "$0.00"
  }
}
*/

  String? id;
  AnimalsListDataDataOfferType? type;
  bool? isActive;
  String? description;
  AnimalsListDataDataOfferPrice? price;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataOffer({
    this.id,
    this.type,
    this.isActive,
    this.description,
    this.price,
  });

  AnimalsListDataDataOffer.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    id = json["id"]?.toString();
    type = (json["type"] != null && (json["type"] is Map))
        ? AnimalsListDataDataOfferType.fromJson(json["type"])
        : null;
    isActive = json["is_active"];
    description = json["description"]?.toString();
    price = (json["price"] != null && (json["price"] is Map))
        ? AnimalsListDataDataOfferPrice.fromJson(json["price"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    if (type != null) {
      data["type"] = type!.toJson();
    }
    data["is_active"] = isActive;
    data["description"] = description;
    if (price != null) {
      data["price"] = price!.toJson();
    }
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataSpecies {
/*
{
  "id": 16,
  "name": "Consectetur expedita dicta ut totam dolorum dignissimos dolore.",
  "animal_type": "dog",
  "is_hybrid": false
}
*/

  String? id;
  String? name;
  String? animalType;
  bool? isHybrid;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataSpecies({
    this.id,
    this.name,
    this.animalType,
    this.isHybrid,
  });

  AnimalsListDataDataSpecies.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    id = json["id"]?.toString();
    name = json["name"]?.toString();
    animalType = json["animal_type"]?.toString();
    isHybrid = json["is_hybrid"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    data["animal_type"] = animalType;
    data["is_hybrid"] = isHybrid;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataColor {
/*
{
  "id": 3,
  "name": "??????????"
}
*/

  String? id;
  String? name;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataColor({
    this.id,
    this.name,
  });

  AnimalsListDataDataColor.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    id = json["id"]?.toString();
    name = json["name"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["name"] = name;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataReactions {
/*
{
  "is_favorited": false
}
*/

  bool? isFavorited;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataReactions({
    this.isFavorited,
  });

  AnimalsListDataDataReactions.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    isFavorited = json["is_favorited"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["is_favorited"] = isFavorited;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataPropertiesHairStyle {
/*
{
  "id": "long_hair",
  "desc": "?????? ????????"
}
*/

  String? id;
  String? desc;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataPropertiesHairStyle({
    this.id,
    this.desc,
  });

  AnimalsListDataDataPropertiesHairStyle.fromJson(Map<String, dynamic> json) {
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

class AnimalsListDataDataProperties {
/*
{
  "is_hybrid": false,
  "is_sterilized": true,
  "hair_style": {
    "id": "long_hair",
    "desc": "?????? ????????"
  }
}
*/

  bool? isHybrid;
  bool? isSterilized;
  AnimalsListDataDataPropertiesHairStyle? hairStyle;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataProperties({
    this.isHybrid,
    this.isSterilized,
    this.hairStyle,
  });

  AnimalsListDataDataProperties.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    isHybrid = json["is_hybrid"];
    isSterilized = json["is_sterilized"];
    hairStyle = (json["hair_style"] != null && (json["hair_style"] is Map))
        ? AnimalsListDataDataPropertiesHairStyle.fromJson(json["hair_style"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["is_hybrid"] = isHybrid;
    data["is_sterilized"] = isSterilized;
    if (hairStyle != null) {
      data["hair_style"] = hairStyle!.toJson();
    }
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataAge {
/*
{
  "friendly": "2 years and 11 months"
}
*/

  String? friendly;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataAge({
    this.friendly,
  });

  AnimalsListDataDataAge.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    friendly = json["friendly"]?.toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["friendly"] = friendly;
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListDataDataGender {
/*
{
  "id": "female",
  "desc": "????????"
}
*/

  String? id;
  String? desc;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataGender({
    this.id,
    this.desc,
  });

  AnimalsListDataDataGender.fromJson(Map<String, dynamic> json) {
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

class AnimalsListDataDataType {
/*
{
  "id": "dog",
  "desc": "??????"
}
*/

  String? id;
  String? desc;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataType({
    this.id,
    this.desc,
  });

  AnimalsListDataDataType.fromJson(Map<String, dynamic> json) {
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

class AnimalsListDataDataStatus {
/*
{
  "id": "adoption",
  "desc": "????????"
}
*/

  String? id;
  String? desc;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataDataStatus({
    this.id,
    this.desc,
  });

  AnimalsListDataDataStatus.fromJson(Map<String, dynamic> json) {
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

class AnimalsListDataData {
/*
{
  "id": 1,
  "status": {
    "id": "adoption",
    "desc": "????????"
  },
  "type": {
    "id": "dog",
    "desc": "??????"
  },
  "name": "Officia dolorum.",
  "gender": {
    "id": "female",
    "desc": "????????"
  },
  "share_url": "https://api.thepaws.app",
  "age": {
    "friendly": "2 years and 11 months"
  },
  "properties": {
    "is_hybrid": false,
    "is_sterilized": true,
    "hair_style": {
      "id": "long_hair",
      "desc": "?????? ????????"
    }
  },
  "reactions": {
    "is_favorited": false
  },
  "color": {
    "id": 3,
    "name": "??????????"
  },
  "species": {
    "id": 16,
    "name": "Consectetur expedita dicta ut totam dolorum dignissimos dolore.",
    "animal_type": "dog",
    "is_hybrid": false
  },
  "offer": {
    "id": 1,
    "type": {
      "id": "adoption",
      "desc": "????????"
    },
    "is_active": true,
    "description": "Quo qui consequatur impedit in praesentium similique voluptatem. Quo atque quam vero laborum consequatur a autem eum. Quasi qui iste quidem dicta sint deleniti laudantium. Velit voluptatem blanditiis aut quae consequuntur ut.",
    "price": {
      "value": "0.00",
      "currency": "USD",
      "formatted": "$0.00"
    }
  },
  "avatar": {
    "id": 302,
    "conversions": {
      "large": {
        "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-large.jpg"
      },
      "small": {
        "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-small.jpg"
      },
      "medium": {
        "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-medium.jpg"
      }
    },
    "file_name": "meeting-new-dogs.jpg",
    "properties": [
      null
    ]
  }
}
*/

  String? id;
  AnimalsListDataDataStatus? status;
  AnimalsListDataDataType? type;
  String? name;
  dynamic breeder;
  String? code;

  AnimalsListDataDataGender? gender;
  String? shareUrl;
  AnimalsListDataDataAge? age;
  AnimalsListDataDataProperties? properties;
  AnimalsListDataDataReactions? reactions;
  AnimalsListDataDataColor? color;
  AnimalsListDataDataSpecies? species;
  AnimalsListDataDataOffer? offer;
  AnimalsListDataDataAvatar? avatar;
  Map<String, dynamic> __origJson = {};

  AnimalsListDataData({
    this.id,
    this.status,
    this.type,
    this.name,
    this.gender,
    this.shareUrl,
    this.age,
    this.breeder,
    this.code,
    this.properties,
    this.reactions,
    this.color,
    this.species,
    this.offer,
    this.avatar,
  });

  AnimalsListDataData.fromJson(Map<String, dynamic> json) {
    __origJson = json;

    code = json["code"]?.toString();
    breeder = json["breeder"];

    id = json["id"]?.toString();
    status = (json["status"] != null && (json["status"] is Map))
        ? AnimalsListDataDataStatus.fromJson(json["status"])
        : null;
    type = (json["type"] != null && (json["type"] is Map))
        ? AnimalsListDataDataType.fromJson(json["type"])
        : null;
    name = json["name"]?.toString();
    gender = (json["gender"] != null && (json["gender"] is Map))
        ? AnimalsListDataDataGender.fromJson(json["gender"])
        : null;
    shareUrl = json["share_url"]?.toString();
    age = (json["age"] != null && (json["age"] is Map))
        ? AnimalsListDataDataAge.fromJson(json["age"])
        : null;
    properties = (json["properties"] != null && (json["properties"] is Map))
        ? AnimalsListDataDataProperties.fromJson(json["properties"])
        : null;
    reactions = (json["reactions"] != null && (json["reactions"] is Map))
        ? AnimalsListDataDataReactions.fromJson(json["reactions"])
        : null;
    color = (json["color"] != null && (json["color"] is Map))
        ? AnimalsListDataDataColor.fromJson(json["color"])
        : null;
    species = (json["species"] != null && (json["species"] is Map))
        ? AnimalsListDataDataSpecies.fromJson(json["species"])
        : null;
    offer = (json["offer"] != null && (json["offer"] is Map))
        ? AnimalsListDataDataOffer.fromJson(json["offer"])
        : null;
    avatar = (json["avatar"] != null && (json["avatar"] is Map))
        ? AnimalsListDataDataAvatar.fromJson(json["avatar"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;

    data["breeder"] = breeder;

    if (status != null) {
      data["status"] = status!.toJson();
    }
    if (type != null) {
      data["type"] = type!.toJson();
    }
    data["name"] = name;
    if (gender != null) {
      data["gender"] = gender!.toJson();
    }
    data["share_url"] = shareUrl;
    if (age != null) {
      data["age"] = age!.toJson();
    }
    if (properties != null) {
      data["properties"] = properties!.toJson();
    }
    if (reactions != null) {
      data["reactions"] = reactions!.toJson();
    }
    if (color != null) {
      data["color"] = color!.toJson();
    }
    if (species != null) {
      data["species"] = species!.toJson();
    }
    if (offer != null) {
      data["offer"] = offer!.toJson();
    }
    if (avatar != null) {
      data["avatar"] = avatar!.toJson();
    }
    return data;
  }

  Map<String, dynamic> origJson() => __origJson;
}

class AnimalsListData {
/*
{
  "data": [
    {
      "id": 1,
      "status": {
        "id": "adoption",
        "desc": "????????"
      },
      "type": {
        "id": "dog",
        "desc": "??????"
      },
      "name": "Officia dolorum.",
      "gender": {
        "id": "female",
        "desc": "????????"
      },
      "share_url": "https://api.thepaws.app",
      "age": {
        "friendly": "2 years and 11 months"
      },
      "properties": {
        "is_hybrid": false,
        "is_sterilized": true,
        "hair_style": {
          "id": "long_hair",
          "desc": "?????? ????????"
        }
      },
      "reactions": {
        "is_favorited": false
      },
      "color": {
        "id": 3,
        "name": "??????????"
      },
      "species": {
        "id": 16,
        "name": "Consectetur expedita dicta ut totam dolorum dignissimos dolore.",
        "animal_type": "dog",
        "is_hybrid": false
      },
      "offer": {
        "id": 1,
        "type": {
          "id": "adoption",
          "desc": "????????"
        },
        "is_active": true,
        "description": "Quo qui consequatur impedit in praesentium similique voluptatem. Quo atque quam vero laborum consequatur a autem eum. Quasi qui iste quidem dicta sint deleniti laudantium. Velit voluptatem blanditiis aut quae consequuntur ut.",
        "price": {
          "value": "0.00",
          "currency": "USD",
          "formatted": "$0.00"
        }
      },
      "avatar": {
        "id": 302,
        "conversions": {
          "large": {
            "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-large.jpg"
          },
          "small": {
            "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-small.jpg"
          },
          "medium": {
            "url": "https://api.thepaws.app/storage/media/302/conversions/meeting-new-dogs-medium.jpg"
          }
        },
        "file_name": "meeting-new-dogs.jpg",
        "properties": [
          null
        ]
      }
    }
  ],
  "links": {
    "first": "https://api.thepaws.app/api/v1/animals?perpage=10&page=1",
    "last": "https://api.thepaws.app/api/v1/animals?perpage=10&page=5",
    "prev": null,
    "next": "https://api.thepaws.app/api/v1/animals?perpage=10&page=2"
  },
  "meta": {
    "current_page": 1,
    "from": 1,
    "last_page": 5,
    "links": [
      {
        "url": null,
        "label": "&laquo; Previous",
        "active": false
      }
    ],
    "path": "https://api.thepaws.app/api/v1/animals",
    "per_page": "10",
    "to": 10,
    "total": 50
  }
}
*/

  List<AnimalsListDataData>? data;
  AnimalsListDataLinks? links;
  AnimalsListDataMeta? meta;
  Map<String, dynamic> __origJson = {};

  AnimalsListData({
    this.data,
    this.links,
    this.meta,
  });

  AnimalsListData.fromJson(Map<String, dynamic> json) {
    __origJson = json;
    if (json["data"] != null && (json["data"] is List)) {
      final v = json["data"];
      final arr0 = <AnimalsListDataData>[];
      v.forEach((v) {
        arr0.add(AnimalsListDataData.fromJson(v));
      });
      this.data = arr0;
    }
    links = (json["links"] != null && (json["links"] is Map))
        ? AnimalsListDataLinks.fromJson(json["links"])
        : null;
    meta = (json["meta"] != null && (json["meta"] is Map))
        ? AnimalsListDataMeta.fromJson(json["meta"])
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
