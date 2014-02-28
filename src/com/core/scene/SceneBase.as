package com.core.scene
{
  import com.core.dataStructures.Hash;
  import com.core.error.ErrorBase;
  import com.core.namespaces.scene_message;
  import com.engine.Engine;
  import com.util.eventTypesFor;
  import com.util.methodForEvent;

  import flash.events.EventDispatcher;

  import feathers.controls.Button;
  import feathers.controls.TextInput;

  import starling.display.DisplayObject;
  import starling.events.Event;

  use namespace scene_message;

  public class SceneBase extends EventDispatcher implements IScene
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private static var _count:int = 0;

    private var _disposed:Boolean = false;
    private var _data:Object;
    private var _starlingContainer:StarlingContainer = new StarlingContainer();
    private var _flashContainer:FlashContainer = new FlashContainer();
    private var _listeners:Hash = new Hash();
    private var _buttons:Array = [];
    private var _width:int;
    private var _height:int;
    private var _layers:Hash = new Hash();

    //
    // Constructors.
    //

    public function SceneBase(data:Object) {
      _data:Object
      _count++;

      register();
    }

    public function dispose():void {
      disposeCheck();
      unregister();

      clearLayers();
      clearUIListeners();

      _buttons = null;
      _count--;
    }

    //
    // Getters and setters.
    //

    public function get disposed():Boolean { return _disposed; }
    public function get starlingContainer():StarlingContainer { return _starlingContainer; }
    public function get flashContainer():FlashContainer { return _flashContainer; }

    protected function get buttons():Array { return _buttons; }
    protected function get appWidth():Number { return Engine.instance.appWidth; }
    protected function get appHeight():Number { return Engine.instance.appHeight; }

    //
    // Public methods.
    //

    public function resize(w:Number, h:Number):void {
    }

    public function setScene():void {
      load();
    }

    //
    // Protected methods.
    //

    protected function load():void {
      throw new ErrorBase(ErrorBase.ABSTRACT_METHOD, "SceneBase::load");
    }

    protected function complete():void {
      dispatchEvent(new SceneMessage(SceneMessage.SCENE_CHANGE_FINISH, {}));
    }

    protected function createButton(handler:Function, index:int, opts:Object):Button {
      var button:Button = new Button();
      _buttons.push(button);

      addChild(button, index);
      setDimensions(button, opts.dimensions);

      button.label = opts.hasOwnProperty('label') ? opts.label : "";
      if(handler)
        addUIListener(button, Event.TRIGGERED, handler);

      return button;
    }

    protected function createTextField(index:int, opts:Object):TextInput {
      var field:TextInput = addChild(new TextInput(), index) as TextInput;
      setDimensions(field, opts.dimensions);

      field.textEditorProperties.textAlign = "center";
      field.textEditorProperties.maxChars = 255;

      if(opts.text) field.textEditorProperties.text = opts.text;

      return field;
    }

    protected function addChild(child:DisplayObject, index:int=1):DisplayObject {
      var layer:StarlingLayer = findOrCreateLayer(index);

      return layer.addChild(child);
    }

    protected function registerMessageClass(messageClass:Class, target:ViewBase, targetName:String):void {
      var eventTypes:Array = eventTypesFor(messageClass);
      var listenerName:String = "";
      for each(var type:String in eventTypes) {
        listenerName = targetName + '_' + methodForEvent(type);
        try {
          target.addListener((messageClass as Object)[type], (this as Object)[listenerName]);
        } catch(error:Error) {
        }
      }
    }

    protected function unregisterMessageClass(messageClass, target:ViewBase, targetName:String):void {
      var eventTypes:Array = eventTypesFor(messageClass);
      var listenerName:String = "";
      for each(var type:String in eventTypes) {
        listenerName = targetName + '_' + methodForEvent(type);

        try {
          target.removeListener((messageClass as Object)[type], (this as Object)[listenerName]);
        } catch(error:Error) {
        }
      }
    }

    //
    // Private methods.
    //

    private function register():void {
      _starlingContainer.addEventListener(Event.ADDED_TO_STAGE, starlingView_addedToStage);
    }

    private function unregister():void {
      _starlingContainer.removeEventListener(Event.ADDED_TO_STAGE, starlingView_addedToStage);
    }

    private function disposeCheck():void {
      if(_disposed)
        throw new SceneError(SceneError.ALREADY_DISPOSED, " SceneBase, count: " + _count);
    }

    private function setDimensions(obj:*, dimensions:Object):void {
      obj.width = dimensions.width;
      obj.height = dimensions.height;
      obj.x = dimensions.x ? dimensions.x : 0;
      obj.y = dimensions.y ? dimensions.y : 0;
    }

    private function addUIListener(target:starling.events.EventDispatcher, type:String, listener:Function):void {
      target.addEventListener(type, listener);
      if(!_listeners.hasOwnProperty(target))
        _listeners[target] = []

      _listeners[target].push({ type:type, listener:listener });
    }

    private function clearLayers():void {
      _layers.clear();
      _layers = null;
    }

    private function clearUIListeners():void {
      for(var target:starling.events.EventDispatcher in _listeners) {
        for each(var listener:Object in _listeners[target]) {
          target.removeEventListener(listener.type, listener.listener);
        }
      }

      _listeners.clear();
      _listeners = null;
    }

    private function setSize():void {
    }

    private function findOrCreateLayer(index:int):StarlingLayer {
      var layer:StarlingLayer = _layers[index];
      if(!layer) {
        layer = createLayer(index);
        _layers[index] = layer;
      }

      return layer;
    }

    private function createLayer(index:int):StarlingLayer {
      var layer:StarlingLayer = new StarlingLayer(index);
      _starlingContainer.addChild(layer);
      _starlingContainer.sortChildren(function(a:StarlingLayer, b:StarlingLayer):Boolean { return a.index > b.index; });

      return layer;
    }


    //
    // Event handlers.
    //

    private function starlingView_addedToStage(event:Event):void {
      setSize();
    }
  }
}