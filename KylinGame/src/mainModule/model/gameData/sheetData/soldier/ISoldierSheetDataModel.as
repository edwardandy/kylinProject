package mainModule.model.gameData.sheetData.soldier
{

	/**
	 * 士兵或援兵或己方召唤生物数值表 
	 * @author Edward
	 * 
	 */	
	public interface ISoldierSheetDataModel
	{
		/**
		 * 通过士兵id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getSoldierSheetById(id:uint):SoldierSheetItem;
	}
}