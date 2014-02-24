package com.sound
{
  import flash.events.Event;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.media.SoundTransform;

  import starling.animation.Transitions;
  import starling.core.Starling;

  public class Track
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private var _sound:Sound;
    private var _channel:SoundChannel;
    private var _isPlaying:Boolean = false;

    //
    // Constructors.
    //

    public function Track(sound:Sound) {
      _sound = sound
    }

    public function dispose():void {
      stop();

      _sound = null;
    }

    //
    // Getters and setters.
    //

    public function get isPlaying():Boolean { return _isPlaying; }

    public function set soundTransform(value:SoundTransform):void {
      if(_channel)
        _channel.soundTransform = value;
    }

    //
    // Public methods.
    //

    public function play(playCount:int=1, soundTransform:SoundTransform=null, options:Object=null):void {
      if(isPlaying || !_sound)
        return;

      _channel = _sound.play(0, playCount, soundTransform);
      if(!_channel)
        return;

      _channel.addEventListener(Event.SOUND_COMPLETE, soundCompleteHandler);
      _isPlaying = true;

      if(options) {
        if(options.hasOwnProperty('fadeIn') && options.fadeIn)
          startFadeIn(options);
      }
    }

    public function stop(options:Object=null):void {
      if(!isPlaying)
        return;

      if(options) {
        if(options.hasOwnProperty('fadeOut') && options.fadeOut) {
          startFadeOut(options);
          return;
        }
      }

      stopChannel();
    }

    //
    // Private methods.
    //

    private function stopChannel():void {
      if(!isPlaying)
        return;

      _channel.stop();
      _channel = null;

      _isPlaying = false;
    }

    private function startFadeIn(options:Object):void {
      var volume:Number = _channel.soundTransform.volume;
      _channel.soundTransform.volume = 0;

      var length:Number = options.hasOwnProperty('fadeLength') ? options.fadeLength : 1;

      Starling.juggler.tween(_channel, length, { transition:Transitions.EASE_IN_OUT, repeatCount:1, onComplete:tween_completeFadeIn, 'volume':volume });
    }

    private function startFadeOut(options:Object):void {
      var length:Number = options.hasOwnProperty('fadeLength') ? options.fadeLength : 1;

      Starling.juggler.tween(_channel, length, { transition:Transitions.EASE_IN_OUT, repeatCount:1, onComplete:tween_completeFadeOut, 'volume':0 });
    }

    //
    // Event handlers.
    //

    private function soundCompleteHandler(event:Event):void {
      stopChannel();
    }

    private function tween_completeFadeIn():void {
    }

    private function tween_completeFadeOut():void {
      stopChannel();
    }
  }
}