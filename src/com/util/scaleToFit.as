package com.util {
  public function scaleToFit(object:*, cw:Number, ch:Number, pivotCenter:Boolean=false):void {
    var p:Number = ch / cw < object.height / object.width ? cw / object.width : ch / object.height;

    object.width *= p;
    object.height *= p;
    object.x = (cw - object.width) / 2 + (pivotCenter ? object.width / 2 : 0);
    object.y = (ch - object.height) / 2 + (pivotCenter ? object.height / 2 : 0);
  }
}
