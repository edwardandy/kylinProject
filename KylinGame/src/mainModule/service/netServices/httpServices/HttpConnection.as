package mainModule.service.netServices.httpServices
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.ByteArray;
	
	import utili.behavior.interfaces.IDispose;
	
	[Event(name="complete", type="flash.events.Event")]
	[Event(name="error", type="flash.events.ErrorEvent")]
	
	public class HttpConnection extends EventDispatcher implements IDispose
	{
		private var _request:URLRequest;
		private var _loader:URLLoader;
	
		private var _byteData:ByteArray;
		private var _responseData:String;
		
		public function HttpConnection(url:String,data:String)
		{
			init();
			_request.url = url;
			requestData = data;
		}
		
		/**
		 * 发送请求的数据 (Json格式)
		 * @param data
		 * 
		 */		
		private function set requestData(data:String):void
		{
			_byteData.clear();
			_byteData.writeUTF(data);
			_byteData.compress();
		}
		/**
		 * 返回时收到的数据 (Json格式)
		 * @return 
		 * 
		 */		
		public function get responseData():String
		{
			return _responseData;
		}

		private function init():void
		{
			_byteData = new ByteArray;
			
			_request = new URLRequest;
			_request.contentType = "application/octet-stream";
			_request.method = URLRequestMethod.POST;
			_request.data = _byteData;
			
			_loader = new URLLoader;
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
		}
		/**
		 * 开始请求 
		 * 
		 */		
		public function startConnect():void
		{
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loader.addEventListener(IOErrorEvent.IO_ERROR,onIoError);
			_loader.addEventListener(Event.COMPLETE, onComplete);
			_loader.load(_request);
		}
		
		private function onComplete(e:Event):void
		{
			if(URLLoaderDataFormat.TEXT == _loader.dataFormat)
				_responseData = _loader.data;
			else if(URLLoaderDataFormat.BINARY == _loader.dataFormat)
			{
				(_loader.data as ByteArray).uncompress();
				_responseData = (_loader.data as ByteArray).toString();
			}
			else
			{
				removeListeners();
				dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"HttpConnection RecieveDataFormat Error"));
				return;
			}
			
			removeListeners();
			dispatchEvent(e);
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			removeListeners();
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"HttpConnection SecurityError: " + e.text,e.errorID));
		}
		
		private function onIoError(e:IOErrorEvent):void 
		{
			removeListeners();
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,"HttpConnection IOError: " + e.text,e.errorID));
		}
		
		private function removeListeners():void
		{
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
			_loader.removeEventListener(IOErrorEvent.IO_ERROR,onIoError);
			_loader.removeEventListener(Event.COMPLETE, onComplete);
		}
		
		public function dispose():void
		{
			_request = null;
			_loader = null;
			_byteData.clear();
			_byteData = null;
		}
	}
}