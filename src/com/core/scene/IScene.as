package com.core.scene
{
  import flash.events.IEventDispatcher;
  import flash.geom.Rectangle;

  public interface IScene extends IEventDispatcher
  {
    function dispose():void;

    function get disposed():Boolean;

    function initialize(data:Object):void;
    function load():void;

    function resize(rectangle:Rectangle):void;
  }
}