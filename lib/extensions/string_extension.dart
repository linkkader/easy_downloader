// Created by linkkader on 7/10/2022

extension StringExtension on String {

  String nextSplit() {
    return ("$this.1.0");
  }

  int toInt(){
    return int.parse(this);
  }

  String nextPart() {
    var before = substringBeforeLast(".");
    var after = substringAfterLast(".").toInt();
    after++;
    return ("$before.$after");
  }

  String substringBefore(String before){
    if(contains(before)){
      var startIndex = indexOf(before);
      return substring(0,startIndex);
    }
    return this;
  }

  String substringBeforeLast(String before){
    var s = "";
    var element = split(before);
    for(int i = 0 ; i < (element.length-1) ; i++){
      if(i == element.length - 2){
        s += element.elementAt(i);
        break;
      }
      s += element.elementAt(i) + before ;
    }
    return s;
  }
  String substringAfterLast(String after){
    return split(after).last;
  }
  String substringAfter(String after){
    if(contains(after)){
      var endIndex = indexOf(after);
      return substring(endIndex + after.length,length);
    }
    return this;
  }

}