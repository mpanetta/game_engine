package engine
{
  import com.core.error.ErrorBase;

  public class EngineError extends ErrorBase
  {
    //
    // Constants.
    //

    public static const STARLING_DISPLAY_INIT:String = "Starling display already initialized.";

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