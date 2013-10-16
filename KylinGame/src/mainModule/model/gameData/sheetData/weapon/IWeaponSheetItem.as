package mainModule.model.gameData.sheetData.weapon
{
	import mainModule.model.gameData.sheetData.interfaces.IBaseSheetItem;
	
	public interface IWeaponSheetItem extends IBaseSheetItem
	{
		/**
		 * 其他资源id，以逗号分隔
		 */
		function get otherResIds():String;
		/**
		 * 资源id，如没有，则默认与自身id相同 
		 */
		function get resId():uint;
		/**
		 *武器特效
		 * 用来描述被这个子弹触发的buff效果～
		 * buff:22015,duration:3000,pct:50 
		 */
		function get effect():String;
		/**
		 *增加一个场景提示字段
		 * int类型保存的是一个id 
		 */
		function get specialTip():int
		/**
		 * 是否需要矫正角度
		 */
		function get updateAngle():Boolean;
		/**
		 *子弹持续时间 
		 */
		function get duration():int;
		/**
		 * 类型
		 * 
		 * 1抛物线箭矢飞行类 2抛物线炮弹飞行类 3直线飞行类 4连线类（激光） 5无子弹类 6多段伤害 7跟踪弹
		 */
		function get type():uint;
		/**
		 * 子弹所带的爆炸id 
		 */
		function get specialEffect():uint;
	}
}