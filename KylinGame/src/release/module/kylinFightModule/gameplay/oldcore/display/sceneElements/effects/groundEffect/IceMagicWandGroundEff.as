package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects.MagicSkillEffectBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.hurt.GroundEffectState;

	/**
	 * 全屏寒冰冻结时随机显示的地表冰冻特效 
	 * @author Edward
	 * 
	 */	
	public class IceMagicWandGroundEff extends BasicGroundEffect
	{
		public function IceMagicWandGroundEff(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();		
			
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.APPEAR);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.APPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1,onAppearEnd);
					break;
				case MagicSkillEffectBehaviorState.DISAPPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1,destorySelf);
					break;
				case MagicSkillEffectBehaviorState.RUNNING:
					myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.IDLE);
					break;
			}
		}
		
		override protected function onAppearEnd():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
		}
		
		public function disappear():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
		}
	}
}