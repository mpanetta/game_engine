package com.util {
  public function methodForEvent(type:String):String {
    var lower:String = type.toLowerCase();
    var tokens:Array = lower.split(/_/);
    var first:String = tokens[0];

    return first + capitalize(tokens.slice(1).join("")).split(/ /).join("");
  }
}



