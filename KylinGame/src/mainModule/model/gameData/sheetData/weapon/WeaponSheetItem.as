package mainModule.model.gameData.sheetData.weapon
{
	import mainModule.model.gameData.sheetData.BaseDescSheetItem;
	/**
	 * 子弹数值表项 
	 * @author Edward
	 * 
	 */	
	public class WeaponSheetItem extends BaseDescSheetItem
	{
		/**
		 * 类型
		 * 
		 * 1抛物线箭矢飞行类 2抛物线炮弹飞行类 3直线飞行类 4连线类（激光） 5无子弹类 6多段伤害 7跟踪弹
		 */
		public var type:uint;
		/**
		 *子弹持续时间 
		 */
		public var duration:int;
		/**
		 * 是否需要矫正角度
		 */
		public var updateAngle:Boolean;
		/**
		 *增加一个场景提示字段
		 * int类型保存的是一个id 
		 */
		public var specialTip:int;	
		/**
		 *武器特效
		 * 用来描述被这个子弹触发的buff效果～
		 * buff:22015,duration:3000,pct:50 
		 */
		public var effect:String;
		
		/**
		 * 资源id，如没有，则默认与自身id相同 
		 */		
		public var resId:uint;
		/**
		 * 其他资源id，以逗号分隔
		 */		
		public var otherResIds:String;
		public function WeaponSheetItem()
		{
			super();
		}
	}
}