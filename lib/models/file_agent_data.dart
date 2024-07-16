class FileAgentData {
  final String fileName;
  final String mimeType;
  final String url;

  FileAgentData(this.fileName, this.mimeType, this.url);

  FileAgentData.fromJson(Map<String, dynamic> json):
      fileName = json["filename"],
  mimeType = json["mime_type"],
  url= json["url"];
}