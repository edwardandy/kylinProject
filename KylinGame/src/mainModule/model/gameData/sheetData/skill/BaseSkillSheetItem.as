package mainModule.model.gameData.sheetData.skill
{	
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.BaseDescSheetItem;

	/**
	 * 法术，技能数值表项基类 
	 * @author Edward
	 * 
	 */	
	public class BaseSkillSheetItem extends BaseDescSheetItem implements IBaseSkillSheetItem
	{
		private var _type:int;
		/**
		 *技能直接效果  "dmg:10-100,summon:10000"
		 */
		private var _objEffect:Object;
		/**
		 *主buff 
		 */
		private var _buff:String;
		private var _arrBuffs:Array;
		private var _canAirFight:uint;
		private var _range:int;
		private var _cdTime:int;
		private var _atkArea:int;
		private var _atkType:int;
		private var _resId:uint;
		private var _otherResIds:String;
		
		public function BaseSkillSheetItem()
		{
			super();
		}
		
		/**
		 * 附加资源
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
		 * 资源id，技能本身的特效，比如奥术弹幕
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
		 * 攻击类型 1只有物理攻击 2表示只有魔法攻击 3物理+魔法
		 */
		public function get atkType():int
		{
			return _atkType;
		}

		/**
		 * @private
		 */
		public function set atkType(value:int):void
		{
			_atkType = value;
		}

		/**
		 * 攻击距离
		 */
		public function get atkArea():int
		{
			return _atkArea;
		}

		/**
		 * @private
		 */
		public function set atkArea(value:int):void
		{
			_atkArea = value;
		}

		/**
		 *CD 单位  秒 
		 */
		public function get cdTime():int
		{
			return _cdTime;
		}

		/**
		 * @private
		 */
		public function set cdTime(value:int):void
		{
			_cdTime = value;
		}

		/**
		 *作用范围
		 * 单位：像素 
		 */
		public function get range():int
		{
			return _range;
		}

		/**
		 * @private
		 */
		public function set range(value:int):void
		{
			_range = value;
		}

		/**
		 * 是否对空  1:只对地  2:只对空  3:对地对空
		 */
		public function get canAirFight():uint
		{
			return _canAirFight;
		}

		/**
		 * @private
		 */
		public function set canAirFight(value:uint):void
		{
			_canAirFight = value;
		}

		/**
		 * MagicSkill表示
		 *		1：援兵2：皇家卫士3：神兵4：闪电5：落雷6：激光7: 冰雹8: 暴风雪 9: 冰尖柱 
		 * Skill和HeroSkill表示
		 * 		1 主动	 0 被动
		 */
		public function get type():int
		{
			return _type;
		}
		
		/**
		 * @private
		 */
		public function set type(value:int):void
		{
			_type = value;
		}
		
		public function set effect(s:String):void
		{
			if(!s)
				return;
			_objEffect = KylinStringUtil.parseCommaString(s);
		}
		/**
		 *技能直接效果对象  {dmg:"10-100",summon:"10000"}
		 */
		public function get objEffect():Object
		{
			return _objEffect;
		}
		
		public function set buff(str:String):void
		{
			if(!str)
				return;
			_arrBuffs = KylinStringUtil.parseSplitString(str);
		}
		/**
		 * buff对象数组，格式：[{buff:"20000",dmg:"10-100",summon:"10000"},{buff:"20001",dmg:"20-200",summon:"20000"}] 
		 * @return 
		 * 
		 */		
		public function getBuffs():Array
		{
			return _arrBuffs;
		}
	}
}