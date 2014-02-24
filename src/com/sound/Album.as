package com.sound
{
  import com.core.dataStructures.Hash;
  import com.engine.Engine;

  import flash.media.Sound;
  import flash.media.SoundTransform;

  public class Album
  {

    //
    // Instance variables.
    //

    private var _tracks:Hash = new Hash();
    private var _category:String;
    private var _name:String;
    private var _soundTransform:SoundTransform;
    private var _stopped:Boolean = false;

    //
    // Constructors.
    //

    public function Album(name:String, category:String) {
      _category = category;
      _name = name;
      _soundTransform = null;
    }

    public function dispose():void {
      stopped = true;

      for each(var track:Track in _tracks) {
        track.dispose();
      }
      _tracks.clear();
    }

    //
    // Public methods.
    //

    public function get name():String { return _name; }
    public function get category():String { return _category; }

    public function set soundTransform(value:SoundTransform):void {
      _soundTransform = value;

      for each(var t:Track in _tracks.values) {
        t.soundTransform = value;
      }
    }

    public function set stopped(value:Boolean):void {
      _stopped = value;
      if(stopped)
        stop(null);
    }
    public function get stopped():Boolean { return _stopped; }

    //
    // Public methods.
    //

    public function isPlaying(track:String=null):Boolean {
      if(track) {
        if(_tracks[track])
          return (_tracks[track] as Track).isPlaying;
        else
          return false;
      } else {
        for each(var t:Track in _tracks.values) {
          if(t.isPlaying)
            return true;
        }
      }

      return false;
    }

    public function play(track:String, playCount:int=1, options:Object=null):void {
      if(isPlaying(track) || stopped)
        return;
      else {
        if(_tracks[track] == null)
          loadAsset(track, function():void { play(track, playCount, options); });
        else
          (_tracks[track] as Track).play(playCount, _soundTransform, options);
      }
    }

    public function playOver(track:String, playCount:int=1, options:Object=null):void  {
      if(isPlaying(track))
        stop(null, options);

      play(track, playCount, options);
    }

    public function stop(track:String=null, options:Object=null):void {
      if(!track) {
        for each(var t:Track in _tracks.values) {
          t.stop(options);
        }
      } else if(_tracks[track]) {
        (_tracks[track] as Track).stop(options)
      } else
        throw new Error('The track "' + track + '" is not known to be in album ' + name);
    }

    //
    // Private Methods.
    //

    private function loadAsset(asset:String, callback:Function=null):void {
      var sound:Sound = Engine.getAsset(asset);
      loadedMP3(asset, sound, callback);
    }

    private function loadedMP3(asset:String, sound:Sound, callback:Function=null):void {
      if(!sound) return;

      _tracks[asset] = new Track(sound);
      if(callback != null) callback();
    }

    private function failedToLoadMP3():void {
    }

    //
    // Event handlers.
    //
  }
}