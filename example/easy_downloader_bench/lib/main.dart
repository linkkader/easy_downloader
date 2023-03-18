import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:crypto/crypto.dart';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/easy_downloader.dart' as easy;
import 'package:easy_downloader_bench/multi_task_download.dart';
import 'package:easy_downloader_bench/multi_task_download_runner.dart';
import 'package:easy_downloader_flutter_lib/easy_downloader_flutter_lib.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart' as FlutterDownloader;
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyDownloader().initFlutter(
      allowNotification: true,
      defaultIconAndroid: 'download'
  );
  if (Platform.isAndroid || Platform.isIOS) {
    await FlutterDownloader.FlutterDownloader.initialize(
        debug: true, // optional: set to false to disable printing logs to console (default: true)
        ignoreSsl: true // option: set to false to disable working with http links (default: false)
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Tuple {
  final int id;
  final int progress;
  FlutterDownloader.DownloadTaskStatus status;

  Tuple(this.id, this.progress, this.status);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  EasyDownloader downloader = EasyDownloader();

  Map<int, DownloadTask> tasks = {};
  Map<int, int> speedTask = {};
  Map<int, Tuple> flutterTasks = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: MaterialButton(
              onPressed: () async {
                // const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('download');
                // const InitializationSettings initializationSettings = InitializationSettings(
                //     android: initializationSettingsAndroid,
                // );
                // var notificationPlugin = FlutterLocalNotificationsPlugin();
                // await notificationPlugin.initialize(initializationSettings);
                // notificationPlugin.show(
                //     0,
                //     'test',
                //     'test',
                //     const NotificationDetails(
                //         android: AndroidNotificationDetails(
                //             'test',
                //             'test',
                //             importance: Importance.max,
                //             priority: Priority.high,
                //             showProgress: true,
                //             progress: 0,
                //             maxProgress: 100,
                //             onlyAlertOnce: true,
                //             playSound: false,
                //             enableVibration: false,
                //             visibility: NotificationVisibility.public,
                //         ),
                //     ),
                // );
                var i = 0;
                while(i < 2){
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
                    tasks[task.downloadId] = task;
                    setState(() {

                    });
                  });
                  task.addSpeedListener((length) {
                    speedTask[task.downloadId] = length;
                    setState(() {

                    });
                  });
                  task.showNotification();
                  // final taskId = await FlutterDownloader.FlutterDownloader.enqueue(
                  //   url: url,
                  //   savedDir: path,
                  //   showNotification: true, // show download progress in status bar (for Android)
                  //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
                  //   fileName: "${name}flutterDownloader",
                  // );
                  // flutterTasks[int.parse(taskId!)] = Tuple(int.parse(taskId), 0, FlutterDownloader.DownloadTaskStatus.undefined);
                  tasks[task.downloadId] = task;
                  i++;
                  break;
                }
                setState(() {

                });

              },
              child: const Text('Download'),
            ),
          ),
          SizedBox(
            height: 100,
            child: MaterialButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MultiTasksDownload(),));
              },
              child: const Text('MultiTasksDownload'),
            ),
          ),
          SizedBox(
            height: 100,
            child: MaterialButton(
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) =>  const MultiTasksDownloadRunner(),));
              },
              child: const Text('MultiTasksDownloadRunner'),
            ),
          ),
          Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  var key = tasks.keys.elementAt(index);
                  var task = tasks[key]!;
                  return SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              Expanded(child: LinearProgressIndicator(value: task.totalDownloaded / (task.totalLength == 0 ? 1 : task.totalLength))),
                              Text("${task.totalDownloaded.toHumanReadableSize()} / ${task.totalLength.toHumanReadableSize()} ${speedTask[task.downloadId]?.toHumanReadableSize().replaceAll(" ", "")}/s ${task.status.name}"),
                            ],
                          ),
                        ),
                        FittedBox(
                            child: Row(
                              children: [
                                TextButton(onPressed: (){
                                  task.start();
                                }, child: const Text("Start")),
                                TextButton(onPressed: (){
                                  task.pause();
                                }, child: const Text("Pause")),
                                TextButton(onPressed: (){
                                  task.continueDownload();
                                }, child: const Text("Resume")),
                                TextButton(onPressed: () async {
                                  print(await task.update());
                                }, child: const Text("info")),
                                TextButton(onPressed: () async{
                                  var file = File(task.outputFilePath);
                                  print(file.lengthSync());
                                  var checksum = sha1.convert(await file.readAsBytes());
                                  print(checksum.toString());
                                }, child: const Text("Checksum")),
                                TextButton(onPressed: () async{
                                  // await EasyDownloader.delete(ids.removeAt(index), deleteFile: true);
                                  // setState(() {});
                                }, child: const Text("delete")),
                                TextButton(onPressed: () async{
                                  // EasyDownloader.openFile(task.downloadId);
                                }, child: const Text("open")),
                              ],
                            )
                        ),
                      ],
                    ),
                  );
                },
              )
          ),
          Expanded(
              child: ListView.builder(
                itemCount: flutterTasks.length,
                itemBuilder: (context, index) {
                  var key = flutterTasks.keys.elementAt(index);
                  var task = flutterTasks[key]!;
                  return SizedBox(
                    height: 200,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              Expanded(child: LinearProgressIndicator(value: task.progress / 100)),
                              // ${speed[task.downloadId]?.toHumanReadableSize()}/s
                              Text("${task.status.toString()} "),
                            ],
                          ),
                        ),
                        FittedBox(
                            child: Row(
                              children: [
                                TextButton(onPressed: (){
                                  // task.start();
                                }, child: const Text("Start")),
                                TextButton(onPressed: (){
                                  // task.pause();
                                }, child: const Text("Pause")),
                                TextButton(onPressed: (){
                                  // task.continueDownload();
                                }, child: const Text("Resume")),
                                TextButton(onPressed: (){

                                }, child: const Text("info")),
                                TextButton(onPressed: () async{
                                  // var file = File(task.outputFilePath);
                                  // var checksum = sha1.convert(await file.readAsBytes());
                                  // log(checksum.toString());
                                }, child: const Text("Checksum")),
                                TextButton(onPressed: () async{
                                  // await EasyDownloader.delete(ids.removeAt(index), deleteFile: true);
                                  // setState(() {});
                                }, child: const Text("delete")),
                                TextButton(onPressed: () async{
                                  // EasyDownloader.openFile(task.downloadId);
                                }, child: const Text("open")),
                              ],
                            )
                        ),
                      ],
                    ),
                  );
                },
              )
          ),
        ],
      ),
    );
  }

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      FlutterDownloader.DownloadTaskStatus status = data[1];
      int progress = data[2];

      flutterTasks[int.parse(id)] = Tuple(int.parse(id), progress, status);

      setState((){ });
    });

    if (Platform.isAndroid || Platform.isIOS) {
      FlutterDownloader.FlutterDownloader.registerCallback(downloadCallback);
    }
  }


}

@pragma('vm:entry-point')
void downloadCallback(String id, FlutterDownloader.DownloadTaskStatus status, int progress) {
  final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
  send?.send([id, status, progress]);
}