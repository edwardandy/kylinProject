package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	public class DmgPctBySizeState implements IDisposeObject
	{
		public var bHasState:Boolean = false;
		public var iPctSmall:int = 0;
		public var iPctNormal:int = 0;
		public var iPctBig:int = 0;
		public function DmgPctBySizeState()
		{
		}
		
		public function dispose():void
		{
			bHasState = false;
			iPctSmall = 0;
			iPctNormal = 0;
			iPctBig = 0;
		}
	}
}