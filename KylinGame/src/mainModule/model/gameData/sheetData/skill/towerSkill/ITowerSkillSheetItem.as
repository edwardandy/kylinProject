package mainModule.model.gameData.sheetData.skill.towerSkill
{	
	import mainModule.model.gameData.sheetData.skill.IBaseOwnerSkillSheetItem;

	/**
	 * 塔技能数值表项 
	 * @author Edward
	 * 
	 */
	public interface ITowerSkillSheetItem extends IBaseOwnerSkillSheetItem
	{
		/**
		 * 升级冷却时间  单位 秒
		 */
		function get coolTime():int;
		/**
		 * 战斗内的升级价格
		 */
		function get buyGold():uint;
		/**
		 * 升级材料ID 格式 {888888:100,133046:1}
		 */
		function get objUpgradeCost():Object;
	}
}