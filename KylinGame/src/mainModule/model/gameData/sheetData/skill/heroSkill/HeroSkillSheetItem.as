package mainModule.model.gameData.sheetData.skill.heroSkill
{
	import mainModule.model.gameData.sheetData.skill.BaseOwnerSkillSheetItem;
	/**
	 * 英雄技能数值表项 
	 * @author Edward
	 * 
	 */	
	public class HeroSkillSheetItem extends BaseOwnerSkillSheetItem
	{
		/**
		 * 成长值 
		 */		
		public var growth:Number;
		/**
		 * 成长值描述 
		 */		
		public var growthEffect:String;
		/**
		 * 技能解锁的等级 
		 */		
		public var unlockLevel:int;
		
		public function HeroSkillSheetItem()
		{
			super();
		}
	}
}