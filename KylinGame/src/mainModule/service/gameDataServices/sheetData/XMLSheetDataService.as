package mainModule.service.gameDataServices.sheetData
{
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	import kylin.echo.edward.utilities.loader.AssetInfo;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	import mainModule.service.gameDataServices.interfaces.ISheetDataService;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;

	/**
	 * XML格式的配置文件解析器 
	 * @author Edward
	 * 
	 */	
	public class XMLSheetDataService extends KylinActor implements ISheetDataService
	{
		[Inject]
		public var loadService:ILoadAssetsServices;
		
		public function XMLSheetDataService()
		{
			super();
		}
		
		public function genSheetElement(id:uint,sheetName:String,sheetClass:Class):Object
		{
			const asset:AssetInfo = loadService.getCfgFileItem(sheetName);
			if(!asset || !asset.content)
				return null;
			
			var cfg:XML = asset.content;
			var list:XMLList = cfg.children();
			var find:XML;
			
			var subList:XMLList;
			var sub:XML;
			for each(var element:XML in list)
			{
				subList = element.children();
				for each(sub in subList)
				{
					if("configId" == sub.name()  && uint(sub) == id)
					{
						find = element;
						break;
					}
					
				}
				if(find)
					break;
			}
			
			if(!find)
				return null;
			
			subList = element.children();
			var result:Object = new sheetClass;
			for each(sub in subList)
			{
				if(result.hasOwnProperty(sub.name()))
					result[sub.name()] = sub;
			}
			return result;
		}
	}
}