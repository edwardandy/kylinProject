package mainModule.model.gameData.sheetData.interfaces
{
	/**
	 * 战斗单位的数据表项
	 * @author Edward
	 * 
	 */
	public interface IBaseFighterSheetItem extends IBaseDescSheetItem
	{
		/**
		 * 附加资源
		 */
		function get otherResIds():String;
		/**
		 * 单位体型大小 1:小 2:中 3:大 
		 */
		function get size():int;
		/**
		 * 子弹到达目标后发生的爆炸效果，0表示子弹到达目标后直接造成伤害无爆炸
		 */
		function get explode():uint;
		/**
		 * 远程单位发出的武器子弹ID
		 */
		function get weapon():uint;
		/**
		 * 攻击速度
		 * 多长时间攻击一次 
		 * 单位 毫秒
		 */
		function get atkInterval():int;
		/**
		 * 攻击类型 1:物理伤害 2:魔法伤害 3:物理+魔法伤害
		 */
		function get atkType():int;
		/**
		 * 区域攻击影响的范围
		 */
		function get atkRange():int;
		/**
		 * 拦截范围  敌人进入该范围内则进行拦截并且切换到近战
		 * 0为默认值
		 * 单位 像素
		 */
		function get searchArea():int;
		/**
		 *攻击范围 
		 * 全屏-1
		 * 兵营指摆放范围
		 * 其他指攻击范围
		 * 单位 像素
		 */
		function get atkArea():int;
		/**
		 *最大攻击 
		 */
		function get maxAtk():int;
		/**
		 *最小攻击 
		 */
		function get minAtk():int;
		/**
		 * 技能表
		 */
		function get skillIds():Array;
		/**
		 * 技能使用信息表(SkillUseUnit)
		 */
		function get skillUseUnits():Array;
	}
}