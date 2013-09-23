package mainModule.model.gameData.sheetData.interfaces
{
	/**
	 * 配置表数据缓存，解析后以二维数组形式保存
	 * @author Edward
	 * 
	 */	
	public interface ISheetDataCacheModel
	{
		/**
		 * 通过数据表名获得解析过的数组 
		 * @param sheetName
		 * @return 
		 * 
		 */		
		function getSheetCache(sheetName:String):Array;
		/**
		 * 缓存解析后的数据表数组 
		 * @param sheetName
		 * @param cache
		 * 
		 */		
		function cacheSheetData(sheetName:String,cache:Array):void;
	}
}