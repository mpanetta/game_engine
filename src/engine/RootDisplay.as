package engine
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
    private static const DEFAULT_UPDATE_DWELL:int = 750;

    //
    // Instance variables.
    //

    private var _opts:Object;
    private var _flashDisplay:Sprite;

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

    //
    // Public methods.
    //

    //
    // Private methods.
    //

    private function configure(opts:Object):void {
      _opts = opts ? opts : {};

      if(!_opts.hasOwnProperty('render_mode')) opts.render_mode = DEFAULT_RENDER_MODE;
      if(!_opts.hasOwnProperty('antialiasing')) opts.render_mode = DEFAULT_ANTIALIAS_SETTING;
      if(!_opts.hasOwnProperty('update_dwell')) opts.render_mode = DEFAULT_UPDATE_DWELL;
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

    private function startViewportUpdate():void {
      var timer:Timer = new Timer(_opts.update_dwell, 0);
      timer.addEventListener(TimerEvent.TIMER, timer_updateViewPort);
      timer.start();
    }

    //
    // Event handlers.
    //

    private function addedToStage(event:Event):void {

    }

    private function starlingDisplay_init(event:Event):void {

    }

    private function timer_updateViewPort(event:TimerEvent):void {

    }
  }
}