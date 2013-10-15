package mainModule.model.gameData.dynamicData.magicSkill
{
	import mainModule.model.gameData.dynamicData.BaseDynamicItem;

	/**
	 * 魔法动态项 
	 * @author Edward
	 * 
	 */	
	public class MagicSkillDynamicItem extends BaseDynamicItem implements IMagicSkillDynamicItem
	{
		private var _level:int;
		
		public function MagicSkillDynamicItem()
		{
			super();
		}

		/**
		 * 魔法等级 
		 */
		public function get level():int
		{
			return _level;
		}

		/**
		 * @private
		 */
		public function set level(value:int):void
		{
			_level = value;
		}

	}
}