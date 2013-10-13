package mainModule.model.gameData.dynamicData.interfaces
{
	import mainModule.model.gameData.dynamicData.heroSkill.HeroSkillDynamicItem;

	/**
	 * 英雄技能动态数据 
	 * @author Edward
	 * 
	 */	
	public interface IHeroSkillDynamicDataModel
	{
		/**
		 * 通过英雄id和技能模板id获得英雄技能动态项 
		 * @param heroId
		 * @param skillId
		 * @return 
		 * 
		 */		
		function getHeroSkillDataById(heroId:uint,skillId:uint):HeroSkillDynamicItem;
		/**
		 * 获得某个英雄的所有技能动态项 
		 * @param heroId
		 * @return 
		 * 
		 */		
		function getHeroAllSkillData(heroId:uint):Vector.<HeroSkillDynamicItem>;
	}
}