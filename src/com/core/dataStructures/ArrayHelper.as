package com.core.dataStructures
{
  public class ArrayHelper
  {
    public static function random(array:Array):Object {
      if(array.length == 0) return null;

      return array[Math.floor(Math.random() * array.length)];
    }

    public static function sample(array:Array, n:int):Array {
      if(array.length == 0) return null;

      var sample:Array = [];

      var needed:int = n;
      var remaining:int = array.length;
      for each(var obj:Object in array) {
        var chance:Number = (needed / remaining);
        if(Math.random() <= chance) {
          sample.push(obj);
          needed -= 1;
        }

        remaining -= 1;
      }

      return sample;
    }

    public static function flatten(array:Array, levels:int = -2):Array {
      if(levels == -1)
        return array;

      var flattened:Array = [];

      for each(var obj:Object in array)
      if(obj is Array)
        flattened = flattened.concat(flatten(obj as Array, levels - 1));
      else
        flattened.push(obj);

      return flattened;
    }

    public static function shuffle(array:Array):Array {
      function withOrder(value:Object):Object {
        return { order: Math.random(), value: value };
      }

      return collect(collect(array, withOrder).sortOn('order'), 'value');
    }

    public static function reverse(array:Array):Array {
      var reversed:Array = [];

      for(var i:int = array.length-1; i >= 0; i--)
        reversed.push(array[i]);

      return reversed;
    }

    public static function each(array:Array, attr:Object):void {
      var fn:Function = toProc(attr);

      for each(var elem:Object in array)
      fn(elem);
    }

    public static function eachWithIndex(array:Array, attr:Object):void {
      var fn:Function = toProc(attr);

      for(var i:int = 0; i < array.length; i++)
        fn(array[i], i);
    }

    public static function collect(array:Array, attr:Object):Array {
      var fn:Function = toProc(attr);

      var collected:Array = [];

      for each(var elem:Object in array)
      collected.push(fn(elem));

      return collected;
    }

    public static function all(array:Array, attr:Object = null):Boolean {
      var fn:Function = toProc(attr);

      for each(var elem:Object in array)
      if(fn != null ? !fn(elem) : !elem)
        return false;

      return true;
    }

    public static function any(array:Array, attr:Object = null):Boolean {
      var fn:Function = toProc(attr);

      for each(var elem:Object in array)
      if(fn != null ? fn(elem) : elem)
        return true;

      return false;
    }

    public static function none(array:Array, attr:Object = null):Boolean {
      return !any(array, attr);
    }

    public static function includes(array:Array, left:Object):Boolean {
      var isSame:Function = function(right:Object):Boolean { return left == right; };

      return any(array, isSame);
    }

    public static function select(array:Array, attr:Object):Array {
      var fn:Function = toProc(attr);

      var collected:Array = [];

      for each(var elem:Object in array)
      if(fn(elem))
        collected.push(elem);

      return collected;
    }

    public static function find(array:Array, attr:Object):* {
      var res:Array = select(array, attr);
      return res.length > 0 ? res[0] : null;
    }

    public static function reject(array:Array, attr:Object):Array {
      return select(array, invert(attr));
    }

    public static function inject(array:Array, acc:Object, attr:Object):Object {
      var fn:Function = toProc(attr);

      for each(var elem:Object in array)
      acc = fn(acc, elem);

      return acc;
    }

    public static function sum(array:Array, attr:Object = null):Number {
      var fn:Function = toProc(attr);

      var count:int = 0;

      for each(var elem:Object in array)
      count += (fn != null ? fn(elem) : elem);

      return count;
    }

    public static function max(array:Array, attr:Object = null):Object {
      var fn:Function = toProc(attr);

      var max:Function = function(left:Object, right:Object):Boolean { return left > right; };
      return best(array, max, fn);
    }

    public static function min(array:Array, attr:Object = null):Object {
      var fn:Function = toProc(attr);

      var min:Function = function(left:Object, right:Object):Boolean { return left < right; };
      return best(array, min, fn);
    }

    public static function compact(array:Array):Array {
      var isNull:Function = function(elem:Object):Boolean { return elem == null };

      return reject(array, isNull);
    }

    public static function isEmpty(array:Array):Boolean { return array.length == 0 }

    public static function isEven(x:Number):Boolean { return x % 2 == 0 }
    public static function isOdd(x:Number):Boolean { return x % 2 == 1 }

    public static function hashBy(array:Array, attr:Object):Hash {
      var fn:Function = toProc(attr);
      var result:Hash = new Hash();

      for each(var elem:Object in array) {
        var key:Object = fn(elem);
        result[key] = elem;
      }

      return result;
    }

    private static function best(array:Array, operator:Function, attr:Object = null):Object {
      if(array.length == 0) return null;

      var fn:Function = toProc(attr);

      var best:Object = null;
      var bestIndex:int = 0;

      eachWithIndex(array, function(elem:Object, i:int):void {
        var val:Number = (fn != null ? fn(elem) : (elem as Number));

        if(best == null || val < best) {
          best = val;
          bestIndex = i;
        }
      });

      return array[bestIndex];
    }

    private static function toProc(attr:Object):Function {
      if(attr is String)
        return function(o:Object):Object { return o[attr]; };
      else
        return attr as Function;
    }

    private static function invert(attr:Object):Function {
      var fn:Function = toProc(attr);

      return function():Boolean { return !fn.apply(null, arguments); };
    }
  }
}
