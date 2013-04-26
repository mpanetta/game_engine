package com.core.net
{
  import com.core.error.ErrorBase;
  import com.core.messageBus.MessageBus;

  import flash.events.EventDispatcher;

  import amfSocket.RpcManager;
  import amfSocket.RpcMessage;
  import amfSocket.RpcObject;
  import amfSocket.RpcReceivedMessage;
  import amfSocket.RpcReceivedRequest;
  import amfSocket.events.RpcManagerEvent;

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
    private var _username:String;
    private var _password:String;

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

    public function connect(username:String, password:String):void {
      if(_rpcManager.isConnected() || _rpcManager.isConnecting())
        return;

      _username = username;
      _password = password;

      _rpcManager.connect();
    }

    public function disconnect():void {
      _rpcManager.disconnect();
    }

    public function deliver(rpcObject:RpcObject):void {
      _rpcManager.deliver(rpcObject);
    }

    public function deliverMessage(command:String, params:Object=null):void {
      if(params == null)
        params = {};

      var message:RpcMessage = new RpcMessage(command, params);
      deliver(message);
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

      MessageBus.instance.add(this, NetMessage.CONNECTED);
      MessageBus.instance.add(this, NetMessage.DISCONNECTED);
      MessageBus.instance.add(this, NetMessage.FAILED);
      MessageBus.instance.add(this, NetMessage.RECEIVED_MESSAGE);
      MessageBus.instance.add(this, NetMessage.RECEIVED_REQUEST);
      MessageBus.instance.add(this, NetMessage.PING);
      MessageBus.instance.add(this, NetMessage.AUTH_SUCCESS);
      MessageBus.instance.add(this, NetMessage.AUTH_FAILURE);
    }

    private function unregister():void {
      _rpcManager.removeEventListener(RpcManagerEvent.CONNECTED, rpcManager_connected);
      _rpcManager.removeEventListener(RpcManagerEvent.DISCONNECTED, rpcManager_disconnected);
      _rpcManager.removeEventListener(RpcManagerEvent.FAILED, rpcManager_failed);
      _rpcManager.removeEventListener(RpcManagerEvent.RECEIVED_MESSAGE, rpcManager_receivedMessage);
      _rpcManager.removeEventListener(RpcManagerEvent.RECEIVED_REQUEST, rpcManager_receivedRequest);
      _rpcManager.removeEventListener(RpcManagerEvent.RECEIVED_PING, rpcManager_receivedPing);

      MessageBus.instance.remove(this, NetMessage.CONNECTED);
      MessageBus.instance.remove(this, NetMessage.DISCONNECTED);
      MessageBus.instance.remove(this, NetMessage.FAILED);
      MessageBus.instance.remove(this, NetMessage.RECEIVED_MESSAGE);
      MessageBus.instance.remove(this, NetMessage.RECEIVED_REQUEST);
      MessageBus.instance.remove(this, NetMessage.PING);
      MessageBus.instance.remove(this, NetMessage.AUTH_SUCCESS);
      MessageBus.instance.remove(this, NetMessage.AUTH_FAILURE);
    }

    private function handleRpcReceivedMessage(message:RpcReceivedMessage):void {
      switch(message.command) {
        //
        // Game Engine specific messages should be handled here.
        //
        case 'login_res':
          handleLoginResMessage(message.params);
          break;
        default:
          dispatchEvent(new NetMessage(NetMessage.RECEIVED_MESSAGE, { command:message.command, params:message.params, messageId:message.messageId }));
      }
    }

    private function handleRpcReceivedRequest(request:RpcReceivedRequest):void {
      switch(request.command) {
        //
        // Game Engine specific requests should be handled here.
        //
        default:
          dispatchEvent(new NetMessage(NetMessage.RECEIVED_REQUEST, request));
      }
    }

    private function handleConnected(data:Object):void {
      dispatchEvent(new NetMessage(NetMessage.CONNECTED, data));
      deliverMessage('login_req', { identifier:_username, password:_password });
    }

    //
    // RPC Message Handlers.
    //

    private function handleLoginResMessage(params:Object):void {
      if(params.success) {
        dispatchEvent(new NetMessage(NetMessage.AUTH_SUCCESS));
      }
      else {
        dispatchEvent(new NetMessage(NetMessage.AUTH_FAILURE));
        _rpcManager.disconnect();
      }
    }

    //
    // Event handlers.
    //

    private function rpcManager_connected(event:RpcManagerEvent):void {
      handleConnected(event.data);
    }

    private function rpcManager_disconnected(event:RpcManagerEvent):void {
      dispatchEvent(new NetMessage(NetMessage.DISCONNECTED, event.data));
    }

    private function rpcManager_failed(event:RpcManagerEvent):void {
      dispatchEvent(new NetMessage(NetMessage.FAILED, event.data));
    }

    private function rpcManager_receivedMessage(event:RpcManagerEvent):void {
      handleRpcReceivedMessage(event.data as RpcReceivedMessage);
    }

    private function rpcManager_receivedRequest(event:RpcManagerEvent):void {
      handleRpcReceivedRequest(event.data as RpcReceivedRequest);
    }

    private function rpcManager_receivedPing(event:RpcManagerEvent):void {
      dispatchEvent(new NetMessage(NetMessage.PING, event.data));
    }
  }
}

class SingletonBlocker {}