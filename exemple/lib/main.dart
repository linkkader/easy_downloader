import 'dart:io';

import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/extensions/int_extension.dart';
import 'package:easy_downloader/monitor/download_monitor.dart';
import 'package:easy_downloader/notifications/notification.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
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

  double progress = 0.0;

  var controller = DownloadController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: LinearProgressIndicator(
              value: progress,
            ),
          ),
          MaterialButton(onPressed: () async {
            var path = "${(await getApplicationDocumentsDirectory()).path}/test";
            print(path);
            var url = "https://speed.hetzner.de/100MB.bin";
            EasyDownloader().download(url, path, monitor: DownloadMonitor(
                onProgress: (downloaded, total, speed, status) {
                  print("downloaded $status : ${downloaded.toHumanReadableSize()} total: ${total.toHumanReadableSize()} speed: ${speed.toHumanReadableSize()}/s");
                  progress = downloaded / total;
                  setState(() {});
              },
              blockMonitor: (blocks) {
                  blocks.sort((a, b) => a.start.compareTo(b.start));
                  for (var block in blocks) {
                    print("block ${block.id} ${block.status}: ${block.downloaded.toHumanReadableSize()} start: ${block.start.toHumanReadableSize()} end: ${block.end.toHumanReadableSize()}");
                  }
              },
                duration: const Duration(seconds: 10)),
                downloadController: controller,
            );
          }, child: const Text("Download")),
          MaterialButton(onPressed: () async {
            controller.pause();
          }, child: const Text("Pause")),
          MaterialButton(onPressed: () async {
            controller.resume();
          }, child: const Text("resume")),
          MaterialButton(onPressed: () async {
            var path = Directory("${(await getApplicationDocumentsDirectory()).path}/test");
            var lst = path.listSync();
            for (var item in lst) {
              var file = File(item.path);
              print("${item.path} ${path.statSync().size.toHumanReadableSize()} ${file.lengthSync().toHumanReadableSize()}");
            }
          }, child: const Text("Test")),
        ],
      ),
    );
  }

  @override
  void initState() {
    EasyDownloadNotification.init();

    super.initState();
  }

}
