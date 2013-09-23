package kylin.echo.edward.utilities.loader.interfaces
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	/**
	 *  SWF域加载管理器
	 * @author Edward
	 * 
	 */	
	public interface IDomainResMgr
	{
		/**
		 * 添加SWF域加载项 
		 * @param folderKey 资源配置目录键名
		 * @param idKey 资源配置id
		 * @param domainName 资源加载到的域名称
		 * @param props 加载时传递给bulkloader的加载参数
		 * @param loaderName 所属的队列加载器的id
		 * @return 获得的加载项
		 * 
		 */		
		function addSwfDomainItem(folderKey:String,idKey:String,domainName:String = null,props:Object = null,loaderName:String = "root"):LoadingItem;
		/**
		 * 通过域名获得类定义 
		 * @param key 类名称
		 * @param domainName 域名称
		 * @return 类定义
		 * 
		 */		
		function getClassByDomain(key:String,domainName:String = null):Class;
		/**
		 * 通过域名获得MC实例
		 * @param key mc所属的类名称
		 * @param domainName 域名称
		 * @return MC实例
		 * 
		 */		
		function getMovieClipByDomain(key:String,domainName:String = null):MovieClip;
		/**
		 * 通过域名获得SimpleButton实例
		 * @param key SimpleButton所属的类名称
		 * @param domainName 域名称
		 * @return SimpleButton实例
		 * 
		 */		
		function getSimpleButtonByDomain(key:String,domainName:String = null):SimpleButton;
		/**
		 * 通过域名获得Sprite实例
		 * @param key Sprite所属的类名称
		 * @param domainName 域名称
		 * @return Sprite实例
		 * 
		 */	
		function getSpriteByDomain(key:String,domainName:String = null):Sprite;
		
	}
}