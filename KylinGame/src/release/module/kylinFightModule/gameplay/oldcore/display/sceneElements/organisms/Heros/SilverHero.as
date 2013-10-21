package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros
{
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;

	/**
	 * 白银骑士
	 */
	public class SilverHero extends HeroElement
	{
		public function SilverHero(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			if(OrganismBehaviorState.BLOCK == currentBehaviorState)
			{
				myBodySkin.gotoAndPlay2("spell_1_appear_start","spell_1_appear_end",1,onBlockEnd);
				playSkillSound(SkillID.ShieldBlock);
			}
		}
		
		override protected function onBlockAttack():void
		{
			super.onBlockAttack();
			changeToTargetBehaviorState(OrganismBehaviorState.BLOCK);
		}
		
		private function onBlockEnd():void
		{
			if(currentSearchedEnemy)
				changeToTargetBehaviorState(OrganismBehaviorState.NEAR_FIHGTTING);
			else
				changeToTargetBehaviorState(OrganismBehaviorState.IDLE);
		}
	}
}