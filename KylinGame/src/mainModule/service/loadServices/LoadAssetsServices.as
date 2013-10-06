package mainModule.service.loadServices
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.system.LoaderContext;
	
	import br.com.stimuli.loading.BulkLoader;
	import br.com.stimuli.loading.BulkProgressEvent;
	
	import kylin.echo.edward.utilities.loader.AssetInfo;
	import kylin.echo.edward.utilities.loader.ExternalImageItem;
	import kylin.echo.edward.utilities.loader.LoadMgr;
	import kylin.echo.edward.utilities.loader.StreamImageItem;
	import kylin.echo.edward.utilities.loader.interfaces.IAssetsLoaderListener;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.loader.resPath.ResPathFolderType;
	import kylin.echo.edward.utilities.loader.resPath.ResPathParam;
	
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * 素材加载和管理 
	 * @author Edward
	 * 
	 */
	public class LoadAssetsServices implements ILoadAssetsServices
	{
		private static const TYPE_STREAM_IMAGE:String = "stream_image";
		private static const TYPE_EXTERNAL_IMAGE:String = "external_image";
		
		private static const Load_Root:String = "root";
		private static const Load_Image:String = "image";
		private static const Load_Swf:String = "swf";
		private static const Load_BattleRes:String = "battleres";
		private static const Load_Others:String = "others";
		private static const Load_Map:String = "map";
		
		[Inject]
		public var _logger:ILogger;
		
		private var _loadMgr:ILoadMgr;
		
		public function LoadAssetsServices()
		{
		}

		[PostConstruct]
		public function init(pathParam:ResPathParam):void
		{
			BulkLoader.TEXT_EXTENSIONS.push(".csv");
			BulkLoader.registerNewType("jpg",TYPE_STREAM_IMAGE,StreamImageItem);
			BulkLoader.registerNewType("*",TYPE_EXTERNAL_IMAGE,ExternalImageItem);
			
			_loadMgr = new LoadMgr(_logger,pathParam);
		}
		
		public function getAssetInfo(folderKey:String,idKey:String):AssetInfo
		{
			return _loadMgr.getLoadRes(folderKey,idKey);
		}
		/**
		 * @inheritDoc
		 */	
		public function addBattleItem(id:String,domainName:String = "currentDomain",props:Object = null):IAssetsLoaderListener
		{
			return _loadMgr.loadRes(ResPathFolderType.BattleRes,id,props,Load_BattleRes,domainName);
		}
		/**
		 * @inheritDoc
		 */	
		public function getBattleItem(id:String):AssetInfo
		{
			return _loadMgr.getLoadRes(ResPathFolderType.BattleRes,id);
		}
		/**
		 * @inheritDoc
		 */	
		public function addCfgFileItem(id:String,props:Object = null):IAssetsLoaderListener
		{
			return _loadMgr.loadRes(ResPathFolderType.ConfigFile,id,props,Load_Others);
		}
		/**
		 * @inheritDoc
		 */	
		public function getCfgFileItem(id:String):AssetInfo
		{
			return _loadMgr.getLoadRes(ResPathFolderType.ConfigFile,id);
		}
		/**
		 * @inheritDoc
		 */	
		public function addFontItem(id:String,props:Object = null):IAssetsLoaderListener
		{
			return _loadMgr.loadRes(ResPathFolderType.Font,id,props,Load_Others);
		}
		/**
		 * @inheritDoc
		 */	
		public function addIconItem(id:String,props:Object = null,loaderName:String = Load_Image):IAssetsLoaderListener
		{
			return loadImg(ResPathFolderType.Icon,id,props,loaderName);
		}
		/**
		 * @inheritDoc
		 */	
		public function getIconBitmapData(id:String):BitmapData
		{
			var info:AssetInfo = _loadMgr.getLoadRes(ResPathFolderType.Icon,id);
			if(info && info.content is Bitmap)
			{
				return (info.content as Bitmap).bitmapData.clone();
			}
			return null;
		}
		/**
		 * @inheritDoc
		 */	
		public function addImageItem(id:String,props:Object = null):IAssetsLoaderListener
		{
			return loadImg(ResPathFolderType.Image,id,props);
		}
		/**
		 * @inheritDoc
		 */	
		public function addMapImgItem(id:String,props:Object = null):IAssetsLoaderListener
		{
			return loadImg(ResPathFolderType.Map,id,props,Load_Map);
		}
		/**
		 * @inheritDoc
		 */	
		public function addMapXmlItem(id:String,props:Object = null):IAssetsLoaderListener
		{
			return _loadMgr.loadRes(ResPathFolderType.MapXml,id,props,Load_Map);
		}
		/**
		 * @inheritDoc
		 */	
		public function addNewbieGuideItem(id:String,props:Object = null):IAssetsLoaderListener
		{
			return loadImg(ResPathFolderType.NewbieGuide,id,props);
		}
		/**
		 * @inheritDoc
		 */	
		public function addModuleItem(id:String,domainName:String = null,props:Object = null):IAssetsLoaderListener
		{
			return _loadMgr.loadRes(ResPathFolderType.Module,id,props,Load_Swf,domainName);
		}
		/**
		 * @inheritDoc
		 */	
		public function getModuleItem(id:String):AssetInfo
		{
			return _loadMgr.getLoadRes(ResPathFolderType.Module,id);
		}	
		/**
		 * @inheritDoc
		 */		
		public function addSoundItem( id:String,props:Object = null ):IAssetsLoaderListener
		{
			return _loadMgr.loadRes(ResPathFolderType.SoundEffects,id,props,Load_Others);
		}
		/**
		 * @inheritDoc
		 */	
		public function getSoundItem( id:String ):AssetInfo
		{
			return _loadMgr.getLoadRes(ResPathFolderType.SoundEffects,id);
		}
		
		private function loadImg(folderKey:String,idKey:String,props:Object = null,loadName:String = Load_Image):IAssetsLoaderListener
		{
			props ||= {};
			props.context ||= new LoaderContext(true);
			(props.context as LoaderContext).checkPolicyFile = true;
			props.type ||= BulkLoader.TYPE_IMAGE;
			
			return _loadMgr.loadRes(folderKey,idKey,props,loadName);
		}
		/**
		 * @inheritDoc
		 */	
		public function addExternalImgItem(url:String,props:Object = null,loadName:String = Load_Image):IAssetsLoaderListener
		{
			return loadImg("",url,props,loadName);
		}
		/**
		 * @inheritDoc
		 */	
		public function addStreamImageItem(id:String,props:Object = null):IAssetsLoaderListener
		{
			BulkProgressEvent.SINGLE_COMPLETE
			props ||= {};
			props.type = TYPE_STREAM_IMAGE;
			return _loadMgr.loadRes(ResPathFolderType.Image,id,props,Load_Image);
		}
	}
}