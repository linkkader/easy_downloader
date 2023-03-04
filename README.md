
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
  easy_downloader: ^0.0.1-dev.1
```

## Usage

1. Initialize the plugin

```dart
await EasyDownloader.init(startQueue: true, maxConcurrentTasks: 4);
```

2. Create new task

```dart
var url = "http://speedtest.ftp.otenet.gr/files/test10Mb.db";
var name = "test10MB";
var path = (await getApplicationDocumentsDirectory()).path;
var task = await EasyDownloader.newTask(url, path, name, maxSplit: 8, showNotification: true);    
```

3. add task in queue

```dart
//queue will automatically start
EasyDownloader.addTaskQueue(task.downloadId);
```

5. listen with speed/s and progress

```dart
var controller = EasyDownloader.getController(task.downloadId);
if (controller != null){
  
  controller.start(monitor: DownloadMonitor(
  
  duration: const Duration(milliseconds: 100),
  
  blockMonitor: (blocks){
  
      //listen all blocks
  
},
  onProgress: (downloaded, total, speed, status) {
      //listen progress

      //listen speed/second

      //listen status

      //listen status

  },

  ));
}
else{
  //no task found

}    
```

4. listen download directly in widget

```dart
    EasyDownloadTaskListenable(task.downloadId, (context, task, controller) {});
```

## Additional information

- only tested on android

- sometime your downloaded length will exceed the total length, it is not problem, this problem occurs if your file is small

## License
    Copyright (c) 2017 linkkader

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

