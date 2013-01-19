package com.engine
{
  import flash.events.EventDispatcher;
  import flash.geom.Rectangle;

  import starling.core.Starling;
  import starling.display.Sprite;
  import starling.events.Event;
  import starling.events.ResizeEvent;

  public class StarlingDisplay extends Sprite
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private static var _dispatcher:flash.events.EventDispatcher = new EventDispatcher();

    private var _allowResize:Boolean = true;
    private var _initialized:Boolean = false;

    //
    // Constructors.
    //

    public function StarlingDisplay() {
      addEventListener(Event.ADDED_TO_STAGE, addedToStage);
    }

    //
    // Getters and setters.
    //

    public function set allowResize(value:Boolean):void { _allowResize = value; }
    public function get allowResize():Boolean { return _allowResize; }

    //
    // Public methods.
    //

    public static function addEventListener(type:String, handler:Function):void {
      _dispatcher.addEventListener(type, handler);
    }

    public static function removeEventListener(type:String, handler:Function):void {
      _dispatcher.removeEventListener(type, handler)
    }

    //
    // Private methods.
    //

    private function initialize():void {
      if(_initialized)
        throw new EngineError(EngineError.STARLING_DISPLAY_INIT);

      _initialized = true;

      stage.addEventListener(ResizeEvent.RESIZE, stage_resize);
      dispatchInitComplete();
    }

    private function resize(width:int, height:int):void {
      if(allowResize)
        Starling.current.viewPort = new Rectangle(0, 0, width, height);

      stage.stageWidth = width;
      stage.stageHeight = height;
    }

    private function dispatchInitComplete():void {
      _dispatcher.dispatchEvent(new flash.events.Event(flash.events.Event.INIT));
    }

    //
    // Event handlers.
    //

    private function addedToStage(event:Event):void {
      removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

      initialize();
    }

    private function stage_resize(event:ResizeEvent):void {
      resize(event.width, event.height);
    }
  }
}