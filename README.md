
Fast download manager allow download in multiple isolate, file is split to multiple segments and download each segment using different connections.

## Features

- [x] Support resume, pause, download
- [x] Support queue download
- [x] Download with multiple connections in multiple isolate with progress
- [x] Support notification
- [x] Support open file after download (only android and ios)

https://user-images.githubusercontent.com/59131542/197367709-2530eed9-4823-4890-9f36-9d0f3bc1575c.mp4

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

-only tested on android

-sometime your downloaded length will exceed the total length, it is not problem, this problem occurs if your file is small
