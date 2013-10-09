package com.core.scene
{
  import com.core.dataStructures.Hash;
  import com.core.error.ErrorBase;

  import flash.events.EventDispatcher;
  import flash.geom.Rectangle;

  import feathers.controls.Button;

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
    private var _listeners:Hash = new Hash();

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

      clearUIListeners();
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
      starlingView.width = 500; //starlingView.stage.stageWidth;
      starlingView.height = 375; //starlingView.stage.stageHeight;

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

    protected function createButton(handler:Function, opts:Object):Button {
      var button:Button = starlingView.addChild(new Button()) as Button;
      setDimensions(button, opts.dimensions);

      button.label = opts.hasOwnProperty('label') ? opts.label : "";
      if(handler)
        button.addEventListener(Event.TRIGGERED, handler);

      return button;
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

    private function setDimensions(obj:*, dimensions:Object):void {
      obj.width = dimensions.width;
      obj.height = dimensions.height;
      obj.x = dimensions.x;
      obj.y = dimensions.y;
    }

    private function addUIListener(target:starling.events.EventDispatcher, type:String, listener:Function):void {
      target.addEventListener(type, listener);
      if(!_listeners.hasOwnProperty(target))
        _listeners[target] = []

      _listeners[target].push({ type:type, listener:listener });
    }

    private function clearUIListeners():void {
      for(var target:starling.events.EventDispatcher in _listeners) {
        for each(var listener:Object in _listeners[target]) {
          target.removeEventListener(listener.type, listener.listener);
        }
      }

      _listeners.clear();
      _listeners = null;
    }

    //
    // Event handlers.
    //

    private function starlingView_addedToStage(event:Event):void {

    }
  }
}