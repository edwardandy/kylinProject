package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseValidators.MouseCursorReleaseValidatorType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;

	public class HeroMoveMouseCursor extends BasicHasFlagMouseCursor
	{
		public function HeroMoveMouseCursor()
		{
			super();
			myMouseCursorReleaseValidatorType = MouseCursorReleaseValidatorType.ONLY_ROAD;
		}
		
		override protected function doWhenValidMouseClick(mouseCursorReleaseValidateResult:Object):void
		{
			super.doWhenValidMouseClick(mouseCursorReleaseValidateResult);
			
			//GameAGlobalManager.getInstance().gameFightInfoRecorder.addMoveHero( HeroElement(myMouseCursorSponsor).objectTypeId );
			HeroElement(myMouseCursorSponsor) && HeroElement(myMouseCursorSponsor).playMoveSound();
		}
	}
}