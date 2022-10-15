// Created by linkkader on 15/10/2022

import 'dart:io';

class DownloadInfo {
  final String url;
  final String path;
  final HttpClient client;
  const DownloadInfo(this.url, this.path, this.client);

  //copy
  DownloadInfo copyWith({String? url, String? path, HttpClient? client}) => DownloadInfo(
    url ?? this.url,
    path ?? this.path,
    client ?? this.client,
  );
}
