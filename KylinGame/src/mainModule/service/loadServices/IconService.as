package mainModule.service.loadServices
{
	import flash.display.Bitmap;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.utilities.display.DisplayUtility;
	import kylin.echo.edward.utilities.loader.AssetInfo;
	import kylin.echo.edward.utilities.loader.interfaces.IAssetsLoaderListener;
	
	import mainModule.model.gameData.sheetData.item.IItemSheetDataModel;
	import mainModule.model.gameData.sheetData.item.IItemSheetItem;
	import mainModule.service.loadServices.interfaces.IIconService;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;

	/**
	 * 图标加载功能 
	 * @author Edward
	 * 
	 */	
	public class IconService implements IIconService
	{
		[Inject]
		public var loadService:ILoadAssetsServices;
		[Inject]
		public var itemModel:IItemSheetDataModel;
		
		//这两个字典类用于保证在过短时间内对同一个容器多次调用loadIcon加载不同的内容时，最后一个是有效的
		private var _iconItemDic:Dictionary = new Dictionary();	
		private var _iconQualityDic:Dictionary = new Dictionary();
		
		/**
		 * 获取Avatar头像
		 * @param container 	容器
		 * @param facebookId	ID
		 */			
		public function loadAvatar(container:DisplayObjectContainer,facebookId:String, width:uint=50, height:uint=50):void
		{
			var path:String = "https://graph.facebook.com/" + facebookId + "/picture?width=" + width + "&height=" + height;
			checkIconLoad(container,path,loadService.addExternalImgItem(path));
		}
		
		/**
		 * 加载一个外部图片 
		 * @param container
		 * @param path
		 * 
		 */
		public function loadXImage(container:DisplayObjectContainer,path:String):void
		{
			checkIconLoad(container,path,loadService.addExternalImgItem(path));
		}
		
		private function checkIconLoad(container:DisplayObjectContainer,id:String,item:IAssetsLoaderListener, itemId:uint=0):void
		{
			_iconItemDic[container] = id;
			if(!item)
				return;
			item.addComplete(onIconLoaded,[container,id,itemId]);
		}
		
		private function onIconLoaded(asset:AssetInfo,container:DisplayObjectContainer,id:String, itemId:uint=0):void
		{
			if ( _iconItemDic[container] == id )
			{
				delete _iconItemDic[container];
				DisplayUtility.instance.removeAllChild(container);				
				
				var _bmp:Bitmap = asset.getBitmap();
				DisplayUtility.instance.removeAllChild(container);
				if (itemId>0)//道具类图标
				{
					/*var itemInfo:ItemTemplateInfo = TemplateDataFactory.getInstance().getItemTemplateById( itemId );
					if ( itemInfo )
					{
						var className:String = "quality_" + itemInfo.quality + "_" + size + ".png";
						if ( _iconQualityDic[className] == null )
						{
							if ( ApplicationDomain.currentDomain.hasDefinition(className) )
							{
								var clazz:Class = getDefinitionByName( className ) as Class;
								if ( clazz )
								{
									_iconQualityDic[className] = new clazz() as BitmapData;
								}
							}
						}
						
						if ( _iconQualityDic[className] )
						{
							addChild( container, new Bitmap( _iconQualityDic[className] ) );
						}
					}*/
				}
				//如果是加载的FB好友头像，这里需要修正一下尺寸，避免有时候返回的值不是期望值BUG 21029
				if ( id.indexOf("graph.facebook.com") != -1 )
				{
					var reg:RegExp = /.*width=(\d*)&height=(\d*).*/;
					var info:Object = reg.exec(id);
					_bmp.width = info[1];
					_bmp.height = info[2];
				}
				addChild(container, _bmp);		
			}
		}
		
		/**
		 * 获取Icon
		 * @param container
		 * @param typeStr
		 * @param configId
		 * @param size
		 */
		public function loadIcon(container:DisplayObjectContainer,typeStr:String,configId:int,size:String,suffix:String = ".png",bShowQuality:Boolean=true):IAssetsLoaderListener
		{
			DisplayUtility.instance.removeAllChild(container);
			var item:IItemSheetItem = itemModel.getItemSheetById(configId);
			const path:String = typeStr + "_"+ (item.resId>0?item.resId:configId) + "_"+size;
			var listener:IAssetsLoaderListener = loadService.addIconItem(path);
			checkIconLoad(container,path,listener,bShowQuality?configId:0);
			return listener;
		}
		
		private function addChild(container:DisplayObjectContainer, bmp:Bitmap):void
		{
			container.addChild(bmp);
			bmp.x =  - bmp.width >> 1;
			bmp.y =  - bmp.height >> 1;
		}
	}
}