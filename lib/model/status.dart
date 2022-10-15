// Created by linkkader on 7/10/2022

enum DownloadStatus { downloading, paused, completed, failed }

enum PartFileStatus { downloading, completed, failed, paused}

enum SendPortStatus { setDownload, updateMainSendPort, updatePartDownloaded, pausePart, updatePartStatus, updatePartEnd, setPart, currentLength, }