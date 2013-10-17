package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	public final class BetrayState implements IDisposeObject
	{
		public var bBetrayed:Boolean = false;
		public var betrayCamp:int = 0;
		public function BetrayState()
		{
		}
		
		public function dispose():void
		{
			bBetrayed = false;
			betrayCamp = 0;
		}
	}
}