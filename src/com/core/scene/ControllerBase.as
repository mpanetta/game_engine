package com.core.scene
{
  import avmplus.getQualifiedClassName;

  import com.core.error.ErrorBase;
  import com.core.operationQueue.OperationQueue;

  import flash.display.Scene;
  import flash.events.EventDispatcher;
  import flash.utils.getDefinitionByName;

  public class ControllerBase extends EventDispatcher implements IController
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private static var _count:int = 0;

    private var _initialized:Boolean = false;
    private var _disposed:Boolean = false;
    private var _data:Object;
    private var _scene:IScene;

    //
    // Constructors.
    //

    public function ControllerBase() {
      _count++;

      register();

      super();
    }

    public function dispose():void {
      disposeCheck();
      unregister();

      _count--;
    }

    //
    // Getters and setters.
    //

    public function get disposed():Boolean { return _disposed; }
    public function get initialized():Boolean { return _initialized; }
    public function get className():String { return getQualifiedClassName(this); }

    //
    // Public methods.
    //

    public function initialize(data:Object):void {
      _data = data;

      sceneFor(className);
      startPreloadQueue();
    }

    //
    // Protected methods.
    //

    protected function startPreloadQueue():void {
      throw new ErrorBase(ErrorBase.ABSTRACT_METHOD, "ControllerBase::startPreloadQueue");
    }

    protected function complete():void {
      dispatchEvent(new SceneMessage(SceneMessage.SCENE_CONTROLLER_PRELOADED, { scene:_scene }));
    }

    //
    // Private methods.
    //

    private function register():void {

    }

    private function unregister():void {

    }

    private function sceneFor(viewClass:String):void {
      var className:String = parseClassName(viewClass);
      var sceneClass:Class = getDefinitionByName(className) as Class;

      if(!sceneClass)
        throw new SceneError(SceneError.INVALID_SCENE_CLASS, " for controller class: " + viewClass);

      _scene = new sceneClass(_data);
    }


    private function parseClassName(viewClass:String):String {
      var base:String;

      if(viewClass.match("::"))
        base = viewClass.substr(viewClass.indexOf("::"));
      else
        base = "::" + viewClass;

      return "com.scenes" + base.split("Controller")[0] + "Scene";
    }


    private function disposeCheck():void {
      if(_disposed)
        throw new SceneError(SceneError.ALREADY_DISPOSED, " ControllerBase, count: " + _count);
    }

    //
    // Event handlers.
    //
  }
}