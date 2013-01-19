package com.core.dataStructures
{
  import flash.utils.Dictionary;

  public dynamic class Hash extends Dictionary
  {
    public function Hash(obj:Object=null, weakKeys:Boolean=false):void
    {
      super(weakKeys);

      if(obj)
      {
        for(var key:String in obj)
          this[key] = obj[key];
      }
    }

    public function get length():int { return keys.length; }
    public function get isEmpty():Boolean { return length == 0; }

    public function get keys():Array
    {
      var keys:Array = [];

      for(var key:Object in this)
        keys.push(key);

      return keys;
    }

    public function get values():Array
    {
      var values:Array = [];

      for each(var value:Object in this)
      values.push(value);

      return values;
    }

    public function random():Object
    {
      return ArrayHelper.random(values);
    }

    public function clear():void
    {
      for each(var key:Object in keys)
      delete this[key];
    }
  }
}