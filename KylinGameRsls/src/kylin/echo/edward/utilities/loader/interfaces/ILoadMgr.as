package kylin.echo.edward.utilities.loader.interfaces
{
	import flash.display.BitmapData;
	
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import br.com.stimuli.loading.loadingtypes.SoundItem;
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import kylin.echo.edward.utilities.loader.ExternalImageItem;
	import kylin.echo.edward.utilities.loader.StreamDataItem;

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
		 * 通过资源配置目录键名和id键名生成加载项的id 
		 * @param folderKey 资源配置目录键名
		 * @param idKey 资源配置id键名
		 * @return 加载项的id
		 * 
		 */		
		function genLoadKey(folderKey:String,idKey:String):String;
		/**
		 * 添加加载项，如已添加，则返回已添加项 
		 * @param folderKey 资源配置目录键名
		 * @param idKey 资源配置id键名
		 * @param props 传递给bulkloader的参数对象
		 * @param loadName 队列加载器的id
		 * @return 加载项
		 * 
		 */		
		function addLoadItem(folderKey:String,idKey:String,props:Object = null,loadName:String = "root"):LoadingItem;
		/**
		 * 获得已添加的加载项 
		 * @param folderKey 资源配置目录键名
		 * @param idKey 资源配置id键名
		 * @return 加载项，如未添加，则返回null
		 * 
		 */		
		function getLoadItem(folderKey:String,idKey:String):LoadingItem;
		/**
		 * 添加战斗资源加载项 
		 * @param id 资源配置id键名
		 * @param domainName 资源加载到的域名
		 * @param props 传递给bulkloader的参数对象
		 * @return SWF资源加载项
		 * 
		 */		
		function addBattleItem(id:String,domainName:String = null,props:Object = null):ImageItem;
		/**
		 *  获得战斗资源加载项 
		 * @param id 资源配置id键名
		 * @return SWF资源加载项
		 * 
		 */		
		function getBattleItem(id:String):ImageItem;
		/**
		 * 添加配置文件资源加载项
		 * @param id id键名
		 * @param props 传递给bulkloader的参数对象
		 * @return XML资源加载项或者cvs等文本配置或者压缩后的配置文件
		 * 
		 */		
		function addCfgFileItem(id:String,props:Object = null):LoadingItem;
		/**
		 * 获得配置文件资源加载项 
		 * @param id id键名
		 * @return XML资源加载项或者cvs等文本配置或者压缩后的配置文件
		 * 
		 */		
		function getCfgFileItem(id:String):LoadingItem;
		/**
		 *  添加字体文件资源加载项
		 * @param id id键名
		 * @param props 传递给bulkloader的参数对象
		 * @return 字体所属SWF资源加载项
		 * 
		 */		
		function addFontItem(id:String,props:Object = null):ImageItem;
		/**
		 * 添加图标文件资源加载项 
		 * @param id id键名
		 * @param props 传递给bulkloader的参数对象
		 * @param loaderName 队列加载器的id
		 * @return Bitmap资源加载项
		 * 
		 */		
		function addIconItem(id:String,props:Object = null,loaderName:String = "image"):ImageItem;
		/**
		 * 获得已加载的图标的位图数据的拷贝
		 * @param id id键名
		 * @return 位图数据拷贝
		 * 
		 */		
		function getIconBitmapData(id:String):BitmapData;
		/**
		 * 添加图片文件资源加载项
		 * @param id id键名
		 * @param props 传递给bulkloader的参数对象
		 * @return Bitmap资源加载项
		 * 
		 */		
		function addImageItem(id:String,props:Object = null):ImageItem;
		/**
		 * 添加地图图片文件资源加载项
		 * @param id id键名
		 * @param props 传递给bulkloader的参数对象
		 * @return Bitmap资源加载项
		 * 
		 */		
		function addMapImgItem(id:String,props:Object = null):ImageItem;
		/**
		 * 添加地图配置文件资源加载项
		 * @param id id键名
		 * @param props 传递给bulkloader的参数对象
		 * @return XML资源加载项
		 * 
		 */		
		function addMapXmlItem(id:String,props:Object = null):XMLItem;
		/**
		 * 添加新手引导图片文件资源加载项
		 * @param id id键名
		 * @param props 传递给bulkloader的参数对象
		 * @return Bitmap资源加载项
		 * 
		 */		
		function addNewbieGuideItem(id:String,props:Object = null):ImageItem;
		/**
		 * 添加功能模块SWF资源文件 
		 * @param id id键名
		 * @param domainName 资源所属域名
		 * @param props 传递给bulkloader的参数对象
		 * @return SWF资源加载项
		 * 
		 */		
		function addModuleItem(id:String,domainName:String = null,props:Object = null):ImageItem;
		/**
		 * 获得功能模块SWF资源文件 
		 * @param id id键名
		 * @return SWF资源加载项
		 * 
		 */		
		function getModuleItem(id:String):ImageItem;
		/**
		 * 添加声音资源文件 
		 * @param id id键名
		 * @param props 传递给bulkloader的参数对象
		 * @return Sound资源加载项
		 * 
		 */		
		function addSoundItem( id:String,props:Object = null ):SoundItem;
		/**
		 * 获得声音资源文件
		 * @param id id键名
		 * @return Sound资源加载项
		 * 
		 */		
		function getSoundItem( id:String ):SoundItem;
		/**
		 * 添加外部图片资源加载文件,需要处理跨域加载
		 * @param folderKey 资源配置目录键名
		 * @param idKey  资源配置id键名
		 * @param props 传递给bulkloader的参数对象
		 * @param loadName 队列加载器的id
		 * @return Bitmap资源加载项
		 * 
		 */		
		function addExternalImgItem(url:String,props:Object = null,loadName:String = "image"):ExternalImageItem;
		/**
		 * 添加关卡地图背景图片，采用流加载机制，边加载边显示
		 * @param id id键名
		 * @param props 传递给bulkloader的参数对象
		 * @return 自定义流加载项
		 * 
		 */		
		function addMapStreamItem(id:String,props:Object = null):StreamDataItem;
	}
}