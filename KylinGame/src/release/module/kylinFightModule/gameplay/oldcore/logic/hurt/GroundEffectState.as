package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	public class GroundEffectState implements IDisposeObject
	{
		public var effId:uint = 0;
		public var duration:int = 0;
		public var arrParam:Array;
		
		public function GroundEffectState()
		{
		}
		
		public function dispose():void
		{
			effId = 0;
			duration = 0;
			arrParam = null;
		}
	}
}