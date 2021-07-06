class CrimeLocation {
  final String id;
  final String loc_details;
  final String province;
  final String amphur;
  final String district;
  final String zipcode;
  final double lat;
  final double lng;
  final String news_title;
  final String news_details;
  final String news_id;
  final DateTime created_at;

  CrimeLocation._(
      this.id,
      this.loc_details,
      this.province,
      this.amphur,
      this.district,
      this.zipcode,
      this.lat,
      this.lng,
      this.news_title,
      this.news_details,
      this.news_id,
      this.created_at,
  );

  factory CrimeLocation.fromJson(Map json){
    return CrimeLocation._(
        json['id'],
        json['loc_details'],
        json['province'],
        json['amphur'],
        json['district'],
        json['zipcode'],
        json['lat'],
        json['lng'],
        json['news_title'],
        json['news_details'],
        json['news_id'],
        json['created_at'],
    );
  }
}