class Metamodel {
  final int total;
  final int limit;
  final int offset;
  final int totalPages;
  final int currentPage;
  final int? langId; // optional, since not all endpoints have it

  Metamodel({
    required this.total,
    required this.limit,
    required this.offset,
    required this.totalPages,
    required this.currentPage,
    this.langId,
  });

  factory Metamodel.fromJson(Map<String, dynamic> json) {
    return Metamodel(
      total: int.tryParse(json['total'].toString()) ?? 0,
      limit: int.tryParse(json['limit'].toString()) ?? 0,
      offset: int.tryParse(json['offset'].toString()) ?? 0,
      totalPages: int.tryParse(json['total_pages'].toString()) ?? 0,
      currentPage: int.tryParse(json['current_page'].toString()) ?? 0,
      langId: json['lang_id'] != null
          ? int.tryParse(json['lang_id'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'limit': limit,
      'offset': offset,
      'total_pages': totalPages,
      'current_page': currentPage,
      if (langId != null) 'lang_id': langId,
    };
  }
}
