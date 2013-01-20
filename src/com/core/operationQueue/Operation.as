package com.core.operationQueue
{
  import com.core.dataStructures.ArrayHelper;

  public class Operation
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private var _weight:uint;
    private var _operation:Function;
    private var _arguments:Array = [];

    //
    // Constructors.
    //

    public function Operation(operation:Function, weight:uint=0, arguments:Array=null) {
      _operation = operation;
      _weight = weight;

      if(arguments)
        _arguments = arguments;
    }

    //
    // Getters and setters.
    //

    public function get weight():uint { return _weight; }

    //
    // Public methods.
    //

    public function applyWithArgs(...args):void {
      _operation.apply(null, ArrayHelper.flatten(args))
    }

    public function apply():void {
      _operation.apply(null, _arguments);
    }

    //
    // Protected Methods.
    //

    //
    // Private methods.
    //

    //
    // Event handlers.
    //
  }
}