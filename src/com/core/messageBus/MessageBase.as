package com.core.messageBus
{
  import flash.events.Event;
  import flash.utils.*;

  public class MessageBase extends Event
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private var _data:Object;

    //
    // Constructors.
    //

    public function MessageBase(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
      _data = data ? data : {};

      super(type, bubbles, cancelable);
    }

    //
    // Getters and setters.
    //

    public override function get currentTarget():Object { return _data && _data.currentTarget ? _data.currentTarget : super.currentTarget; }
    public override function get target():Object { return _data && _data.target ? _data.target : super.target; }

    public function get data():Object { return _data; }
    public function get result():Object { return _data.result; }
    public function get states():Object { return _data.states; }
    public function get description():String { return _data.description; }

    //
    // Public methods.
    //

    public override function clone():Event {
      var className:Class = Class(getDefinitionByName(getQualifiedClassName(this)));

      _data.target = target;
      _data.currentTarget = currentTarget;

      return new className(type, _data, bubbles, cancelable);
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