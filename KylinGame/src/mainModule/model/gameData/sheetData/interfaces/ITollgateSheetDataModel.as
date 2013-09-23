package mainModule.model.gameData.sheetData.interfaces
{
	import mainModule.model.gameData.sheetData.tollgate.TollgateSheetItem;

	/**
	 * 关卡数值表 
	 * @author Edward
	 * 
	 */
	public interface ITollgateSheetDataModel
	{
		/**
		 * 通过关卡id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getTollgateSheetById(id:uint):TollgateSheetItem;
	}
}