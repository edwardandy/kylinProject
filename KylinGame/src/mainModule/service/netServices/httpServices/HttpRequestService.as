package mainModule.service.netServices.httpServices
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import mainModule.controller.netCmds.httpCmds.HttpEvent;
	import mainModule.model.gameConstAndVar.FlashVarsModel;
	import mainModule.service.netServices.httpServices.interfaces.IHttpRequestService;

	/**
	 * 请求Http服务器操作
	 * @author Edward
	 * 
	 */	
	public class HttpRequestService extends KylinActor implements IHttpRequestService
	{
		[Inject]
		public var flashVars:FlashVarsModel;
		
		private var _url:String;
		private var _requestId:Number;
		/**
		 * 请求队列 
		 */		
		private var _vecRequest:Vector.<HttpRequestParam>;
		/**
		 * 队列中是否正在请求中 
		 */		
		private var _isRequesting:Boolean;
		/**
		 * 请求发生io错误时最大的重试次数 
		 */		
		private var _maxTry:int;
		
		public function HttpRequestService()
		{
			super();
		}
		
		[PostConstruct]
		public function init():void
		{
			_url = flashVars.PHP_GATEWAY + "/Comd/" + 
				"&signed_request=" + flashVars.SIGNED_REQUEST + 
				"&url=" + flashVars.URL + 
				"&token=" + flashVars.TOKEN + 
				"&cdnurl=" + flashVars.FLASH_PATH +
				"&dataurl=" + flashVars.PHP_GATEWAY + 
				"&fcuid=" + flashVars.FACEBOOK_ID;
			
			_requestId = (new Date).time;
			
			_vecRequest = new Vector.<HttpRequestParam>;
			
			_maxTry = 3;
		}
		
		public function requestServer(param:HttpRequestParam):void
		{
			param.requestId = _requestId++;
			
			if(param.bInQueue)
			{
				_vecRequest.push(param);
				checkNextRequest();
			}
			else
			{
				processEachRequest(param);
			}
		}
		
		private function checkNextRequest():void
		{
			if(!_isRequesting && _vecRequest.length>0)
			{
				_isRequesting = true;
				processEachRequest(_vecRequest[0]);
			}
		}
		
		private function processEachRequest(param:HttpRequestParam):void
		{
			var request:HttpRequestProcessor = new HttpRequestProcessor(_url,param,eventDispatcher);
			request.addEventListener(Event.COMPLETE,onRequestComplete);
			request.addEventListener(ErrorEvent.ERROR,onRequestError);
		}
		
		private function onRequestComplete(e:Event):void
		{
			var request:HttpRequestProcessor = e.currentTarget as HttpRequestProcessor;
			request.removeEventListener(Event.COMPLETE,onRequestComplete);
			request.removeEventListener(ErrorEvent.ERROR,onRequestError);
			
			if(request.bInQueue)
			{
				_isRequesting = false;
				_vecRequest.shift().dispose();
				checkNextRequest();
			}
		}
		
		private function onRequestError(e:ErrorEvent):void
		{
			var request:HttpRequestProcessor = e.currentTarget as HttpRequestProcessor;
			request.removeEventListener(Event.COMPLETE,onRequestComplete);
			request.removeEventListener(ErrorEvent.ERROR,onRequestError);
			
			if(request.retryTimes < _maxTry)
			{
				request.retryTimes++;
				request.startRequest();
				request.addEventListener(Event.COMPLETE,onRequestComplete);
				request.addEventListener(ErrorEvent.ERROR,onRequestError);	
			}
			else 
			{
				if(request.bInQueue)
				{
					_isRequesting = false;
					_vecRequest.shift();
					checkNextRequest();
				}
				dispatch(new HttpEvent(request.responseEventType,[e.text,request.param],HttpEvent.Type_RequestError));
				request.dispose();
			}
		}
	}
}