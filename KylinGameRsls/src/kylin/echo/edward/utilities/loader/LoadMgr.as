package kylin.echo.edward.utilities.loader
{	
	import flash.display.DisplayObject;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	
	import kylin.echo.edward.utilities.loader.interfaces.IAssetsLoaderListener;
	import kylin.echo.edward.utilities.loader.interfaces.IDomainResMgr;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.loader.resPath.ResPathMgr;
	import kylin.echo.edward.utilities.loader.resPath.ResPathParam;
	import kylin.echo.edward.utilities.loader.resPath.ResPathVO;
	
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * 加载管理器接口
	 * @author Edward
	 * 
	 */	
	public class LoadMgr implements ILoadMgr
	{
		private var _resPathMgr:ResPathMgr;
		private var _domainResMgr:DomainResMgr;
		private var _assetsCache:AssetInfoCache;
		private var _loadListener:AssetsLoaderListener;
		
		private var _logger:ILogger;
		
		public function LoadMgr(log:ILogger,pathParam:ResPathParam)
		{
			_logger = log;
			_domainResMgr = new DomainResMgr(this);
			_assetsCache = new AssetInfoCache;
			_loadListener = new AssetsLoaderListener(this,_assetsCache);
			_resPathMgr = new ResPathMgr(pathParam);
		}
		/**
		 * @inheritDoc
		 */	
		public function get domainMgr():IDomainResMgr
		{
			return _domainResMgr;
		}
		
		private function getLoaderByName(name:String):BulkLoader
		{
			var load:BulkLoader = BulkLoader.getLoader(name);
			if(!load)
				load = new BulkLoader(name,3);
			return load;
		}
		
		/**
		 * 通过资源配置目录键名和id键名生成加载项的id 
		 * @param folderKey 资源配置目录键名
		 * @param idKey 资源配置id键名
		 * @return 加载项的id
		 * 
		 */		
		internal function genLoadKey(folderKey:String,idKey:String):String
		{
			return folderKey+"|"+idKey;
		}
		/**
		 * @inheritDoc
		 */		
		public function loadRes(folderKey:String,idKey:String,props:Object,loaderName:String,domainName:String = null):IAssetsLoaderListener
		{
			_loadListener.key = null;
			_loadListener.loadItem = null;
			
			if(!idKey)
				return _loadListener;
			
			var loadKey:String = genLoadKey(folderKey,idKey);
			if(_assetsCache.getCacheAssetInfo(loadKey).content)
			{
				_loadListener.key = loadKey;
				return _loadListener;
			}
			
			var item:LoadingItem = getLoaderByName(loaderName).get(loadKey);
			if(item)
			{
				_loadListener.key = loadKey;
				_loadListener.loadItem = item;
				return _loadListener;
			}
			else
			{
				props ||= {};
				if(domainName)
					props = _domainResMgr.addDomainItem(folderKey,idKey,domainName,props);
				
				props[BulkLoader.ID] = loadKey;
				var resVo:ResPathVO = _resPathMgr.genResUrl(folderKey,idKey);
				if(!resVo && folderKey)
				{
					_logger.error("LoadMgr ResPathVO cannot find! folderKey:{0} ,idKey:{1}",[folderKey,idKey]);
					return _loadListener;
				}
				props[BulkLoader.WEIGHT] = resVo?resVo.size:1;
				item = getLoaderByName(loaderName).add(resVo?resVo.url:idKey,props); 
				getLoaderByName(loaderName).start();
				addOrRemoveItemListeners(item);
			}
			_loadListener.key = loadKey;
			_loadListener.loadItem = item;
			return _loadListener;
		}
		/**
		 * @inheritDoc
		 */	
		public function getLoadRes(folderKey:String,idKey:String):AssetInfo
		{
			var loadKey:String = genLoadKey(folderKey,idKey);
			return _assetsCache.getCacheAssetInfo(loadKey,false);
		}
		/**
		 * 为加载项添加或移除监听 
		 * @param item
		 * @param bAdd 添加或移除
		 * 
		 */		
		private function addOrRemoveItemListeners(item:LoadingItem,bAdd:Boolean = true):void
		{
			if(item)
			{
				if(bAdd)
				{
					item.addEventListener(BulkLoader.ERROR, onItemError);
					item.addEventListener(Event.COMPLETE,onItemLoadComplete);
					item.addEventListener(BulkProgressEvent.PROGRESS, onItemProgress);
				}
				else
				{
					item.removeEventListener(BulkLoader.ERROR, onItemError);
					item.removeEventListener(Event.COMPLETE,onItemLoadComplete);
					item.removeEventListener(BulkProgressEvent.PROGRESS, onItemProgress);
				}
			}
		}
		/**
		 * 加载完成 
		 * @param e
		 * 
		 */		
		private function onItemLoadComplete(e:Event):void
		{
			const item:LoadingItem= e.currentTarget as LoadingItem;	
			addOrRemoveItemListeners(item,false);
			applyCallback(item.id,item.content);
		}
		
		internal function applyCallback(id:String,content:*):void
		{
			const info:AssetInfo = _assetsCache.getCacheAssetInfo(id);
			info.content = content;
			
			const len:int = info.onCompletes.length;
			for(var i:int=0;i<len;++i)
			{
				if(content is DisplayObject)
				{
					content.x = 0;
					content.y = 0;
				}
				(info.onCompleteParams[i] as Array).splice(0,0,info);
				safelyCB(info.onCompletes[i] as Function,info.onCompleteParams[i]);
			}
			
			info.clearCallbacks();
		}
		/**
		 * 加载出错 
		 * @param e
		 * 
		 */		
		private function onItemError(e:ErrorEvent):void
		{
			const item:LoadingItem= e.currentTarget as LoadingItem;	
			addOrRemoveItemListeners(item,false);
			
			const info:AssetInfo = _assetsCache.getCacheAssetInfo(item.id,false);
			applyError(info);
		}
		
		private function applyError(info:AssetInfo):void
		{
			if(!info)
				return;
			
			const len:int = info.onErrors.length;
			for(var i:int=0;i<len;++i)
			{
				safelyCB(info.onErrors[i] as Function,info.onErrorParams[i]);
			}
			
			info.clearCallbacks();
		}
		
		/**
		 * 加载进度 
		 * @param e
		 * 
		 */		
		private function onItemProgress(e:ProgressEvent):void
		{
			const item:LoadingItem= e.currentTarget as LoadingItem;	
			const info:AssetInfo = _assetsCache.getCacheAssetInfo(item.id,false);
			if(!info)
			{
				_logger.warn("AssetInfo not be cached,id:{0}",[item.id]);
				return;
			}
			
			const len:int = info.onUpdates.length;
			var func:Function;
			for(var i:int=0; i<len; ++i)
			{
				var temp:Array = (info.onUpdateParams[i] as Array).concat().splice(0,0,item.percentLoaded);
				safelyCB(info.onUpdates[i] as Function,temp);
			}
		}
		
		internal function safelyCB(func:Function,params:Array):void
		{
			if(null == func)
				return;
			if(0 == func.length)
				func.apply();
			else
			{
				if(params.length > func.length)
					params.splice(func.length,params.length-func.length);
				func.apply(null,params);
			}
		}
	}
}