package mainModule.model.gameData.sheetData
{
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.framwork.model.KylinModel;
	
	import mainModule.model.gameData.sheetData.interfaces.ISheetDataCacheModel;

	/**
	 * 配置表数据缓存，解析后以二维数组形式保存
	 * @author Edward
	 * 
	 */	
	public class SheetDataCacheModel extends KylinModel implements ISheetDataCacheModel
	{
		private var _dicSheetCache:Dictionary;
		
		public function SheetDataCacheModel()
		{
			super();
			_dicSheetCache = new Dictionary;
		}
		
		public function getSheetCache(sheetName:String):Array
		{
			return _dicSheetCache[sheetName];
		}
		
		public function cacheSheetData(sheetName:String,cache:Array):void
		{
			_dicSheetCache[sheetName] = cache;
		}
	}
}