package com.util {
  public function capitalize(string:String):String {
    if(string == null || string == "") return string;

    var copy:String = string.replace(/_/, " ");
    var wordsArray:Array = copy.split(" ");

    for(var word:String in wordsArray)
      wordsArray[word] = String(wordsArray[word]).charAt(0).toUpperCase() + String(wordsArray[word]).substr(1, String(wordsArray[word]).length);

    return wordsArray.join(" ");
  }
}


