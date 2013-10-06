package kylin.echo.edward.utilities.loader.interfaces
{
	import kylin.echo.edward.utilities.loader.AssetInfo;

	/**
	 * 加载管理器接口
	 * @author Edward
	 * 
	 */	
	public interface ILoadMgr
	{
		/**
		 *  获得SWF域加载管理器
		 * @return 
		 * 
		 */		
		function get domainMgr():IDomainResMgr;
		/**
		 * 添加加载项，如已添加，则返回已添加项 
		 * @param folderKey 资源配置目录键名 如果为""，则idKey直接为外部URL进行加载
		 * @param idKey 资源配置id键名
		 * @param props 传递给bulkloader的参数对象
		 * @param loadName 队列加载器的id
		 * @param domainName 资源加载到的域名称 "currentDomain",".....childDomain","otherDomains",如果为空就不会加入到域管理器里
		 * @return 加载项
		 * 
		 */		
		function loadRes(folderKey:String,idKey:String,props:Object,loadName:String,domainName:String = null):IAssetsLoaderListener;
		/**
		 * 获得已添加的加载项 
		 * @param folderKey 资源配置目录键名
		 * @param idKey 资源配置id键名
		 * @return 加载项，如未添加，则返回null
		 * 
		 */		
		function getLoadRes(folderKey:String,idKey:String):AssetInfo;
	}
}