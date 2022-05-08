/// data : [{"id":1,"score":2,"comment":"Cumque molestias est hic vero blanditiis illo vero autem itaque autem impedit atque doloremque eum tenetur dolor incidunt distinctio est rem ratione.","breeder":{"id":30,"full_name":"Osbaldo Krajcik I Gottlieb"}},{"id":2,"score":2,"comment":"At vero ipsa reiciendis doloremque cumque quis illo tempore laborum omnis itaque molestiae cupiditate laboriosam cumque nemo enim architecto suscipit.","breeder":{"id":40,"full_name":"Moriah Stanton Kozey"}},{"id":3,"score":4,"comment":"Cumque ipsam corporis nulla vel repellat aliquam iure commodi ut est atque ut quis ipsam facere itaque aut accusamus nulla quibusdam maxime fuga tenetur deleniti rem dolorem.","breeder":{"id":27,"full_name":"Dr. Eloy Mohr O'Hara"}},{"id":4,"score":1,"comment":"Eos beatae reprehenderit expedita deleniti doloribus quos dicta modi cupiditate voluptates ipsa aut omnis velit voluptas officiis omnis perspiciatis odio aliquid et id fugit.","breeder":{"id":16,"full_name":"Naomi Hessel Sr. Mayer"}},{"id":5,"score":5,"comment":"Vero voluptatem assumenda quibusdam distinctio similique et dolor iste nobis iure soluta quia modi voluptas corporis.","breeder":{"id":57,"full_name":"Halle Hackett Metz"}},{"id":6,"score":4,"comment":"Iste quidem qui eos quisquam est ullam reprehenderit vel dolorem nobis sed sed vero tempora ut blanditiis.","breeder":{"id":14,"full_name":"Ward Hand DDS VonRueden"}},{"id":7,"score":2,"comment":"Aliquam sed aliquid rerum aut aperiam repellendus voluptas quia vel adipisci aut consequatur omnis consequatur id est facilis et excepturi ut voluptatem.","breeder":{"id":31,"full_name":"Roberto Runte V Rempel"}},{"id":8,"score":4,"comment":"Ut doloribus aut harum repellat nam et iste iure aut animi unde neque quia ducimus eaque.","breeder":{"id":36,"full_name":"Leonie Graham Rohan"}},{"id":9,"score":3,"comment":"Nihil autem architecto minus et voluptate amet earum ut qui et veritatis nobis suscipit nam eos rerum.","breeder":{"id":16,"full_name":"Naomi Hessel Sr. Mayer"}},{"id":10,"score":1,"comment":"Dolorum sint vitae et est sit unde expedita libero natus est est quae est molestias natus.","breeder":{"id":45,"full_name":"Ozella Wilderman Boyer"}}]
/// links : {"first":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=1","last":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=21","prev":null,"next":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=2"}
/// meta : {"current_page":1,"from":1,"last_page":21,"links":[{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=1","label":"1","active":true},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=2","label":"2","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=3","label":"3","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=4","label":"4","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=5","label":"5","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=6","label":"6","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=7","label":"7","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=8","label":"8","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=9","label":"9","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=10","label":"10","active":false},{"url":null,"label":"...","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=20","label":"20","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=21","label":"21","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=2","label":"Next &raquo;","active":false}],"path":"https://api.thepaws.app/api/v1/reviews","per_page":"10","to":10,"total":207}

class Reviews {
  final List<ReviewsDataBean>? data;
  final LinksBean? links;
  final MetaBean? meta;

  Reviews(this.data, this.links, this.meta);

  static Reviews fromMap(Map<String, dynamic> map) {
    Reviews reviewsBean = Reviews(
     map['data']!=null ? ([]..addAll(
       (map['data'] as List).map((o) => ReviewsDataBean.fromMap(o))
     )) : null,
     map['links']!=null ? LinksBean.fromMap(map['links']) : null,
     map['meta']!=null ? MetaBean.fromMap(map['meta']) : null,
    );
    return reviewsBean;
  }

  Map toJson() => {
    "data": data?.map((o)=>o.toJson()).toList(growable: false),
    "links": links?.toJson(),
    "meta": meta?.toJson(),
  }..removeWhere((k,v)=>v==null);
}

/// current_page : 1
/// from : 1
/// last_page : 21
/// links : [{"url":null,"label":"&laquo; Previous","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=1","label":"1","active":true},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=2","label":"2","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=3","label":"3","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=4","label":"4","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=5","label":"5","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=6","label":"6","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=7","label":"7","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=8","label":"8","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=9","label":"9","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=10","label":"10","active":false},{"url":null,"label":"...","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=20","label":"20","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=21","label":"21","active":false},{"url":"https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=2","label":"Next &raquo;","active":false}]
/// path : "https://api.thepaws.app/api/v1/reviews"
/// per_page : "10"
/// to : 10
/// total : 207

class MetaBean {
  final int? currentPage;
  final int? from;
  final int? lastPage;
  final List<LinksBean>? links;
  final String? path;
  final String? perPage;
  final int? to;
  final int? total;

  MetaBean(this.currentPage, this.from, this.lastPage, this.links, this.path, this.perPage, this.to, this.total);

  static MetaBean fromMap(Map<String, dynamic> map) {
    MetaBean metaBean = MetaBean(
     map['current_page'],
     map['from'],
     map['last_page'],
     map['links']!=null ? ([]..addAll(
       (map['links'] as List).map((o) => LinksBean.fromMap(o))
     )) : null,
     map['path'],
     map['per_page'],
     map['to'],
     map['total'],
    );
    return metaBean;
  }

  Map toJson() => {
    "current_page": currentPage,
    "from": from,
    "last_page": lastPage,
    "links": links?.map((o)=>o.toJson()).toList(growable: false),
    "path": path,
    "per_page": perPage,
    "to": to,
    "total": total,
  }..removeWhere((k,v)=>v==null);
}

/// url : null
/// label : "&laquo; Previous"
/// active : false

/// first : "https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=1"
/// last : "https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=21"
/// prev : null
/// next : "https://api.thepaws.app/api/v1/reviews?perpage=10&type=service_center&page=2"

class LinksBean {
  final String? first;
  final String? last;
  final dynamic? prev;
  final String? next;

  LinksBean(this.first, this.last, this.prev, this.next);

  static LinksBean fromMap(Map<String, dynamic> map) {
    LinksBean linksBean = LinksBean(
     map['first'],
     map['last'],
     map['prev'],
     map['next'],
    );
    return linksBean;
  }

  Map toJson() => {
    "first": first,
    "last": last,
    "prev": prev?.toJson(),
    "next": next,
  }..removeWhere((k,v)=>v==null);
}

/// id : 1
/// score : 2
/// comment : "Cumque molestias est hic vero blanditiis illo vero autem itaque autem impedit atque doloremque eum tenetur dolor incidunt distinctio est rem ratione."
/// breeder : {"id":30,"full_name":"Osbaldo Krajcik I Gottlieb"}

class ReviewsDataBean {
  final int? id;
  final int? score;
  final String? comment;
  final BreederBean? breeder;

  ReviewsDataBean(this.id, this.score, this.comment, this.breeder);

  static ReviewsDataBean fromMap(Map<String, dynamic> map) {
    ReviewsDataBean dataBean = ReviewsDataBean(
     map['id'],
     map['score'],
     map['comment'],
     map['breeder']!=null ? BreederBean.fromMap(map['breeder']) : null,
    );
    return dataBean;
  }

  Map toJson() => {
    "id": id,
    "score": score,
    "comment": comment,
    "breeder": breeder?.toJson(),
  }..removeWhere((k,v)=>v==null);
}

/// id : 30
/// full_name : "Osbaldo Krajcik I Gottlieb"

class BreederBean {
  final int? id;
  final String? fullName;

  BreederBean(this.id, this.fullName);

  static BreederBean fromMap(Map<String, dynamic> map) {
    BreederBean breederBean = BreederBean(
     map['id'],
     map['full_name'],
    );
    return breederBean;
  }

  Map toJson() => {
    "id": id,
    "full_name": fullName,
  }..removeWhere((k,v)=>v==null);
}