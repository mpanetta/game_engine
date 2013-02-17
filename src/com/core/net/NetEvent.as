package com.core.net
{
  import flash.events.Event;

  public class NetEvent extends Event
  {
    //
    // Constants.
    //

    public static const PING:String = "NET_EVENT_PING";
    public static const FAILED:String = "NET_EVENT_FAILED";
    public static const CONNECTED:String = "NET_EVENT_CONNECTED";
    public static const DISCONNECTED:String = "NET_EVENT_DISCONNECTED";
    public static const RECEIVED_MESSAGE:String = "NET_EVENT_RECEIVED_MESSAGE";
    public static const RECEIVED_REQUEST:String = "NET_EVENT_RECEIVED_REQUEST";

    //
    // Instance variables.
    //

    protected var _data:Object;

    //
    // Constructors.
    //

    public function NetEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
      super(type, bubbles, cancelable);

      _data = data;
    }

    //
    // Getters and setters.
    //

    public function get data():Object { return _data; }

    //
    // Public methods.
    //

    //
    // Private methods.
    //
  }
}