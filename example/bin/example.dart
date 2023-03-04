import 'dart:io';
import 'package:easy_downloader/easy_downloader.dart';

//http://xcal1.vodafone.co.uk/
void main() async {

  var file = File("test.mp4");
  if (file.existsSync()) {
    file.deleteSync();
  }
  var easyDownloader = await EasyDownloader().init();
  var dir = Directory("download");
  if (dir.existsSync()){
    dir.deleteSync(recursive: true);
  }
  // print(await easyDownloader.allDownloadTasks());
  // return;
  easyDownloader.download(
    url:
    // "https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4",//bfe8feaec39f112dfcc53bbc98a1c17309e0f941
    // "https://speed.hetzner.de/100MB.bin",//2c2ceccb5ec5574f791d45b63c940cff20550f9a
    // "https://github.com/linkkader/zanime/releases/download/41/zanime_41.ipa",//93403755b94787dcfabc6cb24704fcfe7912a3cd
    "http://212.183.159.230/10MB.zip",//f3b8eebe058415b752bec735652a30104fe666ba
    path: "download/download",
    // fileName: "zanime_41.ipa",
    maxSplit: 10,
    // listener: (task) async {
    //   switch (task.status) {
    //     case DownloadStatus.completed:
    //       var file = File(task.outputFilePath);
    //       var checksum = sha1.convert(await file.readAsBytes());
    //       print("completed ${checksum.toString()}");
    //       break;
    //     default:
    //       // TODO: Handle this case.
    //       break;
    //   }
    // },
  );
}
