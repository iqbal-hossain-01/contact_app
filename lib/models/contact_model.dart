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
    this.group,
    this.favorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'number': number,
      'email': email,
      'gender': gender,
      'dob': dob,
      'contact_group': group,
      'address': address,
      'website': website,
      'image': image,
      'favorite': favorite ? 1 : 0,
    };
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
      favorite: map['favorite'] == 0 ? false : true,
    );
  }
}