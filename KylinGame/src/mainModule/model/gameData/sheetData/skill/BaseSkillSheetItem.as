package mainModule.model.gameData.sheetData.skill
{	
	import kylin.echo.edward.utilities.string.KylinStringUtil;
	
	import mainModule.model.gameData.sheetData.BaseDescSheetItem;

	/**
	 * 法术，技能数值表项基类 
	 * @author Edward
	 * 
	 */	
	public class BaseSkillSheetItem extends BaseDescSheetItem
	{
		/**
		 * MagicSkill表示
		 *		1：援兵2：皇家卫士3：神兵4：闪电5：落雷6：激光7: 冰雹8: 暴风雪 9: 冰尖柱 
		 * Skill和HeroSkill表示
		 * 		1 主动	 0 被动
		 */
		public var type:int;
		/**
		 *技能直接效果  "dmg:10-100,summon:10000"
		 */
		private var _objEffect:Object;
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
		/**
		 *主buff 
		 */
		private var _buff:String;
		private var _arrBuffs:Array;
		/**
		 * 是否对空  1:只对地  2:只对空  3:对地对空
		 */
		public var canAirFight:uint;
		/**
		 *作用范围
		 * 单位：像素 
		 */
		public var range:int;
		/**
		 *CD 单位  秒 
		 */
		public var cdTime:int;
		/**
		 * 攻击距离
		 */
		public var atkArea:int;
		/**
		 * 攻击类型 1只有物理攻击 2表示只有魔法攻击 3物理+魔法
		 */
		public var atkType:int;
		/**
		 * 资源id，技能本身的特效，比如奥术弹幕
		 */
		public var resId:uint;
		/**
		 * 附加资源
		 */
		public var otherResIds:String;
		
		public function BaseSkillSheetItem()
		{
			super();
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