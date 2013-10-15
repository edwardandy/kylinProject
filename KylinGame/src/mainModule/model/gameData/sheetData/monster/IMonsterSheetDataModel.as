package mainModule.model.gameData.sheetData.monster
{

	/**
	 * 怪物数值表 
	 * @author Edward
	 * 
	 */	
	public interface IMonsterSheetDataModel
	{
		/**
		 * 通过怪物id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getMonsterSheetById(id:uint):IMonsterSheetItem;
	}
}