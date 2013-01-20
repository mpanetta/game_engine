package com.core.operationQueue
{
  import flash.events.EventDispatcher;

  public class OperationQueue extends EventDispatcher
  {
    //
    // Constants.
    //

    //
    // Instance Variables.
    //

    private var _operations:Array = [];
    private var _started:Boolean = false;
    private var _totalWeight:uint = 0;
    private var _completedWeight:uint = 0;

    //
    // Constructors.
    //

    public function OperationQueue() {
      super();
    }

    //
    // Getters and setters.
    //

    public function get progress():int { return _totalWeight > 0 ? _completedWeight/_totalWeight : -1; }

    //
    // Public methods.
    //

    public override function toString():String {
      return "[OperationQueue(" + "started:" + _started + " totalWeight:" + _totalWeight + " completedWeight:" + _completedWeight + ")]";
    }

    public function addOperation(operation:Operation):void {
      if(_started) throw new Error("Can't add an operation to an already started queue")
      _operations.push(operation);
    }

    public function startWithArgs(...args):void {
      if(_started) return;
      _started = true;

      computeWeight();
      _operations.reverse();

      processWithArgs(args);
    }

    public function processWithArgs(...args):void {
      if(!_started) throw new Error("Can't process until you start the queue")
      if(_operations.length == 0) throw new Error("There are no operations to process")

      var operation:Operation = _operations.pop();
      operation.applyWithArgs(args);
      _completedWeight += operation.weight;

      if(_operations.length == 0)
        dispatchCompletionEvent();
      else
        dispatchProgressEvent();
    }

    public function start():void {
      if(_started) return;
      _started = true;

      computeWeight();
      _operations.reverse();

      process();
    }

    public function process():void {
      if(!_started) throw new Error("Can't process until you start the queue")
      if(_operations.length == 0) throw new Error("There are no operations to process")

      var operation:Operation = _operations.pop();
      operation.apply();
      _completedWeight += operation.weight;

      if(_operations.length == 0)
        dispatchCompletionEvent();
      else
        dispatchProgressEvent();
    }

    public function hasOperations():Boolean {
      return _operations.length > 0;
    }

    //
    // Protected Methods.
    //

    //
    // Private methods.
    //

    private function computeWeight():void {
      for(var i:int = 0; i < _operations.length; i++)
        _totalWeight += _operations[i].weight;
    }

    private function dispatchCompletionEvent():void {
      dispatchEvent(new OperationMessage(OperationMessage.OPERATION_COMPLETED, {progress: progress}));
    }

    private function dispatchProgressEvent():void {
      dispatchEvent(new OperationMessage(OperationMessage.OPERATION_PROGRESS, {progress: progress}));
    }

    //
    // Event handlers.
    //
  }
}