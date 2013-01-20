package com.core.operationQueue
{
  import com.engine.GameMessage;

  public class OperationMessage extends GameMessage
  {
    //
    // Constants.
    //

    public static const OPERATION_COMPLETED:String = "OPERATION_EVENT_OPERATION_COMPLETED";
    public static const OPERATION_PROGRESS:String = "OPERATION_EVENT_OPERATION_PROGRESS";

    //
    // Instance Variables.
    //

    //
    // Constructors.
    //

    public function OperationMessage(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
      super(type, data, bubbles, cancelable);
    }

    //
    // Getters and setters.
    //

    public function get progress():int { return data.progress; }

    //
    // Public methods.
    //

    //
    // Private methods.
    //

    //
    // Event handlers.
    //
  }
}