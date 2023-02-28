import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:cli_completion/cli_completion.dart';
import 'package:easy_downloader/easy_downloader.dart';
import 'package:easy_downloader/src/commands/commands.dart';
import 'package:easy_downloader/src/core/extensions/duration_ext.dart';
import 'package:easy_downloader/src/core/extensions/string_ext.dart';
import 'package:easy_downloader/src/data/locale_storage/storage_model/download_task.dart';
import 'package:easy_downloader/src/version.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:pub_updater/pub_updater.dart';

const executableName = 'easy_downloader';
const packageName = 'easy_downloader';
const description = 'A Very Good Project created by Very Good CLI.';

/// {@template easy_downloader_command_runner}
/// A [CommandRunner] for the CLI.
///
/// ```
/// $ easy_downloader --version
/// ```
/// {@endtemplate}
class EasyDownloaderCommandRunner extends CompletionCommandRunner<int> {
  /// {@macro easy_downloader_command_runner}
  EasyDownloaderCommandRunner({
    Logger? logger,
    PubUpdater? pubUpdater,
  })  : _logger = logger ?? Logger(),
        _pubUpdater = pubUpdater ?? PubUpdater(),
        super(executableName, description) {
    // Add root options and flags
    argParser
      ..addFlag(
        'version',
        abbr: 'v',
        negatable: false,
        help: 'Print the current version.',
      )..addOption(
        'name',
        abbr: 'n',
        valueHelp: 'file',
        help: 'file output name',
      )..addOption(
        'dir',
        abbr: 'd',
        valueHelp: 'dir',
        callback: (value) {
          if (value != null){
            final dir = Directory(value);
            if (!dir.existsSync()) {
              dir.createSync(recursive: true);
            }
          }
        },
        help: 'file output dir',
      )..addOption(
        'split',
        abbr: 's',
        valueHelp: '1',
        callback: (value) {
          if (value != null){
            final split = int.tryParse(value);
            if (split == null || split < 1) {
              throw const FormatException('Invalid split');
            }
          }
        },
        help: 'max block split',
      )
      ..addFlag(
        'verbose',
        help: 'Noisy logging, including all shell commands executed.',
      );
    // ..addOption(
    //   'url',
    //   abbr: 'u',
    //   allowed: ['http', 'https'],
    //   aliases: ['u'],
    //   callback: (value) {
    //     if (value?.isValidUrl() != true) {
    //       throw const FormatException('Invalid url');
    //     }
    //   },
    //   help: 'download url',
    // );
    // Add sub commands
    addCommand(SampleCommand(logger: _logger));
    addCommand(UpdateCommand(logger: _logger, pubUpdater: _pubUpdater));
  }

  @override
  void printUsage() => _logger.info(usage);

  final Logger _logger;
  final PubUpdater _pubUpdater;


  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final topLevelResults = parse(args);
      if (topLevelResults['verbose'] == true) {
        _logger.level = Level.verbose;
      }
      return await runCommand(topLevelResults) ?? ExitCode.success.code;
    } on FormatException catch (e, stackTrace) {
      // On format errors, show the commands error message, root usage and
      // exit with an error code
      _logger
        ..err(e.message)
        ..err('$stackTrace')
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on UsageException catch (e) {
      // On usage errors, show the commands usage message and
      // exit with an error code
      _logger
        ..err(e.message)
        ..info('')
        ..info(e.usage);
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    // Fast track completion command
    if (topLevelResults.command?.name == 'completion') {
      await super.runCommand(topLevelResults);
      return ExitCode.success.code;
    }

    // Verbose logs
    _logger
      ..detail('Argument information:')
      ..detail('  Top level options:');
    for (final option in topLevelResults.options) {
      if (topLevelResults.wasParsed(option)) {
        _logger.detail('  - $option: ${topLevelResults[option]}');
      }
    }
    if (topLevelResults.command != null) {
      final commandResult = topLevelResults.command!;
      _logger
        ..detail('  Command: ${commandResult.name}')
        ..detail('    Command options:');
      for (final option in commandResult.options) {
        if (commandResult.wasParsed(option)) {
          _logger.detail('    - $option: ${commandResult[option]}');
        }
      }
    }

    // Run the command or show version
    final int? exitCode;
    // _logger.info('easy_downloader version: ${topLevelResults['split']} ${topLevelResults.options}');
    // exit(22);
    if (topLevelResults.rest.isNotEmpty) {
      if (topLevelResults.rest.length == 1
          && topLevelResults.rest[0].isValidUrl()) {
        final easyDownloader = await EasyDownloader().init();
        final completer = Completer<int>();
        final stopwatch = Stopwatch()..start();
        DownloadTask? task;
        DownloadTask? oldTask;
        // _logger.info('%\ttotal\t\tReceived\t\tTime spent\r');
        final timer = Timer.periodic(const Duration(seconds: 1), (_) {
          if (task == null) {
            return;
          }
          final speed = (task!.totalDownloaded
              - (oldTask?.totalDownloaded ?? 0))
              .toHumanReadableSize().replaceAll(' ', '');
          final duration = Duration(
            milliseconds: stopwatch.elapsedMilliseconds,
          );
          switch(task!.status){
            case DownloadStatus.downloading:
              stdout.write('33[2K\r');
              //ignore: lines_longer_than_80_chars
              stdout.write('${task!.totalDownloaded * 100~/task!.totalLength}%\t${task!.totalDownloaded.toHumanReadableSize().replaceAll(" ", "")}/${task!.totalLength.toHumanReadableSize().replaceAll(" ", "")}\t${duration.toHumanReadable()} \t$speed/s');
              break;
            case DownloadStatus.paused:
              break;
            case DownloadStatus.completed:
              completer.complete(ExitCode.success.code);
              _logger.info('\ncompleted output path: ${task!.outputFilePath}');
              break;
            case DownloadStatus.failed:
              completer.complete(ExitCode.ioError.code);
              _logger.err('failed');
              break;
            case DownloadStatus.appending:
              break;
            case DownloadStatus.queuing:
              break;
          }
          oldTask = task;
        },);
        task = await easyDownloader.download(
          url: topLevelResults.rest[0],
          autoStart: false,
          maxSplit: int.tryParse(topLevelResults['split'].toString(),),
          fileName: topLevelResults['name']?.toString(),
          path: topLevelResults['dir']?.toString(),
          listener: (DownloadTask downloadTask) {
            task = downloadTask;
          },
        );
        final file = File(task!.outputFilePath);
        if (file.existsSync()) {
          file.deleteSync();
        }
        task!.start();
        exitCode = await completer.future;
      }
      else{
        exitCode = ExitCode.ioError.code;
      }
    }
    else if (topLevelResults['version'] == true) {
      _logger.info(packageVersion);
      exitCode = ExitCode.success.code;
    } else {
      exitCode = await super.runCommand(topLevelResults);
    }

    // Check for updates
    if (topLevelResults.command?.name != UpdateCommand.commandName) {
      await _checkForUpdates();
    }

    return exitCode;
  }

  /// Checks if the current version (set by the build runner on the
  /// version.dart file) is the most recent one. If not, show a prompt to the
  /// user.
  Future<void> _checkForUpdates() async {
    try {
      final latestVersion = await _pubUpdater.getLatestVersion(packageName);
      final isUpToDate = packageVersion == latestVersion;
      if (!isUpToDate) {
        _logger
          ..info('')
          ..info(
            '''
${lightYellow.wrap('Update available!')} ${lightCyan.wrap(packageVersion)} \u2192 ${lightCyan.wrap(latestVersion)}
Run ${lightCyan.wrap('$executableName update')} to update''',
          );
      }
    } catch (_) {}
  }
}
