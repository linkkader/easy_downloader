'''dart
import 'dart:io';
import 'package:easy_downloader/easy_downloader.dart';

//http://xcal1.vodafone.co.uk/
void main() async {
var file = File("test.mp4");
if (file.existsSync()) {
file.deleteSync();
}
var easyDownloader = await EasyDownloader().init(clearLocaleStorage: true);
var dir = Directory("download");
if (dir.existsSync()) {
dir.deleteSync(recursive: true);
}
// print(await easyDownloader.allDownloadTasks());
// return;
var task = await easyDownloader.download(
url:
// "https://r4---sn-h5qzen76.gvt1.com/edgedl/android/studio/install/2022.1.1.20/android-studio-2022.1.1.20-mac_arm.dmg?mh=kN&pl=20&shardbypass=sd&redirect_counter=1&cm2rm=sn-hxqpuxa-jhoz7d&req_id=188f5c880b76f24a&cms_redirect=yes&ipbypass=yes&mip=197.230.240.146&mm=42&mn=sn-h5qzen76&ms=onc&mt=1676830367&mv=m&mvi=4&rmhost=r1---sn-h5qzen76.gvt1.com&smhost=r3---sn-h5qzen7s.gvt1.com",
"https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4", //bfe8feaec39f112dfcc53bbc98a1c17309e0f941
maxSplit: 10,
);
task.addListener((task) {
print(
"status: ${task.status} ${task.totalDownloaded.toHumanReadableSize()} / ${task.totalLength.toHumanReadableSize()}");
});

task.start();
}
```