package kylin.echo.edward.utilities
{
	import kylin.echo.edward.utilities.interfaces.IUtilFactory;
	import kylin.echo.edward.utilities.loader.LoadMgr;
	import kylin.echo.edward.utilities.loader.LoaderProgress;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;

	/**
	 *  公用功能模块创建工厂类
	 * @author Edward
	 * 
	 */	
	public class UtilFactory implements IUtilFactory
	{
		public function UtilFactory()
		{
		}
		/**
		 * @inheritDoc 
		 */		
		public function createLoadMgr():ILoadMgr
		{
			return new LoadMgr;
		}
		/**
		 * @inheritDoc 
		 */	
		public function createLoaderProgress():ILoaderProgress
		{
			return new LoaderProgress;
		}
		
	}
}