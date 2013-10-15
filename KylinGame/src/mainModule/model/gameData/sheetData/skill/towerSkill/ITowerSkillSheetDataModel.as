package mainModule.model.gameData.sheetData.skill.towerSkill
{

	/**
	 * 塔技能数值表 
	 * @author Edward
	 * 
	 */	
	public interface ITowerSkillSheetDataModel
	{
		/**
		 * 通过塔技能id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getTowerSkillSheetById(id:uint):ITowerSkillSheetItem;
	}
}