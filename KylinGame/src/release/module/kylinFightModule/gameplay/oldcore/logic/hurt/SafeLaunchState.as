package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	public class SafeLaunchState implements IDisposeObject
	{
		public var hasSafeLaunch:Boolean = false;
		public var atkArea:int = 0;
		public var dmg:int = 0;
		public var stunTime:int = 0;
		public var fallAtkArea:int = 0;
		public var fallDmg:int = 0;
		
		public function SafeLaunchState()
		{
		}
		
		public function dispose():void
		{
			hasSafeLaunch = false;
			atkArea = 0;
			dmg = 0;
			stunTime = 0;
			fallAtkArea = 0;
			fallDmg = 0;
		}
	}
}