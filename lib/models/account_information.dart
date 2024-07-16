import 'package:flutter_ec_0711/models/file_agent_data.dart';

class AccountInformation {
  final String email;
  final String name;
  final FileAgentData? avatar;
  final String roleType;

  AccountInformation(this.email, this.name, this.avatar, this.roleType);

  AccountInformation.fromJson(Map<String, dynamic> json):
      email = json["email"],
  name = json["name"],
  avatar = json["avatar"] == null ? null : FileAgentData.fromJson(json["avatar"]),
  roleType = json["role_type"];
}