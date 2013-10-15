package mainModule.model.gameData.sheetData.skill.heroSkill
{
	import mainModule.model.gameData.sheetData.skill.BaseOwnerSkillSheetItem;
	/**
	 * 英雄技能数值表项 
	 * @author Edward
	 * 
	 */	
	public class HeroSkillSheetItem extends BaseOwnerSkillSheetItem implements IHeroSkillSheetItem
	{
		private var _growth:Number;
		private var _growthEffect:String;
		private var _unlockLevel:int;
		
		public function HeroSkillSheetItem()
		{
			super();
		}

		/**
		 * 技能解锁的等级 
		 */
		public function get unlockLevel():int
		{
			return _unlockLevel;
		}

		/**
		 * @private
		 */
		public function set unlockLevel(value:int):void
		{
			_unlockLevel = value;
		}

		/**
		 * 成长值描述 
		 */
		public function get growthEffect():String
		{
			return _growthEffect;
		}

		/**
		 * @private
		 */
		public function set growthEffect(value:String):void
		{
			_growthEffect = value;
		}

		/**
		 * 成长值 
		 */
		public function get growth():Number
		{
			return _growth;
		}

		/**
		 * @private
		 */
		public function set growth(value:Number):void
		{
			_growth = value;
		}

	}
}