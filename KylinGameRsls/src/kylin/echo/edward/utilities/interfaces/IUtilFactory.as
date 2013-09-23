package kylin.echo.edward.utilities.interfaces
{
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;

	/**
	 *  公用功能类工厂接口
	 * @author Edward
	 * 
	 */	
	public interface IUtilFactory
	{
		/**
		 * 创建加载管理器 
		 * @return 
		 * 
		 */		
		function createLoadMgr():ILoadMgr;
		/**
		 * 创建加载进度管理器
		 * @return 加载进度管理器
		 * 
		 */		
		function createLoaderProgress():ILoaderProgress;
	}
}