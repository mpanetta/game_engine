package com.core.dataStructures
{
  import flash.utils.Proxy;
  import flash.utils.flash_proxy;

  public class Set extends Proxy
  {
    private var _hash:Hash;
    private var _iterElements:Array = [];

    public function Set(array:Array=null, weakKeys:Boolean=false):void {
      _hash = new Hash(weakKeys);

      for each(var item:Object in array)
        add(item);
    }

    public function get length():int { return _hash.length; }
    public function get isEmpty():Boolean { return _hash.length == 0; }
    public function get values():Array { return _hash.keys; }

    public function add(object:Object):void {
      _hash[object] = true;
    }

    public function remove(object:Object):void {
      delete _hash[object];
    }

    public function clear():void {
      _hash = new Hash();
      _iterElements = [];
    }

    public function random():Object {
      return ArrayHelper.random(values);
    }

    public function contains(object:Object):Boolean {
      return !!_hash[object];
    }

    override flash_proxy function nextNameIndex(index:int):int {
      if(index == 0)
        _iterElements = values;

      return (index < _iterElements.length ? index+1 : 0);
    }

    override flash_proxy function nextName(index:int):String {
      return _iterElements[index-1].toString();
    }

    override flash_proxy function nextValue(index:int):* {
      return _iterElements[index-1];
    }
  }
}