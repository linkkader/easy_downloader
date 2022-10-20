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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: MaterialButton(
              onPressed: () async {
                var url = "";
                var name = "zanime";
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
            itemBuilder: (context, index) {
              return EasyDownloadTaskListenable(ids[index], (context, task) {
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
                          TextButton(onPressed: (){}, child: const Text("Pause")),
                          TextButton(onPressed: (){}, child: const Text("Resume")),
                          TextButton(onPressed: (){}, child: const Text("Append")),
                          TextButton(onPressed: (){}, child: const Text("Checksum")),
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
    for (var element in EasyDownloader.tasks) {
      ids.add(element.downloadId);
    }
    super.initState();
  }

}
