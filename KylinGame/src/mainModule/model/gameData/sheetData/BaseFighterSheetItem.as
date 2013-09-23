package mainModule.model.gameData.sheetData
{	
	import mainModule.model.gameData.sheetData.skill.SkillUseUnit;

	/**
	 * 战斗单位的数据表项
	 * @author Edward
	 * 
	 */	
	public class BaseFighterSheetItem extends BaseDescSheetItem
	{
		/**
		 *最小攻击 
		 */
		public var minAtk:int;
		/**
		 *最大攻击 
		 */
		public var maxAtk:int;
		/**
		 *攻击范围 
		 * 全屏-1
		 * 兵营指摆放范围
		 * 其他指攻击范围
		 * 单位 像素
		 */
		public var atkArea:int;
		/**
		 * 拦截范围  敌人进入该范围内则进行拦截并且切换到近战
		 * 0为默认值
		 * 单位 像素
		 */
		public var searchArea:int;
		/**
		 * 区域攻击影响的范围
		 */
		public var atkRange:int;
		/**
		 * 攻击类型 1:物理伤害 2:魔法伤害 3:物理+魔法伤害
		 */
		public var atkType:int;
		/**
		 * 攻击速度
		 * 多长时间攻击一次 
		 * 单位 毫秒
		 */
		public var atkInterval:int;
		/**
		 * 远程单位发出的武器子弹ID
		 */
		public var weapon:uint;	
		/**
		 * 子弹到达目标后发生的爆炸效果，0表示子弹到达目标后直接造成伤害无爆炸
		 */
		public var explode:uint;	
		/**
		 * 单位体型大小 1:小 2:中 3:大 
		 */		
		public var size:int;
		/**
		 * 附加资源
		 */
		public var otherResIds:String;
		/**
		 * 技能表(如果是英雄，则只包括无需解锁的技能)
		 * id:action(施法动作：0/1/id):odds(施放概率),...
		 * "152033,152034"
		 */
		private var _skills:String;
		private var _skillIds:Array = [];
		private var _skillUseUnits:Array = [];
		
		public function BaseFighterSheetItem()
		{
			super();
		}
		
		/**
		 * 解析技能数据
		 */
		public function set skills(value:String):void 
		{
			_skills = value;
			_skillIds.length = 0;
			_skillUseUnits.length = 0;
			
			var arrResult:Array = _skills.split(",");
			var arrSub:Array;
			var useUnit:SkillUseUnit;
			for each(var str:String in arrResult)
			{
				arrSub = str.split(":");	
				if(arrSub[0])
				{
					useUnit = new SkillUseUnit;
					useUnit.skillId = uint(arrSub[0]);
					_skillIds.push(uint(arrSub[0]));
					if(arrSub[1])
						useUnit.action = arrSub[1];
					if(arrSub[2])
						useUnit.odds = arrSub[2];
					_skillUseUnits.push(useUnit);
				}
				
			}
		}
		/**
		 * 技能表
		 */
		public function get skillIds():Array 
		{
			return _skillIds;
		}
		/**
		 * 技能使用信息表(SkillUseUnit)
		 */
		public function get skillUseUnits():Array
		{
			return _skillUseUnits;
		}
	}
}