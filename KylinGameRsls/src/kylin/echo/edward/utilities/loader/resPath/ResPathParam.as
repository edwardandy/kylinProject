package kylin.echo.edward.utilities.loader.resPath
{
	/**
	 * 资源路径生成器参数
	 * @author Edward
	 * 
	 */	
	public final class ResPathParam
	{
		private var _resCfg:XML;
		private var _rootPath:String;
		private var _curLan:String;
		
		public function ResPathParam(cfg:XML,path:String,lan:String)
		{
			_resCfg = cfg;
			_rootPath = path;
			_curLan = lan;
		}

		/**
		 * 当前语言版本 
		 */
		public function get curLan():String
		{
			return _curLan;
		}

		/**
		 * 资源根目录 
		 */
		public function get rootPath():String
		{
			return _rootPath;
		}

		/**
		 * 资源配置文件 
		 */
		public function get resCfg():XML
		{
			return _resCfg;
		}

	}
}