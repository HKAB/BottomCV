import 'dart:convert';

class Job {
   final int id;
   final String title;
   final String companyName;
   final String category;
   final String officeLocation;
   final String deadline;
   final String description;
   final String requirement;
   final String welfare;
   final String companyLogo;
   final double lat;
   final double long;
  Job({
    this.id,
    this.title,
    this.companyName,
    this.category,
    this.officeLocation,
    this.deadline,
    this.description,
    this.requirement,
    this.welfare,
    this.companyLogo,
    this.lat,
    this.long,
  });

  Job copyWith({
    int id,
    String title,
    String companyName,
    String category,
    String officeLocation,
    String deadline,
    String description,
    String requirement,
    String welfare,
    String companyLogo,
    double lat,
    double long,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      companyName: companyName ?? this.companyName,
      category: category ?? this.category,
      officeLocation: officeLocation ?? this.officeLocation,
      deadline: deadline ?? this.deadline,
      description: description ?? this.description,
      requirement: requirement ?? this.requirement,
      welfare: welfare ?? this.welfare,
      companyLogo: companyLogo ?? this.companyLogo,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'companyName': companyName,
      'category': category,
      'officeLocation': officeLocation,
      'deadline': deadline,
      'description': description,
      'requirement': requirement,
      'welfare': welfare,
      'companyLogo': companyLogo,
      'lat': lat,
      'long': long,
    };
  }

  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'],
      title: map['title'],
      companyName: map['company_name'],
      category: map['category'],
      officeLocation: map['office_location'],
      deadline: map['deadline'],
      description: map['description'],
      requirement: map['requirement'],
      welfare: map['welfare'],
      companyLogo: map['company_logo'],
      lat: map['lat'],
      long: map['long'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Job.fromJson(String source) => Job.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Job(id: $id, title: $title, companyName: $companyName, category: $category, officeLocation: $officeLocation, deadline: $deadline, description: $description, requirement: $requirement, welfare: $welfare, companyLogo: $companyLogo, lat: $lat, long: $long)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Job &&
      other.id == id &&
      other.title == title &&
      other.companyName == companyName &&
      other.category == category &&
      other.officeLocation == officeLocation &&
      other.deadline == deadline &&
      other.description == description &&
      other.requirement == requirement &&
      other.welfare == welfare &&
      other.companyLogo == companyLogo &&
      other.lat == lat &&
      other.long == long;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      companyName.hashCode ^
      category.hashCode ^
      officeLocation.hashCode ^
      deadline.hashCode ^
      description.hashCode ^
      requirement.hashCode ^
      welfare.hashCode ^
      companyLogo.hashCode ^
      lat.hashCode ^
      long.hashCode;
  }
}
