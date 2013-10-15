package mainModule.model.gameData.sheetData.skill.magic
{	
	import mainModule.model.gameData.sheetData.skill.IBaseSkillSheetItem;

	/**
	 * 法术数值表项 
	 * @author Edward
	 * 
	 */	
	public interface IMagicSkillSheetItem extends IBaseSkillSheetItem
	{
		/**
		 * 进阶冷却时间 单位 秒
		 */
		function get adCoolTime():int;
		/**
		 * 升级冷却时间  单位 秒
		 */
		function get coolTime():int;
		/**
		 * 图标id 
		 */
		function get iconId():uint;
		/**
		 * 指针id，施放法术时显示
		 */
		function get cursorId():int;
		/**
		 * 法术释放方式 
		 * 0:点技能就释放
		 * 1：地图任意位置都可以释放
		 * 2：只能在路上放
		 * 3：只能作用于单体怪物
		 * 4:必须在路的中间位置释放 
		 */
		function get releaseWay():int;
		/**
		 * 法术使用积分
		 */
		function get rewardScore():uint;
		/**
		 * 持续时间 毫秒
		 */
		function get duration():uint;
		/**
		 * 技能等级
		 */
		function get level():uint;
		/**
		 * 升级材料ID 格式 {888888:100,133046:1}
		 */
		function get objUpgradeCost():Object;
		/**
		 * 进阶材料ID 格式 {888888:100,133046:1}
		 */
		function get objAdvancedeCost():Object;
	}
}