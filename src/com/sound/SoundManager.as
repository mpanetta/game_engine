package com.sound
{
  import com.core.dataStructures.Hash;

  import flash.media.SoundTransform;

  public class SoundManager
  {
    //
    // Constants.
    //

    private static const DEFAULT_MUSIC_ALBUM:String = 'music';
    private static const DEFAULT_FX_VOLUME:Number = 0.7;
    private static const DEFAULT_BKGD_VOLUME:Number = 0.7;

    public static const SOUND_EFFECTS:String = 'sfx';
    public static const SOUND_BACKGROUND:String = 'bkgd';
    public static const SOUND_MUSIC:String   = 'music';

    //
    // Instance variables.
    //

    private static var _instance:SoundManager;

    private var _albums:Hash = new Hash();

    // Volume control variables
    private var _fxTransform:SoundTransform;
    private var _bkgdTransform:SoundTransform;
    private var _fxLastVolume:Number = DEFAULT_FX_VOLUME;
    private var _bkgdLastVolume:Number = DEFAULT_BKGD_VOLUME;
    private var _mute:Boolean = false;

    //
    // Constructors.
    //

    public function SoundManager(sb:SingletonBlocker) {
      // There was a call here to retrieve settings...
      _fxTransform = new SoundTransform();
      _bkgdTransform = new SoundTransform();

      initializeVolume();

      createAlbum(DEFAULT_MUSIC_ALBUM, SOUND_MUSIC);
    }

    public function dispose():void {
      stop();

      for each(var album:Album in _albums.values)
      album.dispose();

      _albums.clear();
    }

    public static function get instance():SoundManager {
      if(!_instance)
        throw new Error('SoundManager has not been initialized');

      return _instance;
    }

    public static function initialize(opts:Object):void {
      if(_instance)
        return;

      _instance = new SoundManager(new SingletonBlocker);
    }

    public static function get initialized():Boolean { return _instance != null; }

    //
    // Getters and setters.
    //

    public function set backgroundVolume(value:Number):void {
      _bkgdTransform.volume = Math.min(1.0, Math.max(0.0, value));

      applyBackgroundVolume();
    }

    public function get backgroundVolume():Number { return _bkgdTransform.volume; }

    public function set fxVolume(value:Number):void {
      _fxTransform.volume = Math.min(1.0, Math.max(0.0, value));

      applyEffectsVolume();
    }
    public function get fxVolume():Number { return _fxTransform.volume; }
    public function get muted():Boolean { return _mute; }

    //
    // Public methods.
    //

    public function mute():void {
      _mute = true;

      muteEffects();
      muteBackground();
    }

    public function unmute():void {
      _mute = false;

      unmuteEffects();
      unmuteBackground();
    }

    public function createAlbum(album:String, category:String=SOUND_EFFECTS):void {
      if(!_albums[album])
        _albums[album] = new Album(album, category);

      (_albums[album] as Album).soundTransform = (category == SOUND_EFFECTS ? _fxTransform : _bkgdTransform);
    }

    public function playTrack(album:String, track:String, playCount:int=1, options:Object=null):void {
      if(!_albums[album])
        createAlbum(album, SOUND_EFFECTS);

      (_albums[album] as Album).play(track, playCount, options);
    }

    public function playLoop(album:String, track:String, options:Object=null):void {
      playTrack(album, track, int.MAX_VALUE, options);
    }

    public function playOver(album:String, track:String, options:Object=null):void {
      stop(album, track, options);

      playTrack(album, track, 1, options);
    }

    public function stop(album:String=null, track:String=null, options:Object=null):void {
      if(!album) {
        for each(var a:Album in _albums.values) {
          a.stop(null, options);
        }
      } else if(_albums[album]) {
        (_albums[album] as Album).stop(track, options)
      } else
        throw new Error('The album "' + album + '" was not found');
    }

    public function removeAlbum(album:String):void {
      if(_albums[album]) {
        _albums[album].dispose();
        delete _albums[album];
      } else
        throw new Error('The album "' + album + '" was not found');
    }

    public function muteEffects():void {
      _fxLastVolume = fxVolume;
      fxVolume = 0;
    }

    public function muteBackground():void {
      _bkgdLastVolume = backgroundVolume;
      backgroundVolume = 0;
    }

    public function unmuteEffects():void {
      fxVolume = _fxLastVolume == 0 ? DEFAULT_FX_VOLUME : _fxLastVolume;
    }

    public function unmuteBackground():void {
      backgroundVolume = _bkgdLastVolume == 0 ? DEFAULT_BKGD_VOLUME : _bkgdLastVolume;
    }

    public function playMusic(track:String, options:Object=null):void {
      playLoop(DEFAULT_MUSIC_ALBUM, track, options);
    }

    public function stopMusic(options:Object=null):void {
      stop(DEFAULT_MUSIC_ALBUM, null, options);
    }

    //
    // Private methods.
    //

    private function applyCategoryTransform(category:String, transform:SoundTransform):void {
      for each(var album:Album in _albums.values) {
        if(album.category == category)
          album.soundTransform = transform;
      }
    }

    private function applyBackgroundVolume():void {
      applyCategoryTransform(SOUND_BACKGROUND, _bkgdTransform);
      applyCategoryTransform(SOUND_MUSIC, _bkgdTransform);
    }

    private function applyEffectsVolume():void {
      applyCategoryTransform(SOUND_EFFECTS, _fxTransform);
    }

    private function initializeVolume():void {
      fxVolume = DEFAULT_FX_VOLUME;
      backgroundVolume = DEFAULT_BKGD_VOLUME;
    }
  }
}

class SingletonBlocker {}