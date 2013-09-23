package mainModule.model.gameData.sheetData.skill.monsterSkill
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IMonsterSkillSheetDataModel;

	/**
	 * 怪物技能数值表 
	 * @author Edward
	 * 
	 */	
	public class MonsterSkillSheetDataModel extends BaseSheetDataModel implements IMonsterSkillSheetDataModel
	{
		public function MonsterSkillSheetDataModel()
		{
			super();
			sheetName = "monsterSkillSheetData";
			sheetClass = MonsterSkillSheetItem;
		}
		
		public function getMonsterSkillSheetById(id:uint):MonsterSkillSheetItem
		{
			return genSheetElement(id) as MonsterSkillSheetItem;
		}
	}
}