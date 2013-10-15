package mainModule.model.gameData.sheetData.skill.heroSkill
{
	/**
	 * 英雄技能数值表项 
	 * @author Edward
	 * 
	 */
	public interface IHeroSkillSheetItem extends IBaseOwnerSkillSheetItem
	{
		/**
		 * 技能解锁的等级 
		 */
		function get unlockLevel():int;
		/**
		 * 成长值描述 
		 */
		function get growthEffect():String;
		/**
		 * 成长值 
		 */
		function get growth():Number;
	}
}