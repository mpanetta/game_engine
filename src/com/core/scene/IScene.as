package com.core.scene
{
  import flash.events.IEventDispatcher;
  import flash.geom.Rectangle;

  import starling.display.Sprite;

  public interface IScene extends IEventDispatcher
  {
    function dispose():void;

    function get disposed():Boolean;
    function get starlingView():Sprite;

    function resize(rectangle:Rectangle):void;
  }
}