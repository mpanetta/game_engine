package com.core.fsm
{
  import com.core.error.ErrorBase;

  public class FsmError extends ErrorBase
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    public static const ALREADY_REGISTERED_TRANSITION:String = "Transition has alredy been registered";
    public static const CALLBACK_ALREADY_REGISTERED:String = "Callback has already been registered";
    public static const BAD_STATE:String = "Current state does not exist";
    public static const NO_EVENT:String = "Event not registered for this state";

    //
    // Constructors.
    //

    public function FsmError(type:String, details:String, id:*=0) {
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