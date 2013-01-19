package com.core.fsm
{
  import com.core.dataStructures.Set;
  import com.core.error.ErrorBase;

  import flash.utils.Dictionary;

  public class StateMachine
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private static var _references:int = 0;

    private var _disposed:Boolean = false;
    private var _state:String;
    private var _transitions:Dictionary = new Dictionary();

    //
    // Constructors.
    //

    public function StateMachine(startState:String) {
      _references++;

      _state = startState;
    }

    public function dispose():void {
      if(_disposed)
        throw new ErrorBase(ErrorBase.ALREADY_DISPOSED, "StateMachine");

      _references--;
      _transitions = null;
      _state = null;

      cleanupTransitions();
    }

    //
    // Getters and setters.
    //

    public static function get referenceCount():int { return _references; }
    public function get state():String { return _state; }


    //
    // Public methods.
    //

    public function addTransition(event:String, startState:String, endState:String):void {
      if(!_transitions[startState]) createState(startState);
      if(!_transitions[endState]) createState(endState);

      var transition:Object = _transitions[startState];

      if(transition.events.event)
        throw new FsmError(FsmError.ALREADY_REGISTERED_TRANSITION, "event: " + event + ", startState: " + startState + ", endState: endState");

      transition.events.event = endState;
    }

    public function registerCallback(state:String, func:Function):void {
      var transition:Object = _transitions[state];
      if(!transition)
        transition = createState(state);

      var callbacks:Set = transition.callbacks;
      if(callbacks.contains(func))
        throw new FsmError(FsmError.CALLBACK_ALREADY_REGISTERED, "state: " + state);

      callbacks.add(func);
    }

    public function trigger(event:String):void {
      var transition:Object = _transitions[_state];
      if(!transition)
        throw new FsmError(FsmError.BAD_STATE, "state: " + state);

      var toState:String = transition.events.event;
      if(!toState)
        throw new FsmError(FsmError.NO_EVENT, "state: " + state + " event: " + event);

      _state = toState;

      executeCallbacks(transition.callbacks.values);
    }

    //
    // Private methods.
    //

    private function createState(state:String):Object {
      var transition:Object = { events:{}, callbacks:new Set() };
      _transitions[state] = transition;

      return transition;
    }

    private function executeCallbacks(callbacks:Array):void {
      for each(var callback:Function in callbacks) {
        callback.apply();
      }
    }

    private function cleanupTransitions():void {
      if(!_transitions) return;

      for each(var key:String in _transitions) {
        var transition:Object = _transitions[key];

        (transition.callbacks as Set).clear();
        transition.callbacks = null;
        transition.events = null;

        delete _transitions[key];
      }
    }

    //
    // Event handlers.
    //
  }
}