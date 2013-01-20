package com.core.scene
{
  import flash.events.EventDispatcher;
  import flash.geom.Rectangle;

  import starling.display.Sprite;

  public class SceneBase extends EventDispatcher implements IScene
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private static var _count:int = 0;

    private var _disposed:Boolean = false;
    private var _data:Object;
    private var _starlingView:Sprite;

    //
    // Constructors.
    //

    public function SceneBase() {
      _count++;
      _starlingView = new Sprite();

      register();
    }

    public function dispose():void {
      disposeCheck();
      unregister();

      _count--;
    }

    //
    // Getters and setters.
    //

    public function get disposed():Boolean { return _disposed; }
    public function get starlingView():Sprite { return _starlingView; }

    //
    // Public methods.
    //

    public function initialize(data:Object):void {
      _data = data;
    }

    public function load():void {
    }

    public function resize(rectangle:Rectangle):void {
    }

    //
    // Private methods.
    //

    private function register():void {

    }

    private function unregister():void {

    }

    private function disposeCheck():void {
      if(_disposed)
        throw new SceneError(SceneError.ALREADY_DISPOSED, " SceneBase, count: " + _count);
    }

    //
    // Event handlers.
    //
  }
}