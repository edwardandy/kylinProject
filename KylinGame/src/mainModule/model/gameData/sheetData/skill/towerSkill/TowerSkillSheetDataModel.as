package mainModule.model.gameData.sheetData.skill.towerSkill
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.ITowerSkillSheetDataModel;

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
		
		public function getTowerSkillSheetById(id:uint):TowerSkillSheetItem
		{
			return genSheetElement(id) as TowerSkillSheetItem;
		}
	}
}