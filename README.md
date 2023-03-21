
Fast download manager allow download in multiple isolate, file is split to multiple segments and download each segment using different connections.

## Features

- [x] Support resume, pause, download
- [x] Support queue download
- [x] Download with multiple connections in multiple isolate with progress
- [x] Support notification
- [x] Support open file after download (only android and ios)

![easy_dowloader](https://user-images.githubusercontent.com/59131542/197368097-398313ef-1d2c-40bd-84c3-dfc846dedc01.gif)

## Getting started

add easy_downloader into your pubspec.yaml.
```yaml
dependencies:
  easy_downloader: ^0.0.16
```
activate easy_downloader
```yaml
dart pub global activate easy_downloader
```

## Usage

1. Initialize the plugin
#### Flutter
add [easy_downloader_flutter_lib](https://pub.dev/packages/easy_downloader_flutter_lib) into your pubspec.yaml.
```dart
await EasyDownloader().initFlutter(
      allowNotification: true,
      //notification icon present in android/res/drawable
      defaultIconAndroid: 'download',
  );
```

#### Dart
```dart
  EasyDownloader().init();
```

2. Create new task

```dart
var url = "https://github.com/linkkader/zanime/releases/download/39/zanime_39.apk";
var name = "test10MB$i";
var path = (await getApplicationDocumentsDirectory()).path;
var task = await downloader.download(
  url: url,
  autoStart: false,
  path: path,
  maxSplit: 1,
  fileName: "${name}easyDownloader",
);
task.addListener((task) {
  //listen all task update
  setState(() {
    
    });
});
task.addSpeedListener((length) {
  //listen speed
  speedTask[task.downloadId] = length;
  setState(() {
  
  });
});
///show notification if you want(only tested on android)
task.showNotification();
```

## Additional information

- only tested on android, ios, macos

- sometime your downloaded length will exceed the total length, it is not problem, this problem occurs if your file is small

## License
    Copyright (c) 2021 linkkader

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

