package mainModule.model.gameData.dynamicData.magicSkill
{
	import mainModule.model.gameData.dynamicData.interfaces.IBaseDynamicItem;

	/**
	 * 魔法动态项 
	 * @author Edward
	 * 
	 */
	public interface IMagicSkillDynamicItem extends IBaseDynamicItem
	{
		/**
		 * 魔法等级 
		 */
		function get level():int;
	}
}