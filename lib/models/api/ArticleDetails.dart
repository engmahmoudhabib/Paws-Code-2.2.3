/// data : {"id":13,"status":{"id":"published","desc":"?????"},"title":"In in velit ipsum dignissimos officiis qui ratione eveniet delectus a ut iure.","text":"<h2>Repellat aperiam laboriosam est veritatis.</h2>Cumque cum aut quo ad occaecati nulla deleniti. Eligendi maiores nemo nihil dolores rem dolores non ut. Vitae similique quam velit soluta. Cum possimus eligendi voluptates aliquam dolore et. Ut cumque ut qui est quia quia consequatur hic. Aut consequuntur ut possimus et et. Quibusdam et ad quia vel omnis nisi quam. Rerum iure impedit voluptatem aut. Ut omnis recusandae fugit occaecati. Unde dolore temporibus saepe aliquam ut sapiente labore. Occaecati occaecati dolorem autem molestiae. Sunt ut vel exercitationem eaque maxime deserunt ut. In autem tempora dicta nam. Dicta quisquam repellendus dolores tempora libero. Quia sit debitis aut pariatur ut quos hic. Sequi molestiae vitae minima quis eos ut voluptates. Esse labore neque tenetur dolorem animi accusantium qui. Iure quia quo doloribus. Voluptatibus itaque ut consequatur perspiciatis ut rerum. Earum ex tempore consectetur accusamus animi qui tempore. Sint exercitationem eveniet ut repellendus dolore culpa. Similique sed nemo tempora aut laboriosam. Fugit ut recusandae eligendi labore id autem voluptatum dolore. Corrupti ratione voluptatum facilis quis quod. Rem animi rerum perspiciatis eum tenetur ut minima omnis. Consectetur quaerat velit ducimus ullam soluta. Nobis et non aliquid ad. Repudiandae veniam eveniet unde itaque. Labore voluptatem aut veniam tenetur est quo. Dolor minima porro qui aut perferendis illo. Porro veritatis molestias aut magnam odio amet quam. Nisi vero omnis aut. Nihil itaque est dolores optio laudantium. Iusto aliquid voluptatem perferendis dolorem optio omnis. Id est nesciunt ad ad sunt corrupti voluptas. Inventore laboriosam omnis nulla distinctio reprehenderit. Magnam laudantium iste ab voluptatibus accusamus. A quidem officia recusandae dolores sed qui et. Molestiae ut fugit ut dolorem. Et quia vitae eaque et. Officiis ea distinctio quia libero. Voluptatibus iusto temporibus ipsam soluta et suscipit.","animal_type":{"id":"cat","desc":"??"},"source_type":{"id":"written","desc":"?????"},"source":null,"published_at":"2013/03/19","image":{"conversions":{"large":{"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-large.jpg"},"small":{"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-small.jpg"},"medium":{"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-medium.jpg"}},"file_name":"71xvF9YdX9L._AC_SL1500_.jpg"},"tags":[{"id":1,"name":"?????"},{"id":2,"name":"?????"},{"id":4,"name":"??????? ????"}]}

class ArticleDetails {
  final DataBean? data;

  ArticleDetails(this.data);

  static ArticleDetails fromMap(Map<String, dynamic> map) {
    ArticleDetails articleDetailsBean = ArticleDetails(
     map['data']!=null ? DataBean.fromMap(map['data']) : null,
    );
    return articleDetailsBean;
  }

  Map toJson() => {
    "data": data?.toJson(),
  }..removeWhere((k,v)=>v==null);
}

/// id : 13
/// status : {"id":"published","desc":"?????"}
/// title : "In in velit ipsum dignissimos officiis qui ratione eveniet delectus a ut iure."
/// text : "<h2>Repellat aperiam laboriosam est veritatis.</h2>Cumque cum aut quo ad occaecati nulla deleniti. Eligendi maiores nemo nihil dolores rem dolores non ut. Vitae similique quam velit soluta. Cum possimus eligendi voluptates aliquam dolore et. Ut cumque ut qui est quia quia consequatur hic. Aut consequuntur ut possimus et et. Quibusdam et ad quia vel omnis nisi quam. Rerum iure impedit voluptatem aut. Ut omnis recusandae fugit occaecati. Unde dolore temporibus saepe aliquam ut sapiente labore. Occaecati occaecati dolorem autem molestiae. Sunt ut vel exercitationem eaque maxime deserunt ut. In autem tempora dicta nam. Dicta quisquam repellendus dolores tempora libero. Quia sit debitis aut pariatur ut quos hic. Sequi molestiae vitae minima quis eos ut voluptates. Esse labore neque tenetur dolorem animi accusantium qui. Iure quia quo doloribus. Voluptatibus itaque ut consequatur perspiciatis ut rerum. Earum ex tempore consectetur accusamus animi qui tempore. Sint exercitationem eveniet ut repellendus dolore culpa. Similique sed nemo tempora aut laboriosam. Fugit ut recusandae eligendi labore id autem voluptatum dolore. Corrupti ratione voluptatum facilis quis quod. Rem animi rerum perspiciatis eum tenetur ut minima omnis. Consectetur quaerat velit ducimus ullam soluta. Nobis et non aliquid ad. Repudiandae veniam eveniet unde itaque. Labore voluptatem aut veniam tenetur est quo. Dolor minima porro qui aut perferendis illo. Porro veritatis molestias aut magnam odio amet quam. Nisi vero omnis aut. Nihil itaque est dolores optio laudantium. Iusto aliquid voluptatem perferendis dolorem optio omnis. Id est nesciunt ad ad sunt corrupti voluptas. Inventore laboriosam omnis nulla distinctio reprehenderit. Magnam laudantium iste ab voluptatibus accusamus. A quidem officia recusandae dolores sed qui et. Molestiae ut fugit ut dolorem. Et quia vitae eaque et. Officiis ea distinctio quia libero. Voluptatibus iusto temporibus ipsam soluta et suscipit."
/// animal_type : {"id":"cat","desc":"??"}
/// source_type : {"id":"written","desc":"?????"}
/// source : null
/// published_at : "2013/03/19"
/// image : {"conversions":{"large":{"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-large.jpg"},"small":{"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-small.jpg"},"medium":{"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-medium.jpg"}},"file_name":"71xvF9YdX9L._AC_SL1500_.jpg"}
/// tags : [{"id":1,"name":"?????"},{"id":2,"name":"?????"},{"id":4,"name":"??????? ????"}]

class DataBean {
  final int? id;
  final StatusBean? status;
  final String? title;
  final String? text;
  final Animal_typeBean? animalType;
  final Source_typeBean? sourceType;
  final dynamic? source;
  final String? publishedAt;
  final ImageBean? image;
  final List<TagsBean>? tags;

  DataBean(this.id, this.status, this.title, this.text, this.animalType, this.sourceType, this.source, this.publishedAt, this.image, this.tags);

  static DataBean fromMap(Map<String, dynamic> map) {
    DataBean dataBean = DataBean(
     map['id'],
     map['status']!=null ? StatusBean.fromMap(map['status']) : null,
     map['title'],
     map['text'],
     map['animal_type']!=null ? Animal_typeBean.fromMap(map['animal_type']) : null,
     map['source_type']!=null ? Source_typeBean.fromMap(map['source_type']) : null,
     map['source'],
     map['published_at'],
     map['image']!=null ? ImageBean.fromMap(map['image']) : null,
     map['tags']!=null ? ([]..addAll(
       (map['tags'] as List).map((o) => TagsBean.fromMap(o))
     )) : null,
    );
    return dataBean;
  }

  Map toJson() => {
    "id": id,
    "status": status?.toJson(),
    "title": title,
    "text": text,
    "animal_type": animalType?.toJson(),
    "source_type": sourceType?.toJson(),
    "source": source?.toJson(),
    "published_at": publishedAt,
    "image": image?.toJson(),
    "tags": tags?.map((o)=>o.toJson()).toList(growable: false),
  }..removeWhere((k,v)=>v==null);
}

/// id : 1
/// name : "?????"

class TagsBean {
  final int? id;
  final String? name;

  TagsBean(this.id, this.name);

  static TagsBean fromMap(Map<String, dynamic> map) {
    TagsBean tagsBean = TagsBean(
     map['id'],
     map['name'],
    );
    return tagsBean;
  }

  Map toJson() => {
    "id": id,
    "name": name,
  }..removeWhere((k,v)=>v==null);
}

/// conversions : {"large":{"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-large.jpg"},"small":{"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-small.jpg"},"medium":{"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-medium.jpg"}}
/// file_name : "71xvF9YdX9L._AC_SL1500_.jpg"

class ImageBean {
  final ConversionsBean? conversions;
  final String? fileName;

  ImageBean(this.conversions, this.fileName);

  static ImageBean fromMap(Map<String, dynamic> map) {
    ImageBean imageBean = ImageBean(
     map['conversions']!=null ? ConversionsBean.fromMap(map['conversions']) : null,
     map['file_name'],
    );
    return imageBean;
  }

  Map toJson() => {
    "conversions": conversions?.toJson(),
    "file_name": fileName,
  }..removeWhere((k,v)=>v==null);
}

/// large : {"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-large.jpg"}
/// small : {"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-small.jpg"}
/// medium : {"url":"https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-medium.jpg"}

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
  }..removeWhere((k,v)=>v==null);
}

/// url : "https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-medium.jpg"

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
  }..removeWhere((k,v)=>v==null);
}

/// url : "https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-small.jpg"

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
  }..removeWhere((k,v)=>v==null);
}

/// url : "https://api.thepaws.app/storage/media/105/conversions/71xvF9YdX9L._AC_SL1500_-large.jpg"

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
  }..removeWhere((k,v)=>v==null);
}

/// id : "written"
/// desc : "?????"

class Source_typeBean {
  final String? id;
  final String? desc;

  Source_typeBean(this.id, this.desc);

  static Source_typeBean fromMap(Map<String, dynamic> map) {
    Source_typeBean source_typeBean = Source_typeBean(
     map['id'],
     map['desc'],
    );
    return source_typeBean;
  }

  Map toJson() => {
    "id": id,
    "desc": desc,
  }..removeWhere((k,v)=>v==null);
}

/// id : "cat"
/// desc : "??"

class Animal_typeBean {
  final String? id;
  final String? desc;

  Animal_typeBean(this.id, this.desc);

  static Animal_typeBean fromMap(Map<String, dynamic> map) {
    Animal_typeBean animal_typeBean = Animal_typeBean(
     map['id'],
     map['desc'],
    );
    return animal_typeBean;
  }

  Map toJson() => {
    "id": id,
    "desc": desc,
  }..removeWhere((k,v)=>v==null);
}

/// id : "published"
/// desc : "?????"

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
  }..removeWhere((k,v)=>v==null);
}