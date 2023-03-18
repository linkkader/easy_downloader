import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader_flutter_lib/easy_downloader_flutter_lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'main.dart';

class MultiTasksDownloadRunner extends StatefulWidget {
  const MultiTasksDownloadRunner({Key? key}) : super(key: key);

  @override
  State<MultiTasksDownloadRunner> createState() => _MultiTasksDownloadState();
}

class _MultiTasksDownloadState extends State<MultiTasksDownloadRunner> {

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
                var i = 0;
                while(i < 10){
                  var url = "http://212.183.159.230/10MB.zip";
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
                  tasks[task.downloadId] = task;
                  task.addInQueue();
                  i++;
                }
                setState(() {

                });

              },
              child: const Text('Download'),
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
        ],
      ),
    );
  }
}
