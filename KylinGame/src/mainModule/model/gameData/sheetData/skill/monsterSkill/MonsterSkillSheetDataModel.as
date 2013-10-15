package mainModule.model.gameData.sheetData.skill.monsterSkill
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

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
		
		public function getMonsterSkillSheetById(id:uint):IMonsterSkillSheetItem
		{
			return genSheetElement(id) as IMonsterSkillSheetItem;
		}
	}
}