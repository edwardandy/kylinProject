package mainModule.model.gameData.sheetData.skill.magic
{

	/**
	 * 法术数值表 
	 * @author Edward
	 * 
	 */	
	public interface IMagicSkillSheetDataModel
	{
		/**
		 * 通过法术id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getMagicSkillSheetById(id:uint):IMagicSkillSheetItem
	}
}