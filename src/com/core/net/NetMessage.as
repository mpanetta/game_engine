package com.core.net
{
  import com.core.messageBus.MessageBase;

  public class NetMessage extends MessageBase
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
    public static const AUTH_SUCCESS:String = "NET_EVENT_AUTH_SUCCESS";
    public static const AUTH_FAILURE:String = "NET_EVENT_AUTH_FAILURE";

    //
    // Instance variables.
    //

    //
    // Constructors.
    //

    public function NetMessage(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
      super(type, data, bubbles, cancelable);
    }

    //
    // Getters and setters.
    //

    public function get command():String { return data.command; };
    public function get params():Object { return data.params; };
    public function get messageId():String { return data.message_id };

    //
    // Public methods.
    //

    //
    // Private methods.
    //
  }
}