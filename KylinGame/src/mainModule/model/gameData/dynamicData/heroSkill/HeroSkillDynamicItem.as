package mainModule.model.gameData.dynamicData.heroSkill
{
	import mainModule.model.gameData.dynamicData.BaseDynamicItem;

	/**
	 * 英雄技能动态项 
	 * @author Edward
	 * 
	 */	
	public class HeroSkillDynamicItem extends BaseDynamicItem implements IHeroSkillDynamicItem
	{
		private var _level:int;
		private var _heroId:uint;
		private var _skillId:uint;
		
		public function HeroSkillDynamicItem()
		{
			super();
		}

		/**
		 * 技能模板id
		 */
		public function get skillId():uint
		{
			return _skillId;
		}

		/**
		 * @private
		 */
		public function set skillId(value:uint):void
		{
			_skillId = value;
		}

		/**
		 * 所属的英雄id 
		 */
		public function get heroId():uint
		{
			return _heroId;
		}

		/**
		 * @private
		 */
		public function set heroId(value:uint):void
		{
			_heroId = value;
		}

		/**
		 * 技能等级 
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