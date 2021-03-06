package mainModule.model.gameData.sheetData.buff
{
	import flash.geom.Point;
	
	import mainModule.model.gameData.sheetData.BaseSheetItem;

	/**
	 * buff数值表项 
	 * @author Edward
	 * 
	 */
	public class BuffSheetItem extends BaseSheetItem
	{
		/**
		 *属性格式
		 * buffid,life,duration
		 */
		private var _arrMode:Array;
		/**
		 *覆盖类别
		 *旧的buff会被新的与他同类的buff覆盖掉
		 *不填或者填0表示buff不会被覆盖也不会覆盖别的buff
		 *从数字1开始，相同数字的buff表示同类。
		 **/
		public var overType:int;
		/**
		 * 资源id，如果不为0，则使用该id对应的buff的资源
		 * 否则使用自己id所对应的资源
		 */
		public var resId:int;
		/**
		 * 附加资源
		 */
		public var otherResIds:String;
		/**
		 *	该buf所能影响的boss列表
		 * 	bossid1,bossid2,...
		 */
		private var _arrEffectBosses:Array;
		/**
		 *  显示位置的相对点
		 * 	0表示在目标的头上显示
		 *	1表示在目标的脚下显示
		 *	2表示在身体中间
		 */
		public var positionType:int;
		/**
		 * 偏移位置
		 */
		private var _ptOffset:Point;

		public function BuffSheetItem()
		{
			super();
		}
		/**
		 * 偏移位置
		 */
		public function get ptOffset():Point
		{
			return _ptOffset;
		}
		
		public function set posOffset(str:String):void
		{
			if(str && str.length>0)
			{
				_ptOffset ||= new Point;
				var arr:Array = str.split(",");
				_ptOffset.x = arr[0];
				_ptOffset.y = arr[1];
			}
		}
		
		public function set buffMode(mode:String):void
		{
			if(!mode)
				return;
			_arrMode = mode.split(",");
		}
		/**
		 *属性格式
		 * ["buffid","life","duration"]
		 */
		public function get arrModes():Array
		{
			return _arrMode;
		}
		
		public function set bossEffect(boss:String):void
		{
			if(!boss)
				return;
			_arrEffectBosses = boss.split(",");
		}
		/**
		 *	该buf所能影响的boss列表
		 * 	[bossid1,bossid2]
		 */
		public function get arrEffectBosses():Array
		{
			return _arrEffectBosses;
		}
	}
}