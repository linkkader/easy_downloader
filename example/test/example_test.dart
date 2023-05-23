@Timeout(Duration(days: 1))

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';
import '../lib/pair.dart';

Future<void> main() async {
  List<Pair<String, String>> all = [
    // Pair("https://r4---sn-h5qzen76.gvt1.com/edgedl/android/studio/install/2022.1.1.20/android-studio-2022.1.1.20-mac_arm.dmg?mh=kN&pl=20&shardbypass=sd&redirect_counter=1&cm2rm=sn-hxqpuxa-jhoz7d&req_id=188f5c880b76f24a&cms_redirect=yes&ipbypass=yes&mip=197.230.240.146&mm=42&mn=sn-h5qzen76&ms=onc&mt=1676830367&mv=m&mvi=4&rmhost=r1---sn-h5qzen76.gvt1.com&smhost=r3---sn-h5qzen7s.gvt1.com", "ebb8e842eda3d500adf1aece9eb5b9d9b5963016d0233b42ed12107b2cc952a9"),
    // Pair("https://redirector.gvt1.com/edgedl/android/studio/install/2022.1.1.20/android-studio-2022.1.1.20-mac.dmg", "b7ee174891a5d72bf02e026455d992228446b80566dae7cafe1cdc9437a67e0e"),
    Pair(
        "https://dl.google.com/android/repository/commandlinetools-win-9477386_latest.zip",
        "696431978daadd33a28841320659835ba8db8080a535b8f35e9e60701ab8b491"),
    // Pair("https://www.learningcontainer.com/wp-content/uploads/2020/05/sample-mp4-file.mp4", "75c5cab9c98416569e72f3373144c131225bd63700f06f15491f392a2d08587c"),
    Pair("https://speed.hetzner.de/100MB.bin",
        "20492a4d0d84f8beb1767f6616229f85d44c2827b64bdbfb260ee12fa1109e0e"),
    Pair(
        "https://github.com/linkkader/zanime/releases/download/41/zanime_41.ipa",
        "b65ec3bc25351d34ef265d6c70399f320170407870645313726f17d8b99173c9"),
  ];
  var easyDownloader = await EasyDownloader().init();

  for (var element in all) {
    print(all);
    test(element.first, () async {
      var completer = Completer();
      Stopwatch stopwatch = Stopwatch()..start();
      var task = await easyDownloader.download(
        url: element.first,
        path: "download",
        autoStart: false,
        maxSplit: 8,
        // speedListener: (speed) {
        //   print("speed: ${speed.toHumanReadableSize()}}");
        // },
      );
      task.addListener((task) async {
        if (completer.isCompleted) {
          return;
        }

        print(
            "status: ${task.status} ${task.totalDownloaded.toHumanReadableSize()} / ${task.totalLength.toHumanReadableSize()}");
        if (completer.isCompleted == false) {
          var l = 100 + Random().nextInt(100);
          await l.sleep();
          if (completer.isCompleted == false) {
            completer.complete(element.second);
          }
        }
        switch (task.status) {
          case DownloadStatus.completed:
            print(
                "completed in ${Duration(milliseconds: stopwatch.elapsedMilliseconds).inSeconds} seconds");
            var file = File(task.outputFilePath);
            var checksum = sha256.convert(file.readAsBytesSync());
            completer.complete(checksum.toString());
            break;
          default:
        }
      });
      task.start();
      expect(element.second, await completer.future);
    });
  }
}
