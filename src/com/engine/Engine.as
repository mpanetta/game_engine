package com.engine
{
  import com.core.messageBus.MessageBus;
  import com.core.scene.SceneManager;

  import flash.events.EventDispatcher;

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

    //
    // Constructors.
    //

    public function Engine(sb:SingletonBlocker, options:Object) {
      _options = options;
    }

    public static function initialize(options:Object):void {
      if(_instance != null)
        throw new EngineError(EngineError.ENGINE_INIT);

      _instance = new Engine(new SingletonBlocker, options);
      _instance.startEngine(options);
    }

    public static function get instance():Engine {
      if(_instance) return _instance;

      throw new EngineError(EngineError.ENGINE_NOT_INITIALIZED);
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

    private function startEngine(options:Object):void {
      startUtilityServices(options);
      createRootDisplay(options);
    }

    private function startUtilityServices(options:Object):void {
      MessageBus.initialize(options);
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
      _options.stage = _options.hasOwnProperty('framerate') ? _options.framerate : DEFAULT_FRAMERATE;
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