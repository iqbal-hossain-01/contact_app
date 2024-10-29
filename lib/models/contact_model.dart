class ContactModel {
  int? id;
  String? name;
  String number;
  String? email;
  String? gender;
  String? address;
  String? website;
  String? image;
  String? dob;
  int? dobTimestamp;
  String? group;
  bool favorite;

  ContactModel({
    this.id,
    this.name,
    required this.number,
    this.email,
    this.gender,
    this.address,
    this.website,
    this.image,
    this.dob,
    this.dobTimestamp,
    this.group,
    this.favorite = false,
  });

  Map<String, dynamic> toMap() {
    final map =  <String, dynamic>{
      'name': name,
      'number': number,
      'email': email,
      'gender': gender,
      'dob': dob,
      'dob_timestamp': dobTimestamp,
      'contact_group': group,
      'address': address,
      'website': website,
      'image': image,
      'favorite': favorite ? 1 : 0,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      name: map['name'] ?? '',
      number: map['number'] ?? '',
      email: map['email'] ?? '',
      gender: map['gender'] ?? '',
      group: map['contact_group'],
      address: map['address'] ?? '',
      website: map['website'] ?? '',
      image: map['image'] ?? '',
      dob: map['dob'] ?? '',
      dobTimestamp: map['dob_timestamp'],
      favorite: map['favorite'] == 0 ? false : true,
    );
  }
  ContactModel copyWith({
    int? id,
    String? name,
    String? number,
    String? email,
    String? gender,
    String? address,
    String? website,
    String? image,
    String? dob,
    String? group,
    bool? favorite, // Keep this non-nullable
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      website: website ?? this.website,
      image: image ?? this.image,
      dob: dob ?? this.dob,
      group: group ?? this.group,
      favorite: favorite ?? this.favorite, // Ensure this is non-nullable
    );
  }
}