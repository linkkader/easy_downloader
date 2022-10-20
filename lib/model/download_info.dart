// Created by linkkader on 15/10/2022

import 'dart:io';

class DownloadInfo {
  final String url;
  final String path;
  final Map<String, String> headers;
  final String filename;
  final String tempPath;
  const DownloadInfo(this.url, this.path, this.headers, this.filename, this.tempPath);

  //copy
  DownloadInfo copyWith({String? url, String? path, Map<String, String>? headers, String? filename, String? tempPath}) => DownloadInfo(
    url ?? this.url,
    path ?? this.path,
    headers ?? this.headers,
    filename ?? this.filename,
    tempPath ?? this.tempPath,
  );
}
