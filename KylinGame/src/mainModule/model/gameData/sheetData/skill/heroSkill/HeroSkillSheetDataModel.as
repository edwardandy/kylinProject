package mainModule.model.gameData.sheetData.skill.heroSkill
{
	import mainModule.model.gameData.sheetData.BaseSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IHeroSkillSheetDataModel;

	/**
	 * 英雄技能数值表 
	 * @author Edward
	 * 
	 */	
	public class HeroSkillSheetDataModel extends BaseSheetDataModel implements IHeroSkillSheetDataModel
	{
		public function HeroSkillSheetDataModel()
		{
			super();
			sheetName = "heroSkillSheetData";
			sheetClass = HeroSkillSheetItem;
		}
		
		public function getHeroSkillSheetById(id:uint):HeroSkillSheetItem
		{
			return genSheetElement(id) as HeroSkillSheetItem;
		}
	}
}