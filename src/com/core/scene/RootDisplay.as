package com.core.scene
{

  import com.engine.GameMessage;

  import flash.display.Bitmap;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageQuality;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  import feathers.system.DeviceCapabilities;

  import starling.core.Starling;

  public class RootDisplay extends Sprite
  {
    //
    // Constants.
    //

    private static const DEFAULT_RENDER_MODE:String = "auto";
    private static const DEFAULT_ANTIALIAS_SETTING:int = 4;
    private static const DEFAULT_FRAME_RATE:int = 24;
    private static const DEFAULT_STAT:Boolean = false;

    //
    // Instance variables.
    //

    private var _opts:Object;
    private var _flashDisplay:FlashDisplay;
    private var _starlingDisplay:StarlingDisplay;
    private var _timer:Timer;

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
    public function get flashDisplay():FlashDisplay { return _flashDisplay; }
    public function get hardwareAccelerated():Boolean { return Starling.context.driverInfo.toLowerCase().indexOf('software') == -1; }

    //
    // Public methods.
    //

    public function addScene(scene:IScene):void {
      _starlingDisplay.addScene(scene);
      _flashDisplay.addScene(scene);
    }

    public function removeScene(scene:IScene):void {
      _starlingDisplay.removeScene(scene);
      _flashDisplay.removeScene(scene);
    }

    public function setBackground(bitmap:Bitmap):void {

    }

    //
    // Private methods.
    //

    private function configure(opts:Object):void {
      _opts = opts ? opts : {};

      if(!_opts.hasOwnProperty('render_mode')) _opts.render_mode = DEFAULT_RENDER_MODE;
      if(!_opts.hasOwnProperty('antialiasing')) _opts.antialiasing = DEFAULT_ANTIALIAS_SETTING;
      if(!_opts.hasOwnProperty('frameRate')) _opts.frameRate = DEFAULT_FRAME_RATE;
      if(!_opts.hasOwnProperty('stats')) _opts.stats = DEFAULT_STAT;
    }

    private function setup():void {
      stage.addEventListener(Event.RESIZE, stage_resize);
      setupStage();
      Starling.handleLostContext = true;
      var star:Starling = new Starling(StarlingDisplay, stage, null, null, _opts.render_mode, "baseline");
      star.antiAliasing = 4;//_opts.antialiasing;
      star.start();
      star.showStats = _opts.stats;

      _flashDisplay = new FlashDisplay();
      star.nativeOverlay.addChild(_flashDisplay);
    }

    private function setupStage():void {
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.quality = StageQuality.HIGH;
      stage.frameRate = _opts.frameRate;
      stage.color = 0;

//      if(_opts.appWidth && _opts.appHeight) {
//        DeviceCapabilities.dpi = 150;
//        DeviceCapabilities.screenPixelWidth = _opts.appWidth;
//        DeviceCapabilities.screenPixelHeight = _opts.appHeight;
//      }
    }

    private function dispatchInitialize():void {
      _starlingDisplay = Starling.current.stage.getChildAt(0) as StarlingDisplay;
      _starlingDisplay.allowResize = true;

      dispatchEvent(new GameMessage(GameMessage.ROOT_DISPLAY_INITIALIZED));
    }

    private function resize():void {
      if(!_starlingDisplay) return;

      stopTimer();
      _starlingDisplay.resize(stage.stageWidth, stage.stageHeight);
    }

    private function startTimer():void {
      if(_timer)
        stopTimer();

      _timer = new Timer(100, 1);
      _timer.addEventListener(TimerEvent.TIMER, timer_timer);
      _timer.start();
    }

    private function stopTimer():void {
      _timer.stop();
      _timer.removeEventListener(TimerEvent.TIMER, timer_timer);
      _timer = null;
    }

    //
    // Event handlers.
    //

    private function addedToStage(event:Event):void {
      removeEventListener(Event.ADDED_TO_STAGE, addedToStage);

      setup();
    }

    private function stage_resize(event:Event):void {
      startTimer();
    }

    private function starlingDisplay_init(event:Event):void {
      StarlingDisplay.removeEventListener(Event.INIT, starlingDisplay_init);

      dispatchInitialize();
    }

    private function timer_timer(event:TimerEvent):void {
      resize();
    }
  }
}