// Created by linkkader on 3/3/2023

/// SendPortStatus
/// updateBlock: update block
/// completeUpdateBlock: complete update block
/// download: download
/// pauseTask: pause task
/// pauseTaskSuccess: pause task success
/// blockLength: block length
/// blockFinished: block finished
/// continueTask: continue task
/// continueTaskSuccess: continue task success
/// updateTask: update task
/// completeUpdateTask: complete update task
/// updateMainIsolateSendPort: update main isolate send port
enum SendPortStatus {
  updateMainIsolateSendPort,
  updateTask,
  completeUpdateTask,
  updateBlock,
  completeUpdateBlock,
  download,
  pauseTask,
  pauseTaskSuccess,
  blockLength,
  blockFinished,
  continueTask,
  continueTaskSuccess,
}
