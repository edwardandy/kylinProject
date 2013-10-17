package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters
{
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;

	/**
	 * 冰晶凤凰
	 */
	public class IcePhoenix extends BasicMonsterElement
	{
		public function IcePhoenix(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onBodyStay():void
		{
			onDiedAnimationEndHandlerStep2();
		}
		
		override protected function onSkillDisappear():void
		{
			if(SkillID.SoulOfIce == myFightState.curUseSkillId)
				return;
			super.onSkillDisappear();
		}
	}
}