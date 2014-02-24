package com.engine
{
  import com.core.messageBus.MessageBus;
  import com.core.net.NetManager;
  import com.core.scene.RootDisplay;
  import com.core.scene.SceneManager;
  import com.sound.SoundManager;

  import flash.events.EventDispatcher;

  import starling.core.Starling;

  public class Engine extends EventDispatcher
  {
    //
    // Constants.
    //

    private static const DEFAULT_FRAMERATE:int = 60;

    //
    // Instance variables.
    //

    private static var _instance:Engine;

    private var _options:Object;
    private var _rootDisplay:RootDisplay;
    private var _sceneManager:SceneManager;
    private var _assets:*;

    //
    // Constructors.
    //

    public function Engine(sb:SingletonBlocker, options:Object) {
      _options = options;
      SoundManager.initialize(options);
    }

    public static function initialize(options:Object):void {
      if(_instance != null)
        throw new EngineError(EngineError.ENGINE_INIT);

      _instance = new Engine(new SingletonBlocker, options);
    }

    public static function get instance():Engine {
      if(!_instance)
        throw new EngineError(EngineError.ENGINE_NOT_INITIALIZED);

      return _instance;
    }

    //
    // Getters and setters.
    //

    public static function get sceneManager():SceneManager { return _instance.sceneManager; }

    public function get sceneManager():SceneManager { return _sceneManager; }
    public function get contentScaleFactor():Number { return Starling.contentScaleFactor; }
    public function get width():int { return sceneManager.width; }
    public function get height():int { return sceneManager.height; }
    public function get appWidth():int { return _options.appWidth; }
    public function get appHeight():int { return _options.appHeight; }
    public function get assetManager():* { return _assets; }

    //
    // Public methods.
    //

    public function startGame():void {
      startEngine(_options);
    }

    public function registerAssets(assets:Object):void {
      _assets = assets;
    }

    public static function getAsset(name:String):* {
      return _instance.assetManager[name];
    }

    //
    // Private methods.
    //

    private function startEngine(options:Object):void {
      startUtilityServices(options);
      createRootDisplay(options);
    }

    private function startUtilityServices(options:Object):void {
      MessageBus.initialize(options);
      NetManager.initialize('localhost', 9000);
    }

    private function createRootDisplay(opts:Object):void {
      _rootDisplay = new RootDisplay(opts);
      _rootDisplay.addEventListener(GameMessage.ROOT_DISPLAY_INITIALIZED, _instance.rootDisplay_initialized);

      _options.stage.addChild(_rootDisplay);
    }

    private function initializeEngine():void {
      createSceneGraph();
      setFramerate();

      dispatchEvent(new GameMessage(GameMessage.ENGINE_INITIALIZED));
    }

    private function createSceneGraph():void {
      _sceneManager = new SceneManager(_rootDisplay);
    }

    private function setFramerate():void {
      _options.framerate = _options.hasOwnProperty('framerate') ? _options.framerate : DEFAULT_FRAMERATE;
    }

    //
    // Event handlers.
    //

    private function rootDisplay_initialized(message:GameMessage):void {
      _rootDisplay.removeEventListener(GameMessage.ROOT_DISPLAY_INITIALIZED, rootDisplay_initialized);

      initializeEngine();
    }
  }
}

class SingletonBlocker {}