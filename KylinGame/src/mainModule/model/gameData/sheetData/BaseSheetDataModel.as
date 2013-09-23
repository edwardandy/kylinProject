package mainModule.model.gameData.sheetData
{
	import flash.utils.Dictionary;
	
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import kylin.echo.edward.framwork.model.KylinModel;
	import kylin.echo.edward.utilities.loader.interfaces.ILoadMgr;
	
	import mainModule.service.gameDataServices.interfaces.ISheetDataService;
	
	/**
	 * 游戏数值表 
	 * @author Edward
	 * 
	 */	
	public class BaseSheetDataModel extends KylinModel
	{
		[Inject]
		public var loadMgr:ILoadMgr;
		[Inject]
		public var sheetDataService:ISheetDataService;
		/**
		 * 配置表名，需和配置文件名一样 
		 */		
		protected var sheetName:String;
		/**
		 * 配置表项对应类 
		 */		
		protected var sheetClass:Class;
		/**
		 * 存储已生成的表项对象 
		 */		
		protected var dicSheets:Dictionary;
		
		public function BaseSheetDataModel()
		{
			super();
			dicSheets = new Dictionary;
		}
		/**
		 * 生成一个配置表项对应的类对象 (配置表格式需要优化)
		 * @param id 配置表项的唯一key值
		 * @return 
		 * 
		 */		
		protected function genSheetElement(id:uint):Object
		{
			if(!dicSheets.hasOwnProperty(id))
				dicSheets[id] = sheetDataService.genSheetElement(id,sheetName,sheetClass);
			return dicSheets[id];
		}
	}
}