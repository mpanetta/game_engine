package com.core.messageBus
{
  import com.core.error.ErrorBase;

  public class MessageError extends ErrorBase
  {
    //
    // Constants.
    //

    public static const MULTIPLE_LISTENER:String = "Already added listener. Cannot add twice to the same target";
    public static const MISSING_LISTENER:String = "Target does not have a registered listener of this type to remove. Was it already disposed?";

    //
    // Instance variables.
    //

    //
    // Constructors.
    //

    public function MessageError(type:String, details:String, id:*=0) {
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