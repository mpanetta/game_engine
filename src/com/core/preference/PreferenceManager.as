package com.core.preference
{
  import com.core.dataStructures.Hash;
  import com.core.dataStructures.Set;
  import com.core.error.ErrorBase;

  import flash.events.NetStatusEvent;
  import flash.net.SharedObject;
  import flash.net.SharedObjectFlushStatus;

  public class PreferenceManager
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private static var _instance:PreferenceManager;
    private var _opts:Object;
    private var _settings:Hash = new Hash();
    private var _objects:Set = new Set();

    //
    // Constructors.
    //

    public function PreferenceManager(sb:SingletonBlocker, opts:Object) {
      _opts = opts;
    }

    public function dispose():void {
      unregister();
    }

    public static function get instance():PreferenceManager {
      if(!_instance)
        throw new ErrorBase(ErrorBase.UNINITIALIZED, "PreferenceManager");

      return _instance;
    }

    public static function initialize(opts):void {
      if(_instance)
        throw new ErrorBase(ErrorBase.MULTIPLE_INITIALIZE, "PreferenceManager");

      _instance = new PreferenceManager(new SingletonBlocker(), opts);
    }

    //
    // Getters and setters.
    //

    //
    // Public methods.
    //

    public function getPreference(key:String, defaultValue:*):* {
      var object:SharedObject = SharedObject.getLocal(key, _opts.localPath);

      return object.data.hasOwnProperty('value') ? object.data.value : defaultValue;
    }

    public function setPreference(key:String, value:Object):void {
      var object:SharedObject = SharedObject.getLocal(key, _opts.localPath);

      object.data.value = value;

      try {
        var result:String = object.flush();
      } catch(error:Error) {
        return;
      }

      if(result) {
        switch(result) {
          case SharedObjectFlushStatus.PENDING:
            _objects.add(object);
            object.addEventListener(NetStatusEvent.NET_STATUS, function(event:NetStatusEvent):void {
              object.removeEventListener(NetStatusEvent.NET_STATUS, arguments.callee);
              if(event.info.code == 'SharedObject.Flush.Failed')

              _objects.remove(object);
            });
            break;
          case SharedObjectFlushStatus.FLUSHED:
            break;
          default:
            throw new Error("Unknown flush status");
            break;
        }
      } else {
      }
    }

    //
    // Private methods.
    //

    private function register():void {

    }

    private function unregister():void {

    }

    //
    // Event handlers.
    //
  }
}

class SingletonBlocker {}