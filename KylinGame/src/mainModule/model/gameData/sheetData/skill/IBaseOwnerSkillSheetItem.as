package mainModule.model.gameData.sheetData.skill
{
	/**
	 * 拥有使用者的技能数据表项，除了法术外的英雄技能、塔技能和怪物技能 
	 * @author Edward
	 * 
	 */	
	public interface IBaseOwnerSkillSheetItem extends IBaseSkillSheetItem
	{
		/**
		 * 作用对象的数量
		 */
		function get targetCount():int;
		/**
		 * 使用的触发条件
		 */
		function get triggerType():int;
		/**
		 * 特殊类型
		 * 0或不填表示非特殊类型
		 * 1表示普通攻击时会附带buff
		 * 2表示只要cd时间一到就必定使用
		 */
		function get specialType():int;
		/**
		 * 引导持续时间
		 */
		function get chantDuration():uint;
	/**
		 * 是否需要引导
		 */
		function get needChant():Boolean;
		/**
		 * 子弹到达目标后发生的爆炸效果，0表示子弹到达目标后直接造成伤害无爆炸
		 */
		function get explode():uint;
		/**
		 * 子弹数量 0表示每个目标一个子弹
		 */
		function get weaponCount():uint;
		/**
		 * 子弹id
		 */
		function get weapon():uint;
		/**
		 * 作用对象类型 1:self;2:本方生物单位;4:敌方生物单位;8:对塔有效
		 */
		function get targetType():uint;
		/**
		 * 作用目标是否包含在SkillTargetTypeConst中枚举的某类对象
		 * @param uType SkillTargetTypeConst枚举值
		 * @return 
		 * 
		 */		
		function hasTargetType(uType:uint):Boolean;
	}
}