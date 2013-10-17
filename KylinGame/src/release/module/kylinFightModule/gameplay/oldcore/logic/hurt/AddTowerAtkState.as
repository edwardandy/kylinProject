package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	public class AddTowerAtkState implements IDisposeObject
	{
		public var bHasState:Boolean = false;
		public var iAtkPct:int = 0;
		public var iArea:int = 0;
		
		public function AddTowerAtkState()
		{
		}
		
		public function dispose():void
		{
			bHasState = false;
			iAtkPct = 0;
			iArea = 0;
		}
	}
}