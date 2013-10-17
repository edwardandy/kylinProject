package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	public final class BeastAngryState implements IDisposeObject
	{
		public var bHasState:Boolean = false;
		public var iLifeDownPct:int = 0;
		public var iAtkArea:int = 0;
		public var iAtkSpd:int = 0;
		public var iMoveSpd:int = 0;
		
		public function BeastAngryState()
		{
		}
		
		public function dispose():void
		{
			bHasState = false;
			iLifeDownPct = 0;
			iAtkArea = 0;
			iAtkSpd = 0;
			iMoveSpd = 0;
		}
	}
}