/// id : 1
/// name : "Pedigree"
/// logo : {"id":227,"conversions":{"large":{"url":"https://api.thepaws.app/storage/media/227/conversions/pedigree-large.jpg"},"small":{"url":"https://api.thepaws.app/storage/media/227/conversions/pedigree-small.jpg"},"medium":{"url":"https://api.thepaws.app/storage/media/227/conversions/pedigree-medium.jpg"}},"file_name":"pedigree.jpg","properties":[]}

class Brand {
  final int? id;
  final String? name;
  final LogoBean? logo;

  Brand(this.id, this.name, this.logo);

  static Brand fromMap(Map<String, dynamic> map) {
    Brand brandBean = Brand(
     map['id'],
     map['name'],
     map['logo']!=null ? LogoBean.fromMap(map['logo']) : null,
    );
    return brandBean;
  }

  Map toJson() => {
    "id": id,
    "name": name,
    "logo": logo?.toJson(),
  };
}

/// id : 227
/// conversions : {"large":{"url":"https://api.thepaws.app/storage/media/227/conversions/pedigree-large.jpg"},"small":{"url":"https://api.thepaws.app/storage/media/227/conversions/pedigree-small.jpg"},"medium":{"url":"https://api.thepaws.app/storage/media/227/conversions/pedigree-medium.jpg"}}
/// file_name : "pedigree.jpg"
/// properties : []

class LogoBean {
  final int? id;
  final ConversionsBean? conversions;
  final String? fileName;
  final List<dynamic>? properties;

  LogoBean(this.id, this.conversions, this.fileName, this.properties);

  static LogoBean fromMap(Map<String, dynamic> map) {
    LogoBean logoBean = LogoBean(
     map['id'],
     map['conversions']!=null ? ConversionsBean.fromMap(map['conversions']) : null,
     map['file_name'],
     map['properties'],
    );
    return logoBean;
  }

  Map toJson() => {
    "id": id,
    "conversions": conversions?.toJson(),
    "file_name": fileName,
    "properties": properties,
  };
}

/// large : {"url":"https://api.thepaws.app/storage/media/227/conversions/pedigree-large.jpg"}
/// small : {"url":"https://api.thepaws.app/storage/media/227/conversions/pedigree-small.jpg"}
/// medium : {"url":"https://api.thepaws.app/storage/media/227/conversions/pedigree-medium.jpg"}

class ConversionsBean {
  final LargeBean? large;
  final SmallBean? small;
  final MediumBean? medium;

  ConversionsBean(this.large, this.small, this.medium);

  static ConversionsBean fromMap(Map<String, dynamic> map) {
    ConversionsBean conversionsBean = ConversionsBean(
     map['large']!=null ? LargeBean.fromMap(map['large']) : null,
     map['small']!=null ? SmallBean.fromMap(map['small']) : null,
     map['medium']!=null ? MediumBean.fromMap(map['medium']) : null,
    );
    return conversionsBean;
  }

  Map toJson() => {
    "large": large?.toJson(),
    "small": small?.toJson(),
    "medium": medium?.toJson(),
  };
}

/// url : "https://api.thepaws.app/storage/media/227/conversions/pedigree-medium.jpg"

class MediumBean {
  final String? url;

  MediumBean(this.url);

  static MediumBean fromMap(Map<String, dynamic> map) {
    MediumBean mediumBean = MediumBean(
     map['url'],
    );
    return mediumBean;
  }

  Map toJson() => {
    "url": url,
  };
}

/// url : "https://api.thepaws.app/storage/media/227/conversions/pedigree-small.jpg"

class SmallBean {
  final String? url;

  SmallBean(this.url);

  static SmallBean fromMap(Map<String, dynamic> map) {
    SmallBean smallBean = SmallBean(
     map['url'],
    );
    return smallBean;
  }

  Map toJson() => {
    "url": url,
  };
}

/// url : "https://api.thepaws.app/storage/media/227/conversions/pedigree-large.jpg"

class LargeBean {
  final String? url;

  LargeBean(this.url);

  static LargeBean fromMap(Map<String, dynamic> map) {
    LargeBean largeBean = LargeBean(
     map['url'],
    );
    return largeBean;
  }

  Map toJson() => {
    "url": url,
  };
}