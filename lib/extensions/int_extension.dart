// Created by linkkader on 7/10/2022

extension IntExtension on int{

  String toHumanReadableSize(){
    if(this < 1024){
      return "$this B";
    }else if(this < 1024*1024){
      return "${(this/1024).toStringAsFixed(2)} KB";
    }else if(this < 1024*1024*1024){
      return "${(this/(1024*1024)).toStringAsFixed(2)} MB";
    }else{
      return "${(this/(1024*1024*1024)).toStringAsFixed(2)} GB";
    }
  }

  List<int> toList(){
    return List.generate(this, (index) => index);
  }

  //in seconds
  Future sleep() async {
    await Future.delayed(Duration(seconds: this));
  }

}