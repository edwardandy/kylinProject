package kylin.echo.edward.utilities.loader.resPath
{
	public final class ResPathVO
	{
		private var _url:String;
		private var _size:uint;
		public function ResPathVO()
		{
		}

		/**
		 * 资源大小，单位Byte 
		 */
		public function get size():uint
		{
			return _size;
		}

		/**
		 * @private
		 */
		public function set size(value:uint):void
		{
			_size = value;
		}

		/**
		 * 资源地址 
		 */
		public function get url():String
		{
			return _url;
		}

		/**
		 * @private
		 */
		public function set url(value:String):void
		{
			_url = value;
		}

	}
}