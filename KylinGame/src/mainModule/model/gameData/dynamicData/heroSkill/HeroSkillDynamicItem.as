package mainModule.model.gameData.dynamicData.heroSkill
{
	import mainModule.model.gameData.dynamicData.BaseDynamicItem;
	/**
	 * 英雄技能动态项 
	 * @author Edward
	 * 
	 */	
	public class HeroSkillDynamicItem extends BaseDynamicItem
	{
		/**
		 * 技能等级 
		 */		
		public var level:int;
		/**
		 * 所属的英雄id 
		 */		
		public var heroId:uint;
		/**
		 * 技能模板id
		 */		
		public var skillId:uint;
		
		public function HeroSkillDynamicItem()
		{
			super();
		}
	}
}