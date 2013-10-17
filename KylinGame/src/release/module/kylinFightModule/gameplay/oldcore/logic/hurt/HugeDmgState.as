package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	public final class HugeDmgState implements IDisposeObject
	{
		public var bHasBuff:Boolean = false;
		public var odds:int = 0;
		public var nearPct:int = 0;
		public var farPct:int = 0;
		public var bShooted:Boolean = false;
		
		public function HugeDmgState()
		{
		}
		
		public function successOdds():Boolean
		{
			return GameMathUtil.randomTrueByProbability(odds/100.0);
		}
		
		public function dispose():void
		{
			bHasBuff = false;
			odds = 0;
			nearPct = 0;
			farPct = 0;
			bShooted = false;
		}
	}
}