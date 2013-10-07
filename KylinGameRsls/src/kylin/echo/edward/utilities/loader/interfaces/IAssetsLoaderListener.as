package kylin.echo.edward.utilities.loader.interfaces
{
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	/**
	 * 向生成的加载项添加回调函数 
	 * @author Edward
	 * 
	 */	
	public interface IAssetsLoaderListener
	{
		/**
		 * 添加加载完成的回调函数 
		 * @param func 回调函数: function(AssetInfo,...):void
		 * @param params 回调函数的参数
		 * @return this
		 * 
		 */	
		function addComplete(value:Function, params:Array = null):IAssetsLoaderListener;
		/**
		 * 添加加载出错回调函数 
		 * @param func 回调函数
		 * @param params 回调参数
		 * @return this
		 * 
		 */	
		function addError(value:Function, params:Array = null):IAssetsLoaderListener;
		/**
		 * 添加加载进度回调函数 
		 * @param func 回调函数 func(fPercent:Number,...):void
		 * @param params 回调参数
		 * @return this
		 * 
		 */
		function addProgress(value:Function, params:Array = null):IAssetsLoaderListener;
		/**
		 *  将当前加载项加入到多加载项总进度管理中
		 * @param loadProgress 多加载项总进度
		 * @return this
		 * 
		 */		
		function addToLoaderProgress(loadProgress:ILoaderProgress):IAssetsLoaderListener;
		/**
		 * 生成的加载项 
		 * @return 
		 * 
		 */		
		function get item():LoadingItem;
	}
}