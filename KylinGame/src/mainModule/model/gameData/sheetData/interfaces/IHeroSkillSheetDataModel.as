package mainModule.model.gameData.sheetData.interfaces
{
	import mainModule.model.gameData.sheetData.skill.heroSkill.HeroSkillSheetItem;

	/**
	 * 英雄技能数值表 
	 * @author Edward
	 * 
	 */	
	public interface IHeroSkillSheetDataModel
	{
		/**
		 * 通过英雄技能id获得配置表项数值 
		 * @param id
		 * @return 
		 * 
		 */		
		function getHeroSkillSheetById(id:uint):HeroSkillSheetItem;
	}
}