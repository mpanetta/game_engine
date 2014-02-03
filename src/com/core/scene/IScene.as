package com.core.scene
{
  import flash.events.IEventDispatcher;

  public interface IScene extends IEventDispatcher
  {
    function dispose():void;

    function get disposed():Boolean;
    function get starlingContainer():StarlingContainer;
    function get flashContainer():FlashContainer;

    function resize(w:Number, h:Number):void;
    function setScene():void;
  }
}