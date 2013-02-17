package com.core.net
{
  import amfSocket.RpcManager;
  import amfSocket.RpcObject;
  import amfSocket.RpcReceivedMessage;
  import amfSocket.RpcReceivedRequest;
  import amfSocket.events.RpcManagerEvent;

  import com.core.error.ErrorBase;

  import flash.events.EventDispatcher;

  public class NetManager extends EventDispatcher
  {
    //
    // Constants.
    //

    //
    // Instance variables.
    //

    private static var _instance:NetManager;
    private var _options:Object;
    private var _rpcManager:RpcManager;

    //
    //  Constructors.
    //

    public function NetManager(sb:SingletonBlocker, host:String, port:int, options:Object) {
      super();

      _options = options;

      _rpcManager = new RpcManager(host, port);

      register();
    }

    //
    // Singleton.
    //

    public static function initialize(host:String, port:int, options:Object=null):void {
      _instance = new NetManager(new SingletonBlocker, host, port, options);
    }

    public static function get instance():NetManager {
      if(_instance)
        return _instance;

      throw new ErrorBase(ErrorBase.UNINITIALIZED, "");
    }

    //
    // Getters and setters.
    //

    //
    // Public methods.
    //

    public function deliver(rpcObject:RpcObject):void {
      _rpcManager.deliver(rpcObject);
    }

    public function connect():void {
      _rpcManager.connect();
    }

    //
    // Private methods.
    //

    private function register():void {
      _rpcManager.addEventListener(RpcManagerEvent.CONNECTED, rpcManager_connected);
      _rpcManager.addEventListener(RpcManagerEvent.DISCONNECTED, rpcManager_disconnected);
      _rpcManager.addEventListener(RpcManagerEvent.FAILED, rpcManager_failed);
      _rpcManager.addEventListener(RpcManagerEvent.RECEIVED_MESSAGE, rpcManager_receivedMessage);
      _rpcManager.addEventListener(RpcManagerEvent.RECEIVED_REQUEST, rpcManager_receivedRequest);
      _rpcManager.addEventListener(RpcManagerEvent.RECEIVED_PING, rpcManager_receivedPing);
    }

    private function unregister():void {
      _rpcManager.removeEventListener(RpcManagerEvent.CONNECTED, rpcManager_connected);
      _rpcManager.removeEventListener(RpcManagerEvent.DISCONNECTED, rpcManager_disconnected);
      _rpcManager.removeEventListener(RpcManagerEvent.FAILED, rpcManager_failed);
      _rpcManager.removeEventListener(RpcManagerEvent.RECEIVED_MESSAGE, rpcManager_receivedMessage);
      _rpcManager.removeEventListener(RpcManagerEvent.RECEIVED_REQUEST, rpcManager_receivedRequest);
      _rpcManager.removeEventListener(RpcManagerEvent.RECEIVED_PING, rpcManager_receivedPing);
    }

    private function processMessage(message:RpcReceivedMessage):void {
      switch(message.command) {
        //
        // Game Engine specific messages should be handled here.
        //

        default:
          dispatchEvent(new NetEvent(NetEvent.RECEIVED_MESSAGE, message));
      }
    }

    private function processRequest(request:RpcReceivedRequest):void {
      switch(request.command) {
        //
        // Game Engine specific requests should be handled here.
        //

        default:
          dispatchEvent(new NetEvent(NetEvent.RECEIVED_REQUEST, request));
      }
    }

    //
    // Event handlers.
    //

    private function rpcManager_connected(event:RpcManagerEvent):void {
      dispatchEvent(new NetEvent(NetEvent.CONNECTED, event.data));
    }

    private function rpcManager_disconnected(event:RpcManagerEvent):void {
      dispatchEvent(new NetEvent(NetEvent.DISCONNECTED, event.data));
    }

    private function rpcManager_failed(event:RpcManagerEvent):void {
      dispatchEvent(new NetEvent(NetEvent.FAILED, event.data));
    }

    private function rpcManager_receivedMessage(event:RpcManagerEvent):void {
      processMessage(event.data as RpcReceivedMessage);
    }

    private function rpcManager_receivedRequest(event:RpcManagerEvent):void {
      processRequest(event.data as RpcReceivedRequest);
    }

    private function rpcManager_receivedPing(event:RpcManagerEvent):void {
      dispatchEvent(new NetEvent(NetEvent.PING, event.data));
    }
  }
}

class SingletonBlocker {}