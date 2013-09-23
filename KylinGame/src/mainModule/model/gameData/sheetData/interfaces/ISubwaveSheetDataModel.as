package mainModule.model.gameData.sheetData.interfaces
{
	import mainModule.model.gameData.sheetData.subwave.SubwaveSheetItem;

	/**
	 * 关卡出怪小波次数值表 
	 * @author Edward
	 * 
	 */
	public interface ISubwaveSheetDataModel
	{
		/**
		 * 通过小波次id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getSubwaveSheetById(id:uint):SubwaveSheetItem;
	}
}