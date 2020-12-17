class SketchfabDownloadResponse {
  Gltf gltf;
  Gltf usdz;

  SketchfabDownloadResponse({this.gltf, this.usdz});

  SketchfabDownloadResponse.fromJson(Map<String, dynamic> json) {
    gltf = json['gltf'] != null ? new Gltf.fromJson(json['gltf']) : null;
    usdz = json['usdz'] != null ? new Gltf.fromJson(json['usdz']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.gltf != null) {
      data['gltf'] = this.gltf.toJson();
    }
    if (this.usdz != null) {
      data['usdz'] = this.usdz.toJson();
    }
    return data;
  }
}

class Gltf {
  String url;
  int size;
  int expires;

  Gltf({this.url, this.size, this.expires});

  Gltf.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    size = json['size'];
    expires = json['expires'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['size'] = this.size;
    data['expires'] = this.expires;
    return data;
  }
}
