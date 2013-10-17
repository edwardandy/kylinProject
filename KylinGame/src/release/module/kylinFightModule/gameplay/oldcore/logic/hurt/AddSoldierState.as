package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
		
	public class AddSoldierState implements IDisposeObject
	{
		public var bHasState:Boolean = false;
		public var iAtkArea:int = 0;
		public var iAtkPct:int = 0;
		public var iDefArea:int = 0;
		public var iDef:int = 0;
		public function AddSoldierState()
		{
		}
		
		public function dispose():void
		{
			bHasState = false;
			iAtkPct = 0;
			iAtkArea = 0;
			iDef = 0;
			iDefArea = 0;
		}
	}
}