package com.core.scene
{
  import flash.events.IEventDispatcher;

  public interface IController extends IEventDispatcher
  {
    function dispose():void;

    function get disposed():Boolean;
    function get initialized():Boolean;
    function get className():String;

    function initialize(opts:Object):void;
  }
}