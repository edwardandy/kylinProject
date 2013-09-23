package mainModule.model.gameData.sheetData.interfaces
{
	import mainModule.model.gameData.sheetData.skill.monsterSkill.MonsterSkillSheetItem;

	/**
	 * 怪物技能数值表 
	 * @author Edward
	 * 
	 */	
	public interface IMonsterSkillSheetDataModel
	{
		/**
		 * 通过怪物技能id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getMonsterSkillSheetById(id:uint):MonsterSkillSheetItem;
	}
}