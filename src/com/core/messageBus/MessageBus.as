package com.core.messageBus
{
  import com.core.dataStructures.Hash;
  import com.core.dataStructures.Set;
  import com.core.error.ErrorBase;

  import flash.events.EventDispatcher;
  import flash.utils.describeType;

  public class MessageBus extends EventDispatcher
  {
    //
    // Instance Variables.
    //

    private static var _instance:MessageBus;

    private var _targets:Hash = new Hash();
    private var _options:Object;

    //
    //  Constructors.
    //

    public function MessageBus(sb:SingletonBlocker, options:Object) {
      _options = options;
    }

    //
    // Singleton.
    //

    public static function initialize(options:Object=null):void {
      _instance = new MessageBus(new SingletonBlocker, options ? options : {});
    }

    public static function get instance():MessageBus {
      if(_instance)
        return _instance;

      throw new ErrorBase(ErrorBase.UNINITIALIZED, "");
    }

    //
    // Public Methods.
    //

    public static function addListener(type:String, handler:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
      _instance.addEventListener(type, handler, useCapture, priority, useWeakReference);
    }

    public static function removeListener(type:String, listener:Function, useCapture:Boolean=false):void {
      _instance.removeEventListener(type, listener, useCapture);
    }

    public static function add(target:EventDispatcher, eventType:String, weak:Boolean=false):void {
      _instance.add(target, eventType, weak);
    }

    public function add(target:EventDispatcher, eventType:String, weak:Boolean=false):void {
      if(checkTarget(target, eventType))
        throw new MessageError(MessageError.MULTIPLE_LISTENER, target.toString() + ":" + eventType);

      target.addEventListener(eventType, broadcast, false, 0, weak);

      if(weak == false)
        _targets[target] == null ? _targets[target] = new Set([eventType]) : _targets[target].add(eventType);
    }

    public static function addForClass(target:EventDispatcher, eventClass:Class, weak:Boolean=false):void {
      _instance.addForClass(target, eventClass, weak);
    }

    public function addForClass(target:EventDispatcher, eventClass:Class, weak:Boolean=false):void {
      var constants:Array = eventTypesFor(eventClass);

      for each (var type:String in constants) {
        MessageBus.instance.add(target, eventClass[type], weak);
      }
    }

    public static function remove(target:EventDispatcher, eventType:String):void {
      _instance.remove(target, eventType);
    }

    public function remove(target:EventDispatcher, eventType:String):void {
      if(checkTarget(target, eventType) == false)
        throw new MessageError(MessageError.MISSING_LISTENER, "event type: " + eventType);

      target.removeEventListener(eventType, broadcast);
      _targets[target].remove(eventType);

      if(_targets[target].isEmpty)
        delete _targets[target];
    }

    public static function removeForClass(target:EventDispatcher, eventClass:Class):void {
      _instance.removeForClass(target, eventClass);
    }

    public function removeForClass(target:EventDispatcher, eventClass:Class):void {
      var constants:Array = eventTypesFor(eventClass);

      for each(var type:String in constants)
        remove(target, eventClass[type]);
    }

    //
    // Private methods.
    //

    private function checkTarget(target:EventDispatcher, eventType:String):Boolean {
      var types:Set = _targets[target];

      if(types == null) return false;
      if(types.contains(eventType)) return true;

      return false;
    }

    private function broadcast(event:*):void {
      if(hasEventListener(event.type))
        dispatchEvent(event);
    }

    private function eventTypesFor(type:Class):Array {
      var result:Array = [];

      for each(var constant:XML in describeType(type).constant)
        result.push(constant.@name.toString());

      return result;
    }
  }
}

class SingletonBlocker {}