package com.engine
{
  import com.core.error.ErrorBase;

  public class EngineError extends ErrorBase
  {
    //
    // Constants.
    //

    public static const STARLING_DISPLAY_INIT:String = "Starling display already initialized.";
    public static const ENGINE_INIT:String = "Engine is already intialized.";
    public static const ENGINE_NOT_INITIALIZED:String = "Engine must be initialized before using it.";

    //
    // Instance variables.
    //

    //
    // Constructors.
    //

    public function EngineError(type:String, details:String="", id:*=0) {
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