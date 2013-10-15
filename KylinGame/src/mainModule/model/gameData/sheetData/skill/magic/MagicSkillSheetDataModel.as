package mainModule.model.gameData.sheetData.skill.magic
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;

	/**
	 * 法术数值表 
	 * @author Edward
	 * 
	 */	
	public class MagicSkillSheetDataModel extends BaseSheetDataModel implements IMagicSkillSheetDataModel
	{
		public function MagicSkillSheetDataModel()
		{
			super();
			sheetName = "magicSheetData";
			sheetClass = MagicSkillSheetItem;
		}
		
		public function getMagicSkillSheetById(id:uint):IMagicSkillSheetItem
		{
			return genSheetElement(id) as IMagicSkillSheetItem;
		}
	}
}