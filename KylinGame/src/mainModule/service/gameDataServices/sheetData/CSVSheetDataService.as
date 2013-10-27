package mainModule.service.gameDataServices.sheetData
{
	import br.com.stimuli.loading.loadingtypes.URLItem;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	import kylin.echo.edward.utilities.loader.AssetInfo;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.interfaces.ISheetDataCacheModel;
	import mainModule.service.gameDataServices.interfaces.ISheetDataService;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import robotlegs.bender.framework.api.IInjector;
	

	/**
	 * CSV格式的配置文件解析器  
	 * @author Edward
	 * 
	 */	
	public class CSVSheetDataService extends KylinActor implements ISheetDataService
	{
		[Inject]
		public var loadService:ILoadAssetsServices;
		[Inject]
		public var sheetCache:ISheetDataCacheModel;
		[Inject]
		public var _injector:IInjector;
		
		public function CSVSheetDataService()
		{
			super();
		}
		
		public function genSheetElement(id:uint, sheetName:String, sheetClass:Class):Object
		{
			if(!sheetCache.getSheetCache(sheetName))
			{
				const asset:AssetInfo = loadService.getCfgFileItem(sheetName);
				if(!asset || !asset.content)
					return null;
				
				sheetCache.cacheSheetData(sheetName,KylinStringUtil.parseCsv(asset.content));
			}
			var arrData:Array = sheetCache.getSheetCache(sheetName);
			if(!arrData)
				return null;
			
			var fieldRow:int = -1;
			var idx:int = -1;
			for (var i:* in arrData)
			{
				idx = (arrData[i] as Array).indexOf("configId");
				if(-1 != idx)
				{
					fieldRow = i;
					break;
				}
			}
			
			if(-1 == idx || -1 == fieldRow)
				return null;
			
			var arrSub:Array;
			i = 0;
			for(i in arrData)
			{	
				if(id == uint(arrData[i][idx]))
				{
					arrSub = arrData[i];
					arrData.splice(i,1);
					break;
				}
			}
			
			if(!arrSub)
				return null;
			
			var result:Object = _injector.instantiateUnmapped(sheetClass);
			var prop:String;
			i = 0;
			for(i in arrData[fieldRow])
			{
				prop = arrData[fieldRow][i];
				if(result.hasOwnProperty(prop))
					result[prop] = arrSub[i];
			}
			return result;
		}
	}
}