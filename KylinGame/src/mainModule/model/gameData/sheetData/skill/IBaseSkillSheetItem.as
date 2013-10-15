package mainModule.model.gameData.sheetData.skill
{	
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;

	/**
	 * 法术，技能数值表项基类 
	 * @author Edward
	 * 
	 */	
	public interface IBaseSkillSheetItem extends IBaseSheetItem
	{
		/**
		 * 附加资源
		 */
		function get otherResIds():String;
		/**
		 * 资源id，技能本身的特效，比如奥术弹幕
		 */
		function get resId():uint;
		/**
		 * 攻击类型 1只有物理攻击 2表示只有魔法攻击 3物理+魔法
		 */
		function get atkType():int;
		/**
		 * 攻击距离
		 */
		function get atkArea():int;
		/**
		 *CD 单位  秒 
		 */
		function get cdTime():int;
		/**
		 *作用范围
		 * 单位：像素 
		 */
		function get range():int;
		/**
		 * 是否对空  1:只对地  2:只对空  3:对地对空
		 */
		function get canAirFight():uint;
		/**
		 * MagicSkill表示
		 *		1：援兵2：皇家卫士3：神兵4：闪电5：落雷6：激光7: 冰雹8: 暴风雪 9: 冰尖柱 
		 * Skill和HeroSkill表示
		 * 		1 主动	 0 被动
		 */
		function get type():int;
	/**
		 *技能直接效果对象  {dmg:"10-100",summon:"10000"}
		 */
		function get objEffect():Object;
		/**
		 * buff对象数组，格式：[{buff:"20000",dmg:"10-100",summon:"10000"},{buff:"20001",dmg:"20-200",summon:"20000"}] 
		 * @return 
		 * 
		 */		
		function getBuffs():Array;
	}
}