package com.core.dataStructures
{
  public class Array2D
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private var _data:Array;
    private var _width:int = 0;
    private var _height:int = 0;

    //
    // Constructors.
    //

    public function Array2D(width:int, height:int) {
      if(width < 1 || height < 1)
        throw new Error("Width and Height Must Be Greater Than or Equal to 1");

      _data = new Array(_width = width, _height = height);

      fill(null);
    }

    //
    // Getters and setters.
    //

    public function set width(val:int):void { _width = val }
    public function get width():int { return _width; }

    public function set height(val:int):void { _height = val }
    public function get height():int { return _height; }

    public function get size():int { return _width * height; }
    public function get linear():Array { return _data; }

    //
    // Public methods.
    //

    public function fill(obj:*):void {
      var k:int = _width * _height;
      var i:int;

      if(obj is Class) {
        var type:Class = obj as Class;

        for (i = 0; i < k; i++)
          _data[i] = new type();
      } else {
        for (i = 0; i < k; i++)
          _data[i] = obj;
      }
    }

    public function clear():void {
      _data = new Array(size);
    }

    public function get(x:int, y:int):* {
      if(x >= width || y >= _height || x < 0 || y < 0)
        return null;

      return _data[int(y * _width + x)];
    }

    public function set(x:int, y:int, obj:*):void {
      _data[int(y * _width + x)] = obj;
    }

    public function contains(obj:*):Boolean {
      var k:int = size;

      for (var i:int = 0; i < k; i++) {
        if (_data[i] === obj)
          return true;
      }

      return false;
    }

    public function resize(width:int, height:int):void {
      if (width < 1 || height < 1)
        throw new Error("Width and Height Must Be Greater Than or Equal to 1");

      var copy:Array = _data.concat();

      _data.length = 0;
      _data.length = width * height;

      var minx:int = width < _width ? width : _width;
      var miny:int = height < _height ? height : _height;

      var x:int, y:int, t1:int, t2:int;
      for (y = 0; y < miny; y++) {
        t1 = y *  width;
        t2 = y * _width;

        for (x = 0; x < minx; x++)
          _data[int(t1 + x)] = copy[int(t2 + x)];
      }

      _width = width;
      _height = height;
    }

    public function toString():String {
      var string:String = "Array2\n{";
      var offset:int, value:*;
      for (var y:int = 0; y < _height; y++) {
        string += "\n" + "\t";
        offset = y * _width;
        for (var x:int = 0; x < _width; x++) {
          value = _data[int(offset + x)];
          string += "[" + (value != undefined ? value : "?") + "]";
        }
      }
      string += "\n}";
      return string;
    }

    //
    // Private methods.
    //

    //
    // Protected Methods.
    //

    //
    // Event handlers.
    //
  }
}