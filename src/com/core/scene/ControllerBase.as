namespace scene;

package com.core.scene
{
  import com.core.error.ErrorBase;
  import com.core.namespaces.scene_api;
  import com.core.namespaces.scene_message;
  import com.util.eventTypesFor;
  import com.util.methodForEvent;

  import flash.events.EventDispatcher;
  import flash.events.IEventDispatcher;
  import flash.utils.getDefinitionByName;

  import avmplus.getQualifiedClassName;

  use namespace scene_message;
  use namespace scene_api;

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
    private var _viewClass:String;

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

    protected function get scene():IScene { return _scene; }

    //
    // Public methods.
    //

    public function initialize(data:Object):void {
      _data = data;

      sceneFor(className);
      startPreloadQueue();
    }

    public function postLoad():void {
      postComplete();
    }

    //
    // Protected methods.
    //

    protected function startPreloadQueue():void {
      throw new ErrorBase(ErrorBase.ABSTRACT_METHOD, "ControllerBase::startPreloadQueue");
    }

    protected function preComplete():void {
      dispatchEvent(new SceneMessage(SceneMessage.SCENE_CONTROLLER_PRELOADED, { scene:_scene }));
    }

    protected function postComplete():void {
      dispatchEvent(new SceneMessage(SceneMessage.SCENE_CONTROLLER_POSTLOADED, { scene:_scene }));
    }

    protected function registerMessageClass(messageClass:Class, target:IEventDispatcher, targetName:String):void {
      var eventTypes:Array = eventTypesFor(messageClass);
      var listenerName:String = "";
      for each(var type:String in eventTypes) {
        listenerName = targetName + '_' + methodForEvent(type);
        try {
          target.addEventListener((messageClass as Object)[type], (this as Object)[listenerName]);
        } catch(error:Error) {
        }
      }
    }

    protected function unregisterMessageClass(messageClass, target:IEventDispatcher, targetName:String):void {
      var eventTypes:Array = eventTypesFor(messageClass);
      var listenerName:String = "";
      for each(var type:String in eventTypes) {
        listenerName = targetName + '_' + methodForEvent(type);

        try {
          target.removeEventListener((messageClass as Object)[type], (this as Object)[listenerName]);
        } catch(error:Error) {
        }
      }
    }

    //
    // Private methods.
    //

    private function register():void {
    }

    private function unregister():void {
      registerSceneMessageClass(className, _scene, false);
    }

    private function sceneFor(viewClass:String):void {
      var className:String = parseController(viewClass);
      var sceneClass:Class = getDefinitionByName(className) as Class;

      if(!sceneClass)
        throw new SceneError(SceneError.INVALID_SCENE_CLASS, " for view class: " + viewClass);

      _scene = new sceneClass(_data);
      registerSceneMessageClass(viewClass, _scene, true);
    }

    private function registerSceneMessageClass(viewClass:String, scene:IScene, add:Boolean):void {
      var className:String = parseMessage(viewClass);
      try {
        var messageClass:Class = getDefinitionByName(className) as Class;
      } catch(ReferenceError) {
        return;
      }

      if(!messageClass)
        throw new SceneError(SceneError.INVALID_MESSAGE_CLASS, " for view class: " + viewClass);

      add ? registerMessageClass(messageClass, scene, 'scene') : unregisterMessageClass(messageClass, scene, 'scene');
    }

    private function parseController(viewClass:String):String {
      var base:String;

      if(viewClass.match("::"))
        base = viewClass.substr(viewClass.indexOf("::"));
      else
        base = "::" + viewClass;

      return "com.scenes" + base.split("Controller")[0] + "Scene";
    }

    private function parseMessage(viewClass:String):String {
      var base:String;

      if(viewClass.match("::"))
        base = viewClass.substr(viewClass.indexOf("::"));
      else
        base = "::" + viewClass;

      return "com.events" + base.split("Controller")[0] + "Message";
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