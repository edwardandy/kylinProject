package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	/**
	 * 巨匠技能 
	 * @author Edward
	 * 
	 */	
	public class ExtraAddTowerAtkState implements IDisposeObject
	{
		/**
		 * 增加工匠技能的影响范围百分比 
		 */		
		public var extraAddTowerAtkAreaPct:int;
		/**
		 *  增加工匠技能的塔强化攻击力百分比 
		 */		
		public var extraAddTowerAtkValuePct:int;
		
		public function ExtraAddTowerAtkState()
		{
		}
		
		public function dispose():void
		{
			extraAddTowerAtkAreaPct = 0;
			extraAddTowerAtkValuePct = 0;
		}
	}
}