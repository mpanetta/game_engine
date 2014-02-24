package com.core.preference
{
  import com.core.error.ErrorBase;

  import flash.net.SharedObject;

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