package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.SummonByOrganisms;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 自然之力
	 */
	public class PowerOfNatural extends HeroElement
	{
		public function PowerOfNatural(typeId:int)
		{
			super(typeId);
		}
		
		override public function moveToAppointPointByPath(pathPoints:Vector.<PointVO>):void
		{
			super.moveToAppointPointByPath(pathPoints);
			if(mySummonPets.isEmpty())
				return;
			mySummonPets.eachValue(notifyPetsCheckMove);
		}
		
		private function notifyPetsCheckMove(pets:Array):void
		{
			for each(var pet:SummonByOrganisms in pets)
			{
				pet.notifyMasterMoved();
			}
		}
	}
}