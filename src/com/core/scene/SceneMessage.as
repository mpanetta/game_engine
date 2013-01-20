package com.core.scene
{
  import com.core.messageBus.MessageBase;

  public class SceneMessage extends MessageBase
  {
    //
    // Constants.
    //

    public static const SCENE_CHANGE_START:String = "SCENE_MESSAGE_SCENE_CHANGE_START";
    public static const SCENE_CONTROLLER_PRELOADED:String = "SCENE_MESSAGE_SCENE_CONTROLLER_PRELOADED";
    public static const SCENE_CHANGE_FINISH:String = "SCENE_MESSAGE_SCENE_CHANGE_FINISH";

    // Requests
    public static const REQUEST_LAST_SCENE:String = "SCENE_MESSAGE_REQUEST_LAST_SCENE";

    //
    // Instance variables.
    //

    //
    // Constructors.
    //

    public function SceneMessage(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false) {
      super(type, data, bubbles, cancelable);
    }

    //
    // Getters and setters.
    //

    public function get scene():IScene { return data.scene; }

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