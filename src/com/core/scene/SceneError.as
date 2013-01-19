package com.core.scene
{
  import com.core.error.ErrorBase;

  public class SceneError extends ErrorBase
  {
    //
    // Constants.
    //

    public static const ALREADY_DISPOSED:String = "Scene already disposed";
    public static const INVALID_SCENE_CLASS:String = "Invalid scene class";

    //
    // Instance variables.
    //

    //
    // Constructors.
    //

    public function SceneError(type:String, details:String, id:*=0) {
      super(type, details, id);
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