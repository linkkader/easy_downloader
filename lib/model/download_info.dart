// Created by linkkader on 15/10/2022

import 'dart:io';

class DownloadInfo {
  final String url;
  final String path;
  const DownloadInfo(this.url, this.path);

  //copy
  DownloadInfo copyWith({String? url, String? path, HttpClient? client}) => DownloadInfo(
    url ?? this.url,
    path ?? this.path,
  );
}
