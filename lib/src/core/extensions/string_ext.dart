// Created by linkkader on 9/9/2022

extension StringExtension on String {

  ///generate by chatgpt
  ///generate file name from url
  String fileNameFromUrl() {
    return _generateFileNameFromUrl(this);
  }

  String _generateFileNameFromUrl(String url) {
    final uri = Uri.parse(url);
    var fileName = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : uri.path;

    // Remove any query string or fragment identifier from the file name
    final queryIndex = fileName.indexOf('?');
    final fragmentIndex = fileName.indexOf('#');
    if (queryIndex != -1) {
      fileName = fileName.substring(0, queryIndex);
    }
    if (fragmentIndex != -1) {
      fileName = fileName.substring(0, fragmentIndex);
    }

    // If the file name is empty, use a default value
    if (fileName.isEmpty) {
      fileName = 'file';
    }

    // If the file name ends with a slash, use a default value
    if (fileName.endsWith('/')) {
      fileName = 'file';
    }

    // If the file name has an extension, use it as is
    final extensionIndex = fileName.lastIndexOf('.');
    if (extensionIndex != -1) {
      return fileName;
    }

    // Otherwise, add a default extension based on the content type
    final contentType = uri.data?.contentAsString.toString().split(';').first;
    if (contentType != null) {
      final extension = _defaultExtensionForContentType(contentType);
      fileName = '$fileName.$extension';
    }
    return fileName;
  }

  String _defaultExtensionForContentType(String contentType) {
    switch (contentType) {
      case 'image/jpeg':
        return 'jpg';
      case 'image/png':
        return 'png';
      case 'image/gif':
        return 'gif';
      case 'application/pdf':
        return 'pdf';
      default:
        return 'dat';
    }
  }


  String capitalize() {
    if (length > 1) {
      return '${this[0].toUpperCase()}${substring(1)}';
    } else {
      return toUpperCase();
    }
  }

  int toInt() => int.tryParse(this) ?? 0;


  //substring before
  String substringBefore(String str) {
    if (isEmpty) return "";
    if (str.isEmpty) return this;
    if (contains(str)) {
      return substring(0, indexOf(str));
    } else {
      return this;
    }
  }

  //substring after
  String substringAfter(String str) {
    if (isEmpty) return "";
    if (str.isEmpty) return this;
    if (contains(str)) {
      return substring(indexOf(str) + str.length);
    } else {
      return this;
    }
  }

  //substring after last
  String substringAfterLast(String str) {
    if (isEmpty) return '';
    if (str.isEmpty) return this;
    if (contains(str)) {
      return substring(lastIndexOf(str) + str.length);
    } else {
      return this;
    }
  }

  //valid url
  bool isValidUrl() {
    try {
      Uri.parse(this);
      return true;
    } catch (e) {
      return false;
    }
  }
}
