package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.Heros
{
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	/**
	 * 影子武士
	 */
	public class ShadowWarrior extends HeroElement
	{
		public function ShadowWarrior(typeId:int)
		{
			super(typeId);
		}
		
		override protected function fireToTargetEnemy():void
		{
			if(currentBehaviorState == OrganismBehaviorState.NEAR_FIHGTTING)
			{
				if(myFightState.iMultyAtk>1 && mySearchedEnemy)
				{
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.SPELL_SUFFIX+SkillID.MultyAttack+"_"+GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
						GameMovieClipFrameNameType.SPELL_SUFFIX+SkillID.MultyAttack+"_"+GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, null,
						GameMovieClipFrameNameType.SPELL_SUFFIX+SkillID.MultyAttack+"_"+GameMovieClipFrameNameType.FIRE_POINT, onFireAnimationTimeHandler);
					playSkillSound(SkillID.MultyAttack);
				}
				else
				{
					bChangeFightAction = GameMathUtil.randomTrueByProbability(0.5);
					
					myBodySkin.gotoAndPlay2(getNearAttackTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
						getNearAttackTypeStr() + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, null,
						getNearFirePointTypeStr(), onFireAnimationTimeHandler);	
				}
			}
		}
	}
}