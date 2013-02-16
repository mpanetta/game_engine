package com.util
{
  import starling.display.Stage;

  public function centerObject(object:*, params:Object=null):void {
    var container:* = (params && params.hasOwnProperty('container')) ? params.container : object.stage;
    var width:int = container is Stage ? container.stageWidth : container.width;
    var height:int = container is Stage ? container.stageHeight : container.height;

    object.x = (width - object.width) / 2;
    object.y = (height - object.height) / 2;

    if(!params) return;

    if(params.hasOwnProperty('vOffset')) object.y += params.vOffset;
    if(params.hasOwnProperty('hOffset')) object.x += params.hOffset;
  }
}