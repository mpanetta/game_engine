package com.engine
{
  import com.core.messageBus.MessageBase;

  public class GameMessage extends MessageBase
  {
    //
    // Constants.
    //

    public static const ROOT_DISPLAY_INITIALIZED:String = "GAME_MESSAGE_ROOT_DISPLAY_INITIALIZED";
    public static const ENGINE_INITIALIZED:String = "GAME_MESSAGE_ENGINE_INITIALIZED";

    //
    // Instance variables.
    //

    //
    // Constructors.
    //

    public function GameMessage(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
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

    //
    // Event handlers.
    //
  }
}