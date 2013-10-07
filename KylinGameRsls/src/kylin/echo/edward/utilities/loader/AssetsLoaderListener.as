package kylin.echo.edward.utilities.loader
{
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import kylin.echo.edward.utilities.loader.interfaces.IAssetsLoaderListener;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;

	/**
	 * 向生成的加载项添加回调函数 
	 * @author Edward
	 * 
	 */	
	public class AssetsLoaderListener implements IAssetsLoaderListener
	{
		private var _loadItem:LoadingItem;
		private var _key:String;
		
		private var _loadMgr:LoadMgr;
		private var _infoCache:AssetInfoCache;
		/**
		 * 向生成的加载项添加回调函数 
		 **/
		public function AssetsLoaderListener(loader:LoadMgr,cache:AssetInfoCache)
		{
			_loadMgr = loader;
			_infoCache = cache;
		}
		/**
		 * 当前要添加监听函数的加载项 
		 * @param value
		 * 
		 */		
		internal function set loadItem(value:LoadingItem):void
		{
			_loadItem = value;
		}
		/**
		 * 当前加载项的id 
		 * @param value
		 * 
		 */		
		internal function set key(value:String):void
		{
			_key = value;
		}
		/**
		 * @inheritDoc
		 */			
		public function addComplete(func:Function, params:Array = null):IAssetsLoaderListener
		{
			if(!_key)
				return this;
			const info:AssetInfo = _infoCache.getCacheAssetInfo(_key);
			params ||= [];
			info.onCompletes.push(func);
			info.onCompleteParams.push(params);
			
			if(info && info.content)
				_loadMgr.applyCallback(_key,info.content);
			else if (_loadItem && _loadItem.isLoaded)
				_loadMgr.applyCallback(_key,_loadItem.content);
				
			return this;
		}
		/**
		 * @inheritDoc
		 */		
		public function addError(func:Function, params:Array = null):IAssetsLoaderListener
		{
			if(!_key)
			{
				_loadMgr.safelyCB(func,params);
				return this;
			}
			const info:AssetInfo = _infoCache.getCacheAssetInfo(_key);
			if ((info && info.content) || (_loadItem && _loadItem.isLoaded))
				return this;
			
			params ||= [];
			info.onErrors.push(func);
			info.onErrorParams.push(params);		
			return this;
		}
		/**
		 * @inheritDoc
		 */		
		public function addProgress(func:Function, params:Array = null):IAssetsLoaderListener
		{
			if(!_key)
				return this;
			const info:AssetInfo = _infoCache.getCacheAssetInfo(_key);
			if ((info && info.content) || (_loadItem && _loadItem.isLoaded))
				return this;
					
			params ||= [];
			info.onUpdates.push(func);
			info.onUpdateParams.push(params);
			return this;
		}
		/**
		 * @inheritDoc
		 */		
		public function addToLoaderProgress(loadProgress:ILoaderProgress):IAssetsLoaderListener
		{
			if(!loadProgress || !_loadItem || _loadItem.isLoaded)
				return this;
			(loadProgress as LoaderProgress).addItem(_loadItem,this);
			return this;
		}
		/**
		 * @inheritDoc
		 */	
		public function get item():LoadingItem
		{
			return _loadItem;
		}
	}
}