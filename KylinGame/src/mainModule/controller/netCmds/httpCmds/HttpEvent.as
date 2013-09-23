package mainModule.controller.netCmds.httpCmds
{
	import flash.events.Event;
	
	import kylin.echo.edward.framwork.KylinEvent;
	
	
	public class HttpEvent extends KylinEvent
	{
		/**
		 *  发送请求(请求可能被存入队列中等待)
		 */		
		public static const Type_Request:int = 0;
		/**
		 * 响应结果 
		 */		
		public static const Type_Response:int = 1;
		/**
		 * 请求已经被发送 
		 */		
		public static const Type_RequestBeSend:int = 2;
		/**
		 * 返回的结果报错
		 */		
		public static const Type_ResponseError:int = 3;
		/**
		 * 请求时出错，安全性错误或io错误导致服务器无响应
		 */		
		public static const Type_RequestError:int = 4;
		
		/**********************************************************************************************/
		/**
		 * 游戏初始数据 
		 */		
		public static const Http_GameInit:String = "gameInit";
		
		private var _iHttpType:int;
		private var _body:Object;
		
		public function HttpEvent(type:String,data:Object = null, httpType:int = 0, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			_iHttpType = httpType;
			_body = data;
			super(type, bubbles, cancelable);
		}
		
		/**
		 * 消息参数 
		 */
		public function get body():Object
		{
			return _body;
		}

		/**
		 * 1:发送请求(请求可能被存入队列中等待); 2:响应结果; 3:请求已经被发送
		 */
		public function get iHttpType():int
		{
			return _iHttpType;
		}

		override public function clone():Event
		{
			return new HttpEvent(type,_body,_iHttpType,bubbles,cancelable);
		}
	}
}