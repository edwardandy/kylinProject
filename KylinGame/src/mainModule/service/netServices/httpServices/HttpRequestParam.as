package mainModule.service.netServices.httpServices
{
	import utili.behavior.interfaces.IDispose;

	/**
	 * 每次请求处理前所需参数 包括前端预处理的和发送给服务器的数据
	 * @author Edward
	 * 
	 */	
	public class HttpRequestParam implements IDispose
	{
		private var _vecData:Vector.<HttpRequestDataFormat>;
		private var _requestId:Number;
		private var _responseEventType:String;
		private var _bNeedRespon:Boolean;
		private var _bInQueue:Boolean;
		private var _retryTimes:int;
		
		public function HttpRequestParam()
		{
			_vecData = new Vector.<HttpRequestDataFormat>;
			_bInQueue = true;
		}

		/**
		 * 是否需要处理相应结果 
		 */
		public function get bNeedRespon():Boolean
		{
			return _bNeedRespon;
		}

		/**
		 * @private
		 */
		public function set bNeedRespon(value:Boolean):void
		{
			_bNeedRespon = value;
		}

		/**
		 * 请求发生io错误时重试的次数 
		 */
		public function get retryTimes():int
		{
			return _retryTimes;
		}

		/**
		 * @private
		 */
		public function set retryTimes(value:int):void
		{
			_retryTimes = value;
		}

		/**
		 * true:放入队列，按顺序发送，false:立即发送该请求,不进入队列等待 
		 */
		public function get bInQueue():Boolean
		{
			return _bInQueue;
		}

		/**
		 * @private
		 */
		public function set bInQueue(value:Boolean):void
		{
			_bInQueue = value;
		}

		/**
		 * 响应时触发的事件类型 
		 */
		public function get responseEventType():String
		{
			return _responseEventType;
		}

		/**
		 * @private
		 */
		public function set responseEventType(value:String):void
		{
			_responseEventType = value;
		}

		/**
		 * 请求的id(以增量方式改变)表示请求发送的先后顺序 
		 */
		public function get requestId():Number
		{
			return _requestId;
		}

		/**
		 * @private
		 */
		public function set requestId(value:Number):void
		{
			_requestId = value;
		}

		/**
		 * 批量传输的数据 
		 */
		public function get vecData():Vector.<HttpRequestDataFormat>
		{
			return _vecData;
		}

		public function dispose():void
		{
			_vecData.length = 0;
			_vecData = null;
		}
	}
}