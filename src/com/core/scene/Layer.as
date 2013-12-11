package com.core.scene
{
  import starling.display.Sprite;

  public class Layer extends Sprite
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private var _index:int;

    //
    // Constructors.
    //

    public function Layer(index:int) {
      _index = index;

      super();
    }

    //
    // Getters and setters.
    //

    public function get index():int { return _index; }

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