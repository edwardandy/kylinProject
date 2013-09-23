package kylin.echo.edward.utilities.loader
{	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.system.LoaderContext;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.LoadingItem;
	import br.com.stimuli.loading.loadingtypes.SoundItem;
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import kylin.echo.edward.utilities.loader.interfaces.IDomainResMgr;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.loader.resPath.ResPathFolderType;
	import kylin.echo.edward.utilities.loader.resPath.ResPathMgr;
	import kylin.echo.edward.utilities.loader.resPath.ResPathParam;
	import kylin.echo.edward.utilities.loader.resPath.ResPathVO;

	/**
	 * 加载管理器接口
	 * @author Edward
	 * 
	 */	
	public class LoadMgr implements ILoadMgr
	{
		private static const TYPE_STREAM_DATA:String = "stream_data";
		private static const TYPE_EXTERNAL_IMAGE_DATA:String = "external_image_data";
		
		private static const Load_Root:String = "root";
		private static const Load_Image:String = "image";
		private static const Load_Swf:String = "swf";
		private static const Load_BattleRes:String = "battleres";
		private static const Load_Others:String = "others";
		private static const Load_Map:String = "map";
		
		//private static var _instance:LoadMgr;
		
		//private var _rootLoad:BulkLoader;
		private var _resPathMgr:ResPathMgr;
		private var _domainResMgr:IDomainResMgr;
		//private var _dicLoadedItems:Dictionary;
		
		public function LoadMgr()
		{
			BulkLoader.TEXT_EXTENSIONS.push(".csv");
			BulkLoader.registerNewType("jpg",TYPE_STREAM_DATA,StreamDataItem);
			BulkLoader.registerNewType("*",TYPE_EXTERNAL_IMAGE_DATA,ExternalImageItem);
			//_rootLoad = new BulkLoader(Load_Root);
			//_resPathMgr = new ResPathMgr;
			_domainResMgr = new DomainResMgr(this);
			//_dicLoadedItems = new Dictionary;
		}
		
		[Inject]
		public function set resPathParam(value:ResPathParam):void
		{
			_resPathMgr = new ResPathMgr(value);
		}

		/**
		 * @inheritDoc
		 */	
		public function get domainMgr():IDomainResMgr
		{
			return _domainResMgr;
		}
		
		private function getLoaderByName(name:String = Load_Root):BulkLoader
		{
			var load:BulkLoader = BulkLoader.getLoader(name);
			if(!load)
				load = new BulkLoader(name,3);
			return load;
		}
		
		/*public function getRootLoader():BulkLoader
		{
			return getLoaderByName(Load_Root);
		}
		
		public function getImageLoader():BulkLoader
		{
			return getLoaderByName(Load_Image);
		}
		
		public function getSwfLoader():BulkLoader
		{
			return getLoaderByName(Load_Swf);
		}
		
		public function getBattleResLoader():BulkLoader
		{
			return getLoaderByName(Load_BattleRes);
		}
		
		public function getOthersLoader():BulkLoader
		{
			return getLoaderByName(Load_Others);
		}
		
		public function getMapLoader():BulkLoader
		{
			return getLoaderByName(Load_Map*);
		}*/
		
		/*public function Start(withConnections : int = -1 ):Boolean
		{
		if(_rootLoad.isFinished || _rootLoad.itemsTotal<=0)
		return false;
		_rootLoad.start(withConnections);
		if(!_rootLoad.hasEventListener(BulkProgressEvent.COMPLETE))
		{
		_rootLoad.addEventListener(BulkProgressEvent.PROGRESS,onLoadProgress);
		_rootLoad.addEventListener(BulkProgressEvent.SINGLE_COMPLETE,onSingleLoadComplete);
		_rootLoad.addEventListener(BulkProgressEvent.COMPLETE,onLoadComplete);
		}
		return true;
		}
		
		private function onLoadProgress(e:BulkProgressEvent):void
		{
		var evt:BulkProgressEvent = e.clone() as BulkProgressEvent;
		evt.item = e.item;
		this.dispatchEvent(evt);
		}
		
		private function onSingleLoadComplete(e:BulkProgressEvent):void
		{		
		var evt:BulkProgressEvent = e.clone() as BulkProgressEvent;
		evt.item = e.item;
		//_dicLoadedItems[e.item.url.url] = e.item;
		this.dispatchEvent(evt);
		}*/
		
		/*private function onSwfItemLoadComplete(e:Event):void
		{  
			var item:ImageItem = e.currentTarget as ImageItem;
			
			if(!item || !item.content || !item.isSWF())
				return;
			item.removeEventListener(Event.COMPLETE,onSwfItemLoadComplete);
			//_domainResMgr.checkDomainLoaded(item);
		}*/
		
		/*private function onLoadComplete(e:BulkProgressEvent):void
		{
		var loader:BulkLoader = e.currentTarget as BulkLoader;
		loader.removeEventListener(BulkProgressEvent.PROGRESS,onLoadProgress);
		loader.removeEventListener(BulkProgressEvent.COMPLETE,onLoadComplete);
		loader.removeEventListener(BulkProgressEvent.SINGLE_COMPLETE,onSingleLoadComplete);
		
		var evt:BulkProgressEvent = e.clone() as BulkProgressEvent;
		evt.item = e.item;
		this.dispatchEvent(evt);
		}*/
		/**
		 * @inheritDoc
		 */	
		public function genLoadKey(folderKey:String,idKey:String):String
		{
			return folderKey+"|"+idKey;
		}
		/**
		 * @inheritDoc
		 */		
		public function addLoadItem(folderKey:String,idKey:String,props:Object = null,loadName:String = Load_Root):LoadingItem
		{
			if(!folderKey || !idKey)
				return null;
			
			var loadKey:String = genLoadKey(folderKey,idKey);
			var item:LoadingItem = getLoaderByName(loadName).get(loadKey);
			if(item)
				return item;
			else
			{
				props ||= {};
				props[BulkLoader.ID] = loadKey;
				var resVo:ResPathVO = _resPathMgr.genResUrl(folderKey,idKey);
				if(!resVo)
					return null;
				props[BulkLoader.WEIGHT] = resVo.size;
				item = getLoaderByName(loadName).add(resVo.url,props); 
				getLoaderByName(loadName).start();
				addItemErrorListener(item);
			}
			return item;
		}
		/**
		 * @inheritDoc
		 */	
		public function getLoadItem(folderKey:String,idKey:String):LoadingItem
		{
			var loadKey:String = genLoadKey(folderKey,idKey);
			var loader:BulkLoader = BulkLoader.whichLoaderHasItem(loadKey);
			if(loader)
				return loader.get(loadKey);
			return null;
		}
		
		/*public function resetRootLoad():void
		{
		if(_rootLoad.isFinished)
		{
		//_rootLoad.clear();
		_rootLoad.removeEventListener(BulkProgressEvent.PROGRESS,onLoadProgress);
		_rootLoad.removeEventListener(BulkProgressEvent.COMPLETE,onLoadComplete);
		_rootLoad.removeEventListener(BulkProgressEvent.SINGLE_COMPLETE,onSingleLoadComplete);
		_rootLoad = new BulkLoader("root"+(_rootId++));
		}
		}*/
		
		/**
		 * @inheritDoc
		 */	
		public function addBattleItem(id:String,domainName:String = null,props:Object = null):ImageItem
		{
			var item:ImageItem = _domainResMgr.addSwfDomainItem(ResPathFolderType.BattleRes,id,domainName,props,Load_BattleRes) as ImageItem;
			if(item && !item.isLoaded){
				//item.addEventListener(Event.COMPLETE,onSwfItemLoadComplete);
				addItemErrorListener(item);
			}
			return item;
		}
		/**
		 * @inheritDoc
		 */	
		public function getBattleItem(id:String):ImageItem
		{
			return getLoadItem(ResPathFolderType.BattleRes,id) as ImageItem;
		}
		/**
		 * @inheritDoc
		 */	
		public function addCfgFileItem(id:String,props:Object = null):LoadingItem
		{
			return addLoadItem(ResPathFolderType.ConfigFile,id,props,Load_Others);
		}
		/**
		 * @inheritDoc
		 */	
		public function getCfgFileItem(id:String):LoadingItem
		{
			return getLoadItem(ResPathFolderType.ConfigFile,id);
		}
		/**
		 * @inheritDoc
		 */	
		public function addFontItem(id:String,props:Object = null):ImageItem
		{
			return addLoadItem(ResPathFolderType.Font,id,props,Load_Others) as ImageItem;
		}
		/**
		 * @inheritDoc
		 */	
		public function addIconItem(id:String,props:Object = null,loaderName:String = Load_Image):ImageItem
		{
			return loadImg(ResPathFolderType.Icon,id,props,loaderName);
		}
		/**
		 * @inheritDoc
		 */	
		public function getIconBitmapData(id:String):BitmapData
		{
			var item:ImageItem = getLoadItem(ResPathFolderType.Icon,id) as ImageItem;
			if(item && item.isLoaded && item.isImage())
			{
				return (item.content as Bitmap).bitmapData.clone();
			}
			return null;
		}
		/**
		 * @inheritDoc
		 */	
		public function addImageItem(id:String,props:Object = null):ImageItem
		{
			return loadImg(ResPathFolderType.Image,id,props);
		}
		/**
		 * @inheritDoc
		 */	
		public function addMapImgItem(id:String,props:Object = null):ImageItem
		{
			return loadImg(ResPathFolderType.Map,id,props,Load_Map);
		}
		/**
		 * @inheritDoc
		 */	
		public function addMapXmlItem(id:String,props:Object = null):XMLItem
		{
			return addLoadItem(ResPathFolderType.MapXml,id,props,Load_Map) as XMLItem;
		}
		/**
		 * @inheritDoc
		 */	
		public function addNewbieGuideItem(id:String,props:Object = null):ImageItem
		{
			return loadImg(ResPathFolderType.NewbieGuide,id,props);
		}
		/**
		 * @inheritDoc
		 */	
		public function addModuleItem(id:String,domainName:String = null,props:Object = null):ImageItem
		{
			var item:ImageItem = _domainResMgr.addSwfDomainItem(ResPathFolderType.Module,id,domainName,props,Load_Swf) as ImageItem;
			if(item && !item._isLoading && !item.isLoaded){
				//item.addEventListener(Event.COMPLETE,onSwfItemLoadComplete);
				addItemErrorListener(item);
			}
			return item;
		}
		/**
		 * @inheritDoc
		 */	
		public function getModuleItem(id:String):ImageItem
		{
			return getLoadItem(ResPathFolderType.Module,id) as ImageItem;
		}	
		/**
		 * @inheritDoc
		 */		
		public function addSoundItem( id:String,props:Object = null ):SoundItem
		{
			return addLoadItem(ResPathFolderType.SoundEffects,id,props,Load_Others) as SoundItem;
		}
		/**
		 * @inheritDoc
		 */	
		public function getSoundItem( id:String ):SoundItem
		{
			return getLoadItem(ResPathFolderType.SoundEffects,id) as SoundItem;
		}
		
		private function loadImg(folderKey:String,idKey:String,props:Object = null,loadName:String = Load_Image):ImageItem
		{
			props ||= {};
			props.context ||= new LoaderContext(true);
			(props.context as LoaderContext).checkPolicyFile = true;
			props.type ||= BulkLoader.TYPE_IMAGE;
			return addLoadItem(folderKey,idKey,props,loadName) as ImageItem;
		}
		/**
		 * @inheritDoc
		 */	
		public function addExternalImgItem(url:String,props:Object = null,loadName:String = Load_Image):ExternalImageItem
		{
			if(!url)
				return null;
			
			props ||= {};
			props.type = TYPE_EXTERNAL_IMAGE_DATA;
			props.context ||= new LoaderContext(true);
			(props.context as LoaderContext).checkPolicyFile = true;
			props.type ||= BulkLoader.TYPE_IMAGE;
			
			var item:ExternalImageItem = getLoaderByName(loadName).get(url) as ExternalImageItem;
			if(item)
				return item;
			else
			{
				props[BulkLoader.ID] = url;
				item = getLoaderByName(loadName).add(url,props) as ExternalImageItem; 
				addItemErrorListener(item);
				
				item.addEventListener(Event.COMPLETE,onExternalImgLoadCmp);
			}
			return item;
		}
		
		private function onExternalImgLoadCmp(e:Event):void
		{
			var item:ExternalImageItem = e.currentTarget as ExternalImageItem;
			item.removeEventListener(Event.COMPLETE,onExternalImgLoadCmp);
			
			var loader:Loader = new Loader();
			loader.loadBytes(item.loader.contentLoaderInfo.bytes);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(e:*):void{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,arguments.callee);
				item.extImage = Sprite(loader.content).getChildAt(0) as Bitmap;		
			});
		}
		/**
		 * @inheritDoc
		 */	
		public function addMapStreamItem(id:String,props:Object = null):StreamDataItem
		{
			props ||= {};
			props.type = TYPE_STREAM_DATA;
			return addLoadItem(ResPathFolderType.Image,id,props,Load_Image) as StreamDataItem;	
		}
		
		//为要加载的item添加错误侦听 
		private function addItemErrorListener(item:LoadingItem):void
		{
			if(item){
				item.addEventListener(BulkLoader.ERROR, onItemError, false, 0, true);
				item.addEventListener(Event.COMPLETE,onItemLoadComplete,false,int.MIN_VALUE,true);
			}
		}
		
		 //移除侦听 
		protected function onItemLoadComplete(e:Event):void
		{
			var item:LoadingItem = e.currentTarget as LoadingItem;
			item.removeEventListener(BulkLoader.ERROR, onItemError, false);
			item.removeEventListener(Event.COMPLETE,onItemLoadComplete,false);
		}
		
		//加载出错告知服务器 
		private function onItemError(e:ErrorEvent):void
		{
			var item:LoadingItem = e.currentTarget as LoadingItem;
			item.removeEventListener(BulkLoader.ERROR, onItemError, false);
			item.removeEventListener(Event.COMPLETE,onItemLoadComplete,false);
		}
	}
}