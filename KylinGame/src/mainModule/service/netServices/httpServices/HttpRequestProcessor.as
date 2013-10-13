package mainModule.service.netServices.httpServices
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import mainModule.controller.netCmds.httpCmds.HttpEvent;
	
	import utili.behavior.interfaces.IDispose;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	/**
	 * 处理单个Http请求 
	 * @author Edward
	 * 
	 */	
	public class HttpRequestProcessor extends EventDispatcher implements IDispose
	{
		private var _connection:HttpConnection;
		private var _param:HttpRequestParam;
		private var _contextDispatcher:IEventDispatcher;
		private var _iVirtualTick:uint;
		
		public function HttpRequestProcessor(_url:String,data:HttpRequestParam,dispatcher:IEventDispatcher)
		{
			_param = data;
			_contextDispatcher = dispatcher;
			init(_url);
		}

		private function init(url:String):void
		{
			var arrPost:Array = [];
			
			arrPost.push({requestid:_param.requestId, command:(_param.bInQueue?1:0)});
			
			for each(var data:HttpRequestDataFormat in _param.vecData)
			{
				arrPost.push({request:[data.serverClass,data.serverFunc,data.data]});
			}
			
			_connection = new HttpConnection(url,JSON.stringify(arrPost));
			
			startRequest();
		}
		/**
		 * 发送http请求 
		 * 
		 */		
		public function startRequest():void
		{
			if(_param.bVirtual)
			{
				if(_param.bNeedRespon)
				{
					_iVirtualTick = setTimeout(onVirtualRequest,2000);
					if(_contextDispatcher.hasEventListener(_param.responseEventType))
						_contextDispatcher.dispatchEvent(new HttpEvent(_param.responseEventType,[_param],HttpEvent.Type_RequestBeSend));
				}
				else
					this.dispatchEvent(new Event(Event.COMPLETE));
				return;
			}
			
			_connection.addEventListener(Event.COMPLETE,onRequestComplete);
			_connection.addEventListener(ErrorEvent.ERROR,onRequestError);
			_connection.startConnect();	
			
			if(0 == _param.retryTimes && _contextDispatcher.hasEventListener(_param.responseEventType))
				_contextDispatcher.dispatchEvent(new HttpEvent(_param.responseEventType,[_param],HttpEvent.Type_RequestBeSend));
		}
		
		private function onVirtualRequest():void
		{
			if(_iVirtualTick)
			{
				clearTimeout(_iVirtualTick)
				_iVirtualTick = 0;
			}
			
			processRespon();
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		private function removeListeners():void
		{
			_connection.removeEventListener(Event.COMPLETE,onRequestComplete);
			_connection.removeEventListener(ErrorEvent.ERROR,onRequestError);
		}
		
		private function onRequestComplete(e:Event):void
		{
			removeListeners();
			processRespon();
			dispatchEvent(e);
		}
		/**
		 * 处理服务器返回的数据 
		 * 
		 */		
		private function processRespon():void
		{
			if(_param.bVirtual)
			{
				if(_contextDispatcher.hasEventListener(_param.responseEventType))
					_contextDispatcher.dispatchEvent(new HttpEvent(_param.responseEventType,[[],_param],HttpEvent.Type_Response));
				return;
			}
			
			if(!_connection.responseData)
				return;
			var result:Object = JSON.parse(_connection.responseData);
			if(result && 1 == result[0])
			{
				if(_param.bNeedRespon && _contextDispatcher.hasEventListener(_param.responseEventType))
					_contextDispatcher.dispatchEvent(new HttpEvent(_param.responseEventType,[result[1],_param],HttpEvent.Type_Response));
			}
			else if(_contextDispatcher.hasEventListener(_param.responseEventType))
				_contextDispatcher.dispatchEvent(new HttpEvent(_param.responseEventType,[result?result[0]:null,_param],HttpEvent.Type_ResponseError));
			
		}
		
		private function onRequestError(e:ErrorEvent):void
		{
			removeListeners();
			dispatchEvent(e);
		}
		/**
		 * true:放入队列，按顺序发送，false:立即发送该请求,不进入队列等待 
		 */
		public function get bInQueue():Boolean
		{
			return _param.bInQueue;
		}
		/**
		 * 请求发生io错误时重试的次数 
		 */
		public function get retryTimes():int
		{
			return _param.retryTimes;
		}
		/**
		 * @private
		 */
		public function set retryTimes(i:int):void
		{
			_param.retryTimes = i;
		}
		/**
		 * 响应时触发的事件类型 
		 */
		public function get responseEventType():String
		{
			return _param.responseEventType;
		}
		/**
		 *  请求参数
		 * @return 
		 * 
		 */		
		public function get param():HttpRequestParam
		{
			return _param;
		}
		
		public function dispose():void
		{
			if(_iVirtualTick)
			{
				clearTimeout(_iVirtualTick)
				_iVirtualTick = 0;
			}
			
			_connection.dispose();
			_connection = null;
			
			_param = null;
			
			_contextDispatcher = null;
		}
	}
}