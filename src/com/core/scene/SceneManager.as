package com.core.scene
{
  import avmplus.getQualifiedClassName;

  import com.core.messageBus.MessageBus;
  import com.engine.RootDisplay;

  import flash.events.EventDispatcher;
  import flash.geom.Rectangle;
  import flash.utils.getDefinitionByName;

  public class SceneManager extends EventDispatcher
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private var _rootDisplay:RootDisplay;
    private var _scene:IScene;
    private var _controller:IController;
    private var _hud:IHud;
    private var _changing:Boolean;
    private var _scenes:Vector.<IScene> = new Vector.<IScene>;

    //
    // Constructors.
    //

    public function SceneManager(rootDisplay:RootDisplay) {
      _rootDisplay = rootDisplay;

      register();
    }

    public function dispose():void {
      unregister();

      removeCurrentScene();
    }

    //
    // Getters and setters.
    //

    public function get currentScene():IScene { return _scene; }

    //
    // Public methods.
    //

    public function transition(controller:IController, opts:Object):void {
      dispatchEvent(new SceneMessage(SceneMessage.SCENE_CHANGE_START));
      _changing = true;

      pushSceneRequest(controller, opts);

      if(_scene)
        removeCurrentScene();

      dispatchEvent(new SceneMessage(SceneMessage.SCENE_CHANGE_FINISH));
    }

    //
    // Private methods.
    //

    private function register():void {
      MessageBus.instance.add(this, SceneMessage.SCENE_CHANGE_START);
      MessageBus.instance.add(this, SceneMessage.SCENE_CHANGE_FINISH);

      MessageBus.instance.addEventListener(SceneMessage.REQUEST_LAST_SCENE, messageBus_requestLastScene);
    }

    private function unregister():void {
      MessageBus.instance.remove(this, SceneMessage.SCENE_CHANGE_START);
      MessageBus.instance.remove(this, SceneMessage.SCENE_CHANGE_FINISH);

      MessageBus.instance.removeEventListener(SceneMessage.REQUEST_LAST_SCENE, messageBus_requestLastScene);
    }

    private function pushSceneRequest(controller:IController, opts:Object):void {
      if(opts.hasOwnProperty("noCache") && opts.noCache == true)
        return;

      var klass:Class = getDefinitionByName(getQualifiedClassName(controller)) as Class;
      var request:Object = { klass:klass, args:opts };

      _scenes.push(request);
      if(_scenes.length > 10)
        _scenes.shift();
    }

    private function popSceneRequest():void {
      if(_scenes.length == 0)
        return;

      var request:Object = _scenes.pop();
      var controller:IController = new (request.klass as Class)();
      transition(controller, request.args);
    }

    private function removeCurrentScene():void {
      _scene.dispose();
      _controller.dispose();
    }

    private function addScene(controller:IController, opts:Object):void {
      _controller = controller;


      _controller.addEventListener(SceneMessage.SCENE_CONTROLLER_PRELOADED, controller_sceneControllerPreloaded);
      _controller.initialize(opts);
    }

    private function resize(rect:Rectangle):void {
      _scene.resize(rect);
    }

    //
    // Event handlers.
    //

    private function messageBus_requestLastScene(message:SceneMessage):void {
      popSceneRequest();
    }

    private function controller_sceneControllerPreloaded(message:SceneMessage):void {

    }
  }
}