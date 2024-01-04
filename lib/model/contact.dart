// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:uuid/uuid.dart';

class Contact {
  String? objectId;
  String? name;
  String? phone;
  String? email;
  String? urlavatar;
  String? idcontact;
  DateTime? createdAt;
  DateTime? updatedAt;

  Contact({
    String? idcontact,
    this.objectId,
    this.name,
    this.phone,
    this.email,
    this.urlavatar,
    this.createdAt,
    this.updatedAt,
  }) : idcontact = idcontact ?? const Uuid().v4();

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'objectId': objectId,
      'name': name,
      'phone': phone,
      'email': email,
      'urlavatar': urlavatar,
      'idcontact': idcontact,
    };
  }

  factory Contact.criar(
      {required String name,
      required String phone,
      required String email,
      required String urlavatar,
      required String idcontact}) {
    return Contact(
      objectId: null,
      name: name,
      phone: phone,
      email: email,
      urlavatar: urlavatar,
      idcontact: idcontact,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      objectId: map['objectId'] != null ? map['objectId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      phone: map['phone'] != null ? map['phone'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      urlavatar: map['urlavatar'] != null ? map['urlavatar'] as String : null,
      idcontact: map['idcontact'] != null ? map['idcontact'] as String : null,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt']) as DateTime
          : null,
      updatedAt: map['updatedAt'] != null
          ? DateTime.tryParse(map['updatedAt']) as DateTime
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Contact.fromJson(String source) =>
      Contact.fromMap(json.decode(source) as Map<String, dynamic>);

  Contact copyWith({
    String? objectId,
    String? name,
    String? phone,
    String? email,
    String? urlavatar,
    String? idcontact,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Contact(
      objectId: objectId ?? this.objectId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      urlavatar: urlavatar ?? this.urlavatar,
      idcontact: idcontact ?? this.idcontact,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'Contact(objectId: $objectId, name: $name, phone: $phone, email: $email, urlavatar: $urlavatar, idcontact: $idcontact, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Contact other) {
    if (identical(this, other)) return true;

    return other.objectId == objectId &&
        other.name == name &&
        other.phone == phone &&
        other.email == email &&
        other.urlavatar == urlavatar &&
        other.idcontact == idcontact &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return objectId.hashCode ^
        name.hashCode ^
        phone.hashCode ^
        email.hashCode ^
        urlavatar.hashCode ^
        idcontact.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
