package com.core.scene
{
  import com.core.dataStructures.Hash;
  import com.core.error.ErrorBase;

  import flash.events.EventDispatcher;

  import feathers.controls.Button;
  import feathers.controls.TextInput;

  import starling.display.DisplayObject;
  import starling.display.Sprite;
  import starling.events.Event;

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
    private var _starlingView:Sprite = new Sprite();
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
    public function get starlingView():Sprite { return _starlingView; }

    public function get width():int { return _width; }
    public function get height():int { return _height; }

    protected function get buttons():Array { return _buttons; }

    //
    // Public methods.
    //

    public function resize(w:int, h:int):void {
      _starlingView.width = w;
      _starlingView.height = h;

      _width = w;
      _height = h;
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
      var layer:Layer = findOrCreateLayer(index);

      return layer.addChild(child);
    }

    private function findOrCreateLayer(index:int):Layer {
      var layer:Layer = _layers[index];
      if(!layer) {
        layer = createLayer(index);
        _layers[index] = layer;
      }

      return layer;
    }

    private function createLayer(index:int):Layer {
      var layer:Layer = new Layer(index);
      _starlingView.addChild(layer);
      _starlingView.sortChildren(function(a:Layer, b:Layer):Boolean { return a.index > b.index; });

      return layer;
    }

    //
    // Private methods.
    //

    private function register():void {
      _starlingView.addEventListener(Event.ADDED_TO_STAGE, starlingView_addedToStage);
    }

    private function unregister():void {
      _starlingView.removeEventListener(Event.ADDED_TO_STAGE, starlingView_addedToStage);
    }

    private function disposeCheck():void {
      if(_disposed)
        throw new SceneError(SceneError.ALREADY_DISPOSED, " SceneBase, count: " + _count);
    }

    private function setDimensions(obj:*, dimensions:Object):void {
      obj.width = dimensions.width;
      obj.height = dimensions.height;
      obj.x = dimensions.x;
      obj.y = dimensions.y;
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
      _starlingView.width = _starlingView.parent.width;
      _starlingView.height = _starlingView.parent.height;
    }

    //
    // Event handlers.
    //

    private function starlingView_addedToStage(event:Event):void {
      setSize();
    }
  }
}