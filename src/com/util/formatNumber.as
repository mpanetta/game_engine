package com.util {
  public function formatNumber(num:Number, precision:int=0, comma:Boolean=true):String {
    if(isNaN(num))
      throw new Error("Cannot format NaN values");

    num = Math.round(num * 100) / 100;
    var numString:String = String(num);
    var numArray:Array = numString.split(".");
    var padding:int = numArray[1] == undefined ? precision : precision - numArray[1].length;

    if(numArray[1] == undefined)
      numArray[1] = "";

    if(padding < 0) {
      numArray[1] = numArray[1].slice(0, -padding - 1);
    } else {
      var decimal:String = "";
      for(var i:int = 0; i < padding; i++)
        decimal += "0";

      numArray[1] += decimal;
    }

    if(comma) {
      var wholeArray:Array = new Array();
      var start:Number;
      var end:Number = numArray[0].length;

      while (end > 0) {
        start = Math.max(end - 3, 0);
        wholeArray.unshift(numArray[0].slice(start, end));
        end = start;
      }

      numArray[0] = wholeArray.join(",");
    }

    return numArray[1].length > 0 ? (numArray.join(".")) : numArray[0];
  }
}