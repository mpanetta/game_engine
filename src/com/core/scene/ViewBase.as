package com.core.scene
{
  import com.core.dataStructures.Hash;
  import com.core.error.ErrorBase;

  import flash.events.EventDispatcher;

  import starling.display.Sprite;
  import starling.events.Touch;
  import starling.events.TouchEvent;
  import starling.events.TouchPhase;

  public class ViewBase extends Sprite
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private var _dispatcher:EventDispatcher = new EventDispatcher();
    private var _listenerCount:int;
    private var _types:Hash = new Hash();
    private var _disposed:Boolean = false;

    //
    // Constructors.
    //

    public function ViewBase() {
      register();

      super();
    }

    public override function dispose():void {
      checkDispose();
      unregister();

      super.dispose();
    }

    //
    // Getters and setters.
    //

    protected function get dispatcher():EventDispatcher { return _dispatcher; }

    //
    // Public methods.
    //

    public function addListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
      _listenerCount += 1;
      _types[type] ? _types[type] += 1 : _types[type] = 1;

      _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
    }

    public function removeListener(type:String, listener:Function, useCapture:Boolean=false):void {
      _listenerCount -= 1;
      _types[type] == 1 ? delete _types[type] : _types[type] -= 1;

      _dispatcher.removeEventListener(type, listener, useCapture);
    }

    //
    // Protected methods.
    //

    protected function handleHover(touch:Touch):void {

    }

    protected function handleBegan(touch:Touch):void {

    }

    protected function handleMoved(touch:Touch):void {

    }

    protected function handleStationary(touch:Touch):void {

    }

    protected function handleEnded(touch:Touch):void {

    }

    //
    // Private methods.
    //

    private function register():void {
      addEventListener(TouchEvent.TOUCH, touch);
    }

    private function unregister():void {
      removeEventListener(TouchEvent.TOUCH, touch);
    }

    private function checkDispose():void {
      if(_disposed)
        throw new ErrorBase(ErrorBase.ALREADY_DISPOSED, "ViewBase");

      if(_listenerCount > 0)
        throw new ErrorBase(ErrorBase.LISTENERS_NOT_REMOVED, _listenerCount.toString());

      _disposed = true;
    }

    //
    // Event handlers.
    //

    private function touch(event:TouchEvent):void {
      handleHover(event.getTouch(this, TouchPhase.HOVER));
      handleBegan(event.getTouch(this, TouchPhase.BEGAN));
      handleMoved(event.getTouch(this, TouchPhase.MOVED));
      handleStationary(event.getTouch(this, TouchPhase.STATIONARY));
      handleEnded(event.getTouch(this, TouchPhase.ENDED));
    }
  }
}