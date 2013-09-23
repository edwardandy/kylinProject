package mainModule.service.netServices.httpServices
{
	/**
	 * 请求里批量传输的每个数据的格式，包括服务器处理请求的类名，函数名和数据 
	 * @author Edward
	 * 
	 */	
	public class HttpRequestDataFormat
	{
		private var _serverClass:String;
		private var _serverFunc:String;
		private var _data:Array;
		
		public function HttpRequestDataFormat(cls:String,func:String,info:Array)
		{
			_serverClass = cls;
			_serverFunc = func;
			_data = info;
		}

		/**
		 * 请求发送的数据 
		 */
		public function get data():Array
		{
			return _data;
		}

		/**
		 * 服务器处理请求的函数名 
		 */
		public function get serverFunc():String
		{
			return _serverFunc;
		}

		/**
		 * 服务器处理请求的类名 
		 */
		public function get serverClass():String
		{
			return _serverClass;
		}

	}
}