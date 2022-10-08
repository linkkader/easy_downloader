// Created by linkkader on 7/10/2022

enum DownloadStatus { downloading, paused, completed, failed }

enum PartFileStatus { downloading, completed, failed }

enum SendPortStatus { setDownload, updatePartDownloaded, updatePartStatus, updatePartEnd, setPart, incrementCurrent}