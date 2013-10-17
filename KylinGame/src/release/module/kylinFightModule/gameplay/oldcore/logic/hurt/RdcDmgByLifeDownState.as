package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	public class RdcDmgByLifeDownState implements IDisposeObject
	{
		public var bHasState:Boolean;
		public var iLifeLimitPct:int;
		public var iDmgRdcPct:int;
		public function RdcDmgByLifeDownState()
		{
		}
		
		public function dispose():void
		{
			bHasState = false;
			iLifeLimitPct = 0;
			iDmgRdcPct = 0 ;
		}
	}
}