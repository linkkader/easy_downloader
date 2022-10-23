import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/extensions/int_extension.dart';
import 'package:easy_downloader/monitor/download_monitor.dart';
import 'package:easy_downloader/widget/download_task_listenable.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyDownloader.init(startQueue: true, maxConcurrentTasks: 4);
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<int> ids = [];

  double progress = 0.0;
  Map<int, int> speed = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: MaterialButton(
              onPressed: () async {
                var i = 0;
                while(i < 2){
                  var url = "https://github.com/linkkader/zanime/releases/download/39/zanime_39.apk";
                  var name = "test10MB$i";
                  var path = (await getApplicationDocumentsDirectory()).path;
                  var task = await EasyDownloader.newTask(url, path, name, maxSplit: 4, showNotification: true);
                  ids.add(task.downloadId);
                  //EasyDownloader.addTaskQueue(task.downloadId);
                  var controller = EasyDownloader.getController(task.downloadId);
                  if (controller != null){
                    controller.start(monitor: DownloadMonitor(
                      duration: const Duration(milliseconds: 100),
                      blockMonitor: (blocks){
                        //listen all blocks
                      },
                      onProgress: (downloaded, total, speed, status) {
                        this.speed[task.downloadId] = speed;
                        log("downloaded: $downloaded, total: $total, speed: $speed, status: $status");
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
                  i++;
                  break;
                }
                setState(() {

                });

              },
              child: const Text('Download'),
            ),
          ),
          Expanded(child: ListView.builder(
            itemCount: ids.length,
            itemBuilder: (context, index) {
              return EasyDownloadTaskListenable(ids[index], (context, task, controller) {
                return SizedBox(
                  height: 200,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            Expanded(child: LinearProgressIndicator(value: task.downloaded / task.totalLength)),
                            Text("${task.downloaded.toHumanReadableSize()} / ${task.totalLength.toHumanReadableSize()}  ${speed[task.downloadId]?.toHumanReadableSize()}/s"),
                          ],
                        ),
                      ),
                      FittedBox(
                        child: Row(
                          children: [
                            TextButton(onPressed: (){
                              controller?.start();
                              controller?.addStatusListener((p0) {
                                log(p0.toString());
                              });
                            }, child: const Text("Start")),
                            TextButton(onPressed: (){
                              controller?.pause();
                            }, child: const Text("Pause")),
                            TextButton(onPressed: (){
                              log(task.url);
                              log(controller.toString());
                              controller?.resume();
                            }, child: const Text("Resume")),
                            TextButton(onPressed: (){
                              log(task.status.toString());
                              log(task.isInQueue.toString());
                              log(task.downloadId.toString());
                              log("downloaded: ${task.downloaded.toHumanReadableSize()} total: ${task.totalLength.toHumanReadableSize()}");
                              for (var element in task.blocks) {
                                var file = File("${task.tempPath}/${element.id}");
                                log("${element.id} ${element.status} ${element.downloaded.toHumanReadableSize()} ${file.lengthSync().toHumanReadableSize()}");
                              }
                            }, child: const Text("info")),
                            TextButton(onPressed: () async{
                              var file = File("${task.path}/${task.filename}");
                              var checksum = sha1.convert(await file.readAsBytes());
                              log(checksum.toString());
                            }, child: const Text("Checksum")),
                            TextButton(onPressed: () async{
                              await EasyDownloader.delete(ids.removeAt(index), deleteFile: true);
                              setState(() {});
                            }, child: const Text("delete")),
                            TextButton(onPressed: () async{
                              EasyDownloader.openFile(task.downloadId);
                              }, child: const Text("open")),
                          ],
                        )
                      ),
                    ],
                  ),
                );
              });
            },)
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    for (var element in EasyDownloader.tasks) {
      ids.add(element.downloadId);
    }
    super.initState();
  }

}
