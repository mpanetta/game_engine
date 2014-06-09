package com.core.scene
{
  import flash.display.Sprite;

  public class FlashDisplay extends Sprite
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    //
    // Constructors.
    //

    public function FlashDisplay() {
      super();
    }

    //
    // Getters and setters.
    //

    //
    // Public methods.
    //

    public function addScene(scene:IScene):void {
      addChild(scene.flashContainer);
    }

    public function removeScene(scene:IScene):void {
      if(contains(scene.flashContainer))
        removeChild(scene.flashContainer);
    }

    //
    // Private methods.
    //

    //
    // Event handlers.
    //
  }
}