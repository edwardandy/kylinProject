package mainModule.model.gameData.sheetData.skill.towerSkill
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

	/**
	 * 塔技能数值表 
	 * @author Edward
	 * 
	 */	
	public class TowerSkillSheetDataModel extends BaseSheetDataModel implements ITowerSkillSheetDataModel
	{
		public function TowerSkillSheetDataModel()
		{
			super();
			sheetName = "towerSkillSheetData";
			sheetClass = TowerSkillSheetItem;
		}
		
		public function getTowerSkillSheetById(id:uint):ITowerSkillSheetItem
		{
			return genSheetElement(id) as ITowerSkillSheetItem;
		}
	}
}