package mainModule.service.gameDataServices.sheetData
{
	import br.com.stimuli.loading.loadingtypes.URLItem;
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import kylin.echo.edward.framwork.service.KylinService;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.interfaces.ISheetDataCacheModel;
	import mainModule.service.gameDataServices.interfaces.ISheetDataService;
	
	import org.robotlegs.core.IInjector;

	/**
	 * CSV格式的配置文件解析器  
	 * @author Edward
	 * 
	 */	
	public class CSVSheetDataService extends KylinService implements ISheetDataService
	{
		[Inject]
		public var loadMgr:ILoadMgr;
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
				var item:URLItem = loadMgr.getCfgFileItem(sheetName) as URLItem;
				if(!item || !item.content)
					return null;
				
				sheetCache.cacheSheetData(sheetName,KylinStringUtil.parseCsv(item.content));
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
				arrSub = arrData[i];
				if(id == uint(arrSub[idx]))
				{
					arrData.splice(i,1);
					break;
				}
			}
			
			if(!arrSub)
				return null;
			
			var result:Object = _injector.instantiate(sheetClass);
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