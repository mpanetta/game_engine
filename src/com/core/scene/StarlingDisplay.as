package com.core.scene
{

  import com.engine.Engine;
  import com.engine.EngineError;
  import com.util.scaleToFit;

  import flash.display.Bitmap;
  import flash.events.EventDispatcher;
  import flash.geom.Point;
  import flash.geom.Rectangle;

  import starling.core.Starling;
  import starling.display.BlendMode;
  import starling.display.Image;
  import starling.display.Sprite;
  import starling.events.Event;
  import starling.textures.Texture;

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
    private var _backgroundLayer:Sprite;
    private var _targetResolution:Point;
    private var _backgroundImage:Image;

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
      addBackground(Engine.options.backgroundImage);
      resize(stage.stageWidth, stage.stageHeight);

      dispatchInitComplete();
    }

    public function resize(newWidth:int, newHeight:int):void {
      if(!allowResize) return;

      stage.stageWidth = newWidth;
      stage.stageHeight = newHeight;
      Starling.current.viewPort = new Rectangle(0, 0, newWidth, newHeight);

      if(_backgroundImage)
        scaleToFit(_backgroundImage, newWidth, newHeight);
    }

    private function createLayers():void {
      _backgroundLayer = new Sprite();
      _sceneLayer = new Sprite();
      _hudLayer = new Sprite();

      addChild(_backgroundLayer);
      addChild(_sceneLayer);
      addChild(_hudLayer);
    }

    private function addBackground(bitmap:Bitmap):void {
      if(!bitmap) return;

      _backgroundImage = new Image(Texture.fromBitmap(bitmap));
      _backgroundLayer.addChild(_backgroundImage);
      _backgroundImage.blendMode = BlendMode.NONE;
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