// Created by linkkader on 15/10/2022

import 'dart:io';

class DownloadInfo {
  final String url;
  final String path;
  final Map<String, String> headers;
  const DownloadInfo(this.url, this.path, this.headers);

  //copy
  DownloadInfo copyWith({String? url, String? path, Map<String, String>? headers}) => DownloadInfo(
    url ?? this.url,
    path ?? this.path,
    headers ?? this.headers,
  );
}
