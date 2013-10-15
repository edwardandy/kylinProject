package mainModule.model.gameData.dynamicData.heroSkill
{
	import mainModule.model.gameData.dynamicData.interfaces.IBaseDynamicItem;

	/**
	 * 英雄技能动态项 
	 * @author Edward
	 * 
	 */
	public interface IHeroSkillDynamicItem extends IBaseDynamicItem
	{
		/**
		 * 技能模板id
		 */
		function get skillId():uint;
		/**
		 * 所属的英雄id 
		 */
		function get heroId():uint;
		/**
		 * 技能等级 
		 */
		function get level():int;
	}
}