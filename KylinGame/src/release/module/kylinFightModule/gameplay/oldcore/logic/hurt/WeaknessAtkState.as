package release.module.kylinFightModule.gameplay.oldcore.logic.hurt
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	
	public class WeaknessAtkState implements IDisposeObject
	{
		public var bHasState:Boolean = false;
		public var lastTarget:BasicOrganismElement;
		public var addtionAtk:int = 0;
		/**
		 * 连续攻击的次数
		 */
		public var atkTimes:int = 0;
		public function WeaknessAtkState()
		{
		}
		
		public function dispose():void
		{
			bHasState = false;
			lastTarget = null;
			addtionAtk = 0;
			atkTimes = 0;
		}
	}
}