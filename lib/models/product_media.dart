import 'package:flutter_ec_0711/models/file_agent_data.dart';

class ProductMedia {
  final FileAgentData fileAgentData;
  final String description;
  final int orderNo;

  ProductMedia(this.fileAgentData, this.description, this.orderNo);

  ProductMedia.fromJson(Map<String, dynamic> json):
      fileAgentData = FileAgentData.fromJson(json["file_agent_data"]),
  description = json["description"],
  orderNo = json["order_no"];
}