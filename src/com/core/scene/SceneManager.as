package com.core.scene
{
  import com.core.messageBus.MessageBus;
  import com.engine.RootDisplay;

  import flash.display.Stage;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.utils.getDefinitionByName;

  import avmplus.getQualifiedClassName;

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
    private var _scenes:Vector.<Object> = new Vector.<Object>;

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

    private function get stage():Stage { return _rootDisplay.stage; }

    public function get width():int { return stage.stageWidth; }
    public function get height():int { return stage.stageHeight; }
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

      addScene(controller, opts);
    }

    //
    // Private methods.
    //

    private function register():void {
      MessageBus.instance.add(this, SceneMessage.SCENE_CHANGE_START);
      MessageBus.instance.add(this, SceneMessage.SCENE_CHANGE_FINISH);

      MessageBus.instance.addEventListener(SceneMessage.REQUEST_LAST_SCENE, messageBus_requestLastScene);

      stage.addEventListener(Event.RESIZE, stage_resize);
    }

    private function unregister():void {
      MessageBus.instance.remove(this, SceneMessage.SCENE_CHANGE_START);
      MessageBus.instance.remove(this, SceneMessage.SCENE_CHANGE_FINISH);

      MessageBus.instance.removeEventListener(SceneMessage.REQUEST_LAST_SCENE, messageBus_requestLastScene);

      stage.addEventListener(Event.RESIZE, stage_resize);
    }

    private function resize(width:Number, height:Number):void {
      if(!_scene) return;

      _scene.resize(width, height);
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
      _rootDisplay.starlingDisplay.removeScene(_scene);

      _scene.removeEventListener(SceneMessage.SCENE_CHANGE_FINISH, scene_sceneChangeFinish);
      _scene.dispose();
      _controller.dispose();
    }

    private function addScene(controller:IController, opts:Object):void {
      _controller = controller;

      _controller.addEventListener(SceneMessage.SCENE_CONTROLLER_PRELOADED, controller_sceneControllerPreloaded, false, 0, true);
      _controller.initialize(opts);
    }

    private function setScene(scene:IScene):void {
      _scene = scene;

      _controller.addEventListener(SceneMessage.SCENE_CONTROLLER_POSTLOADED, controller_sceneControllerPostloaded, false, 0, true);
      _controller.postLoad();
    }

    private function addSceneToStage():void {
      _scene.addEventListener(SceneMessage.SCENE_CHANGE_FINISH, scene_sceneChangeFinish, false, 0, true);

      _rootDisplay.starlingDisplay.addScene(_scene);
    }

    //
    // Event handlers.
    //

    private function stage_resize(event:Event):void {
      resize(event.target.stageWidth, event.target.stageHeight);
    }

    private function messageBus_requestLastScene(message:SceneMessage):void {
      popSceneRequest();
    }

    private function controller_sceneControllerPreloaded(message:SceneMessage):void {
      setScene(message.scene);
    }

    private function controller_sceneControllerPostloaded(event:SceneMessage):void {
      addSceneToStage();
    }

    private function scene_sceneChangeFinish(message:SceneMessage):void {
      dispatchEvent(new SceneMessage(SceneMessage.SCENE_CHANGE_FINISH));
    }
  }
}