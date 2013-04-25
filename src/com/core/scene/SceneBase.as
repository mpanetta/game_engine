package com.core.scene
{
  import com.core.error.ErrorBase;

  import flash.events.EventDispatcher;
  import flash.geom.Rectangle;

  import starling.display.Sprite;
  import starling.events.Event;

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
    private var _starlingView:Sprite = new Sprite();

    //
    // Constructors.
    //

    public function SceneBase(data:Object) {
      _data:Object
      _count++;

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

    public function resize(rectangle:Rectangle):void {
    }

    public function setScene():void {
      starlingView.width = 500;//starlingView.stage.stageWidth;
      starlingView.height = 375;//starlingView.stage.stageHeight;

      load();
    }

    //
    // Protected methods.
    //

    protected function load():void {
      throw new ErrorBase(ErrorBase.ABSTRACT_METHOD, "SceneBase::load");
    }

    protected function complete():void {
      dispatchEvent(new SceneMessage(SceneMessage.SCENE_CHANGE_FINISH, {}));
    }

    //
    // Private methods.
    //

    private function register():void {
      _starlingView.addEventListener(Event.ADDED_TO_STAGE, starlingView_addedToStage);
    }

    private function unregister():void {
      _starlingView.removeEventListener(Event.ADDED_TO_STAGE, starlingView_addedToStage);
    }

    private function disposeCheck():void {
      if(_disposed)
        throw new SceneError(SceneError.ALREADY_DISPOSED, " SceneBase, count: " + _count);
    }

    //
    // Event handlers.
    //

    private function starlingView_addedToStage(event:Event):void {

    }
  }
}