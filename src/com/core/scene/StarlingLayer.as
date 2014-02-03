package com.core.scene
{
  import starling.display.Sprite;

  public class StarlingLayer extends Sprite
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

    public function StarlingLayer(index:int) {
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