package mainModule.service.loadServices.interfaces
{
	import flash.display.DisplayObjectContainer;
	
	import kylin.echo.edward.utilities.loader.interfaces.IAssetsLoaderListener;

	/**
	 * 图标加载功能 
	 * @author Edward
	 * 
	 */	
	public interface IIconService
	{
		/**
		 * 获取Avatar头像
		 * @param container 	容器
		 * @param facebookId	ID
		 */			
		function loadAvatar(container:DisplayObjectContainer,facebookId:String, width:uint=50, height:uint=50):void;
		/**
		 * 加载一个外部图片 
		 * @param container
		 * @param path
		 * 
		 */
		function loadXImage(container:DisplayObjectContainer,path:String):void;
		/**
		 * 获取Icon
		 * @param container
		 * @param typeStr
		 * @param configId
		 * @param size
		 */
		function loadIcon(container:DisplayObjectContainer,typeStr:String,configId:int,size:String,suffix:String = ".png",bShowQuality:Boolean=true):IAssetsLoaderListener;
	}
}