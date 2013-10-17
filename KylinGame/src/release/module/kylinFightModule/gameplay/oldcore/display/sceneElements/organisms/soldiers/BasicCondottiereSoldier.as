package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers
{
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;

	public class BasicCondottiereSoldier extends BasicOrganismElement
	{
		public function BasicCondottiereSoldier(typeId:int)
		{	
			super(typeId);	
			this.myCampType = FightElementCampType.FRIENDLY_CAMP;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();	
		}
		
		override protected function initStateWhenActive():void
		{
			this.myCampType = FightElementCampType.FRIENDLY_CAMP;
			super.initStateWhenActive();
			myAppointPoint.x = this.x;
			myAppointPoint.y = this.y;
			
			changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
		}
		
		override protected function onResurrectionComplete():void
		{
			super.onResurrectionComplete();
			
			backToCurrentAppointPoint();
		}
	}
}