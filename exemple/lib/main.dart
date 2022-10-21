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
  await EasyDownloader.init();
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

  var controller = DownloadController();

  @override
  Widget build(BuildContext context) {

    var tasks = EasyDownloader.tasks;
    // print("tasks: ${tasks.length}");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                  child: LinearProgressIndicator(
                    value: progress,
                  ),
                ),
                MaterialButton(onPressed: () async {
                  var path = "${(await getApplicationDocumentsDirectory()).path}/test";
                  //var url = "https://speed.hetzner.de/100MB.bin";
                  //var url = "https://github.com/linkkader/zanime/releases/download/36/zanime.ipa";
                  //10mb
                  //var url = "http://hgd-speedtest-1.tele2.net/10MB.zip";
                  var url = "http://speedtest.ftp.otenet.gr/files/test10Mb.db";
                  //100mb
                  //var url = "http://hgd-speedtest-1.tele2.net/100MB.zip";
                  //1mb
                  //var url = "http://speedtest.ftp.otenet.gr/files/test1Mb.db";
                  //2mb
                  //var url = "http://hgd-speedtest-1.tele2.net/2MB.zip";
                  //var url = "http://speedtest.ftp.otenet.gr/files/test10Mb.db";
                  // var id =  await EasyDownloader().download(url, path, "kader", monitor: DownloadMonitor(
                  //     onProgress: (downloaded, total, speed, status) {
                  //       print("downloaded $status : ${downloaded.toHumanReadableSize()} total: ${total.toHumanReadableSize()} speed: ${speed.toHumanReadableSize()}/s");
                  //       progress = downloaded / total;
                  //       setState(() {});
                  //     },
                  //     blockMonitor: (blocks) {
                  //       blocks.sort((a, b) => a.start.compareTo(b.start));
                  //       for (var block in blocks) {
                  //         print("block ${block.id} ${block.status}: ${block.downloaded.toHumanReadableSize()} start: ${block.start.toHumanReadableSize()} end: ${block.end.toHumanReadableSize()}");
                  //       }
                  //     },
                  //     duration: const Duration(seconds: 2)),);
                  // controller = EasyDownloader.getController(id)!;
                  // print("id: $id");

                  var task = await EasyDownloader.task(url, path, "kader");
                  task.start(monitor: DownloadMonitor(
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
                      duration: const Duration(seconds: 2)));

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
            SizedBox(
              height: 400,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    var task = tasks[index];
                    var str = "";
                    try{
                      str = task.blocks.map((e) => e.downloaded).reduce((value, element) => value + element).toHumanReadableSize();
                    }catch(_){
                      print("error ${_} ${task.blocks.length}");
                    }
                    return SizedBox(
                      child: Column(
                        children: [
                          Text("${task.downloadId} task"
                              " ${task.status} ${task.totalLength.toHumanReadableSize()} "
                              "$str /s"),
                        ],
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: MaterialButton(
              onPressed: () async {
                var url = "http://speedtest.ftp.otenet.gr/files/test10Mb.db";
                var name = "test10MB3";
                var path = (await getApplicationDocumentsDirectory()).path;
                var id = await EasyDownloader().download(url, path, name);
                ids.add(id);
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
                        child: LinearProgressIndicator(value: task.downloaded / task.totalLength),
                      ),
                      Row(
                        children: [
                          TextButton(onPressed: (){
                            controller?.pause();
                          }, child: const Text("Pause")),
                          TextButton(onPressed: (){
                            controller?.resume();
                          }, child: const Text("Resume")),
                          TextButton(onPressed: (){
                            print(task.status);
                            print("downloaded: ${task.downloaded.toHumanReadableSize()} total: ${task.totalLength.toHumanReadableSize()}");
                          }, child: const Text("info")),
                          TextButton(onPressed: () async{
                            var file = File("${task.path}/${task.filename}");
                            var checksum = sha1.convert(await file.readAsBytes());
                            print(checksum);
                          }, child: const Text("Checksum")),
                        ],
                      ),
                    ],
                  ),
                );
              });
            },))
        ],
      ),
    );
  }

  @override
  void initState() {
    // for (var element in EasyDownloader.tasks) {
    //   ids.add(element.downloadId);
    // }
    super.initState();
  }

}
