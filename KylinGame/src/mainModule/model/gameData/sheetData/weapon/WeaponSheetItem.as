package mainModule.model.gameData.sheetData.weapon
{
	import mainModule.model.gameData.sheetData.BaseSheetItem;

	/**
	 * 子弹数值表项 
	 * @author Edward
	 * 
	 */	
	public class WeaponSheetItem extends BaseSheetItem implements IWeaponSheetItem
	{
		private var _type:uint;
		private var _duration:int;
		private var _updateAngle:Boolean;
		private var _specialTip:int;	
		private var _effect:String;
		private var _resId:uint;
		private var _otherResIds:String;
		private var _specialEffect:uint;
		
		public function WeaponSheetItem()
		{
			super();
		}

		/**
		 * 子弹所带的爆炸id 
		 */
		public function get specialEffect():uint
		{
			return _specialEffect;
		}

		/**
		 * @private
		 */
		public function set specialEffect(value:uint):void
		{
			_specialEffect = value;
		}

		/**
		 * 其他资源id，以逗号分隔
		 */
		public function get otherResIds():String
		{
			return _otherResIds;
		}

		/**
		 * @private
		 */
		public function set otherResIds(value:String):void
		{
			_otherResIds = value;
		}

		/**
		 * 资源id，如没有，则默认与自身id相同 
		 */
		public function get resId():uint
		{
			return _resId;
		}

		/**
		 * @private
		 */
		public function set resId(value:uint):void
		{
			_resId = value;
		}

		/**
		 *武器特效
		 * 用来描述被这个子弹触发的buff效果～
		 * buff:22015,duration:3000,pct:50 
		 */
		public function get effect():String
		{
			return _effect;
		}

		/**
		 * @private
		 */
		public function set effect(value:String):void
		{
			_effect = value;
		}

		/**
		 *增加一个场景提示字段
		 * int类型保存的是一个id 
		 */
		public function get specialTip():int
		{
			return _specialTip;
		}

		/**
		 * @private
		 */
		public function set specialTip(value:int):void
		{
			_specialTip = value;
		}

		/**
		 * 是否需要矫正角度
		 */
		public function get updateAngle():Boolean
		{
			return _updateAngle;
		}

		/**
		 * @private
		 */
		public function set updateAngle(value:Boolean):void
		{
			_updateAngle = value;
		}

		/**
		 *子弹持续时间 
		 */
		public function get duration():int
		{
			return _duration;
		}

		/**
		 * @private
		 */
		public function set duration(value:int):void
		{
			_duration = value;
		}

		/**
		 * 类型
		 * 
		 * 1抛物线箭矢飞行类 2抛物线炮弹飞行类 3直线飞行类 4连线类（激光） 5无子弹类 6多段伤害 7跟踪弹
		 */
		public function get type():uint
		{
			return _type;
		}

		/**
		 * @private
		 */
		public function set type(value:uint):void
		{
			_type = value;
		}

	}
}