package com.core.error
{
  public class ErrorBase extends Error
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    public static const ALREADY_DISPOSED:String = "Object already disposed once, cannot dispose a second time";
    public static const UNINITIALIZED:String = "Object must be intialized before using";
    public static const MULTIPLE_INITIALIZE:String = "Object has already been intialized and cannot be initialized again";
    public static const ABSTRACT_METHOD:String = "Method must be overriden in derived class";
    public static const LISTENERS_NOT_REMOVED:String = "Attmepting to dispose object while listeners are still attached";

    //
    // Constructors.
    //

    public function ErrorBase(type:String, details:String, id:*=0) {
      super(createMessage(type, details), id);
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

    private function createMessage(type:String, details:String):String {
      return type + " :: " + details;
    }

    //
    // Event handlers.
    //
  }
}