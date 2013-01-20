package com.engine
{
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.geom.Rectangle;
  import flash.utils.Timer;

  import starling.core.Starling;

  public class RootDisplay extends Sprite
  {
    //
    // Constants.
    //

    private static const DEFAULT_RENDER_MODE:String = "auto";
    private static const DEFAULT_ANTIALIAS_SETTING:int = 1;

    //
    // Instance variables.
    //

    private var _opts:Object;
    private var _flashDisplay:Sprite;
    private var _starlingDisplay:StarlingDisplay;

    //
    // Constructors.
    //

    public function RootDisplay(opts:Object=null) {
      configure(opts);
      addEventListener(Event.ADDED_TO_STAGE, addedToStage);

      StarlingDisplay.addEventListener(Event.INIT, starlingDisplay_init);
    }

    //
    // Getters and setters.
    //

    public function get starlingDisplay():StarlingDisplay { return _starlingDisplay; }
    public function get flashDisplay():Sprite { return _flashDisplay; }
    public function get hardwareAccelerated():Boolean { return Starling.context.driverInfo.toLowerCase().indexOf('software') == -1; }

    //
    // Public methods.
    //

    //
    // Private methods.
    //

    private function configure(opts:Object):void {
      _opts = opts ? opts : {};

      if(!_opts.hasOwnProperty('render_mode')) _opts.render_mode = DEFAULT_RENDER_MODE;
      if(!_opts.hasOwnProperty('antialiasing')) _opts.antialiasing = DEFAULT_ANTIALIAS_SETTING;
    }

    private function setup():void {
      setupStage();
      Starling.handleLostContext = true;

      var starling:Starling = new Starling(StarlingDisplay, stage, null, null, _opts.render_mode);
      (starling as Starling).antiAliasing = _opts.antialiasing;
      (starling as Starling).start();

      Starling.current.viewPort = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);



      _flashDisplay = (starling as Starling).nativeOverlay;
    }

    private function setupStage():void {
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.color = 0;
    }

    private function dispatchInitialize():void {
      _starlingDisplay = Starling.current.stage.getChildAt(0) as StarlingDisplay;
      _starlingDisplay.allowResize = true;

      dispatchEvent(new GameMessage(GameMessage.ROOT_DISPLAY_INITIALIZED));
    }

    //
    // Event handlers.
    //

    private function addedToStage(event:Event):void {
      removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

      setup();
    }

    private function starlingDisplay_init(event:Event):void {
      StarlingDisplay.removeEventListener(Event.INIT, starlingDisplay_init);

      dispatchInitialize();
    }
  }
}