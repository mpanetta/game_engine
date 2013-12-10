package com.core.scene
{
  import flash.events.IEventDispatcher;

  import starling.display.Sprite;

  public interface IScene extends IEventDispatcher
  {
    function dispose():void;

    function get disposed():Boolean;
    function get starlingView():Sprite;

    function get width():int;
    function get height():int;

    function resize(w:int, h:int):void;
    function setScene():void;
  }
}