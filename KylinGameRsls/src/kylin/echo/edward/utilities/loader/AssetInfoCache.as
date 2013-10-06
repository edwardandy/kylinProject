package kylin.echo.edward.utilities.loader
{
	import flash.utils.Dictionary;
	/**
	 * 缓存素材 
	 * @author Edward
	 * 
	 */	
	internal class AssetInfoCache
	{
		private var _dicCache:Dictionary = new Dictionary;
		
		public function AssetInfoCache()
		{
		}
		/**
		 *  添加一个素材信息
		 * @param id
		 * @param info
		 * 
		 */		
		internal function addCacheAssetInfo(id:String,info:AssetInfo):void
		{
			if(id && info)
				_dicCache[id] = info;
		}
		/**
		 * 根据id获得素材信息
		 * @param id 
		 * @param bAutoFill 当id对应的素材不存在时，是否自动创建一个新素材信息并缓存
		 * @return 素材信息
		 * 
		 */		
		internal function getCacheAssetInfo(id:String,bAutoFill:Boolean = true):AssetInfo
		{
			return _dicCache[id] || (bAutoFill?(_dicCache[id] = new AssetInfo):null);
		}
	}
}