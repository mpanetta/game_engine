package com.core.scene
{

  import com.engine.EngineError;

  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  import starling.core.Starling;
  import starling.display.Sprite;
  import starling.events.Event;

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
    private var _sceneLayer:Sprite;
    private var _hudLayer:Sprite;
    private var _targetResolution:Point;

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

    public function addScene(scene:IScene):void {
      _sceneLayer.addChild(scene.starlingContainer);
      scene.setScene();
    }

    public function removeScene(scene:IScene):void {
      _sceneLayer.removeChild(scene.starlingContainer);
    }

    public function addHud(hud:IHud):void {

    }

    public function removeHud(hud:IHud):void {

    }

    //
    // Private methods.
    //

    private function initialize():void {
      if(_initialized)
        throw new EngineError(EngineError.STARLING_DISPLAY_INIT);

      _initialized = true;

      createLayers();
      resize(stage.stageWidth, stage.stageHeight);

      dispatchInitComplete();
    }

    public function resize(newWidth:int, newHeight:int):void {
      if(!allowResize) return;

      stage.stageWidth = newWidth;
      stage.stageHeight = newHeight;
      Starling.current.viewPort = new Rectangle(0, 0, newWidth, newHeight);
    }

    private function createLayers():void {
      _sceneLayer = new Sprite();
      _hudLayer = new Sprite();

      addChild(_sceneLayer);
      addChild(_hudLayer);
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
  }
}