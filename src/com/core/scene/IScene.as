package com.core.scene
{
  import flash.events.IEventDispatcher;

  import starling.display.Sprite;

  public interface IScene extends IEventDispatcher
  {
    function dispose():void;

    function get disposed():Boolean;
    function get starlingView():Sprite;

    function resize(w:Number, h:Number):void;
    function setScene():void;
  }
}