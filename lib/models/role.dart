import 'package:equatable/equatable.dart';

import '../common/utils/utils.dart';

class Role extends Equatable {
  const Role({this.id, this.type, this.name});

  final int? id;
  final String? type;
  final String? name;

  factory Role.fromJson(Map<String?, dynamic> json) => Role(
        id: parseInt(json['id']),
        type: json['type'],
        name: json['name'],
      );

  factory Role.fromLocal(Map<String?, dynamic> json) => Role.fromJson(json);

  Role copyWith({int? id, String? type, String? name}) {
    return Role(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "type": type,
      "name": name,
    };
  }

  @override
  List<Object?> get props => [id, type, name];
}
