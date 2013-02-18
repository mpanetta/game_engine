package com.core.net
{
  import com.core.messageBus.MessageBase;

  public class NetEvent extends MessageBase
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

    //
    // Constructors.
    //

    public function NetEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
      super(type, data, bubbles, cancelable);
    }

    //
    // Getters and setters.
    //

    //
    // Public methods.
    //

    //
    // Private methods.
    //
  }
}