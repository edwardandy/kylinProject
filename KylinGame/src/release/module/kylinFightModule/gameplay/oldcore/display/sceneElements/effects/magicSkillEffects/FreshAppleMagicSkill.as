package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	/**
	 * 新鲜的大苹果(箭雨)
	 */
	public class FreshAppleMagicSkill extends BasicMagicSkillEffect
	{			
		public function FreshAppleMagicSkill(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			if(this.x > (GameFightConstant.SCENE_MAP_WIDTH>>1))
				myBodySkin.scaleX = -1;
			
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.APPEAR);
		}
		
		override public function render(iElapse:int):void
		{
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.RUNNING:
					//myMagicSkillCDTimer.tick();
					if(myMagicSkillCDTimer.getIsCDEnd())
					{
						changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
					}
					else
					{				
						hurtEmemyUintsBloodPerRener();
					}
					break;
			}
			
			super.render(iElapse);
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.APPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
						myBodySkinAppearAnimationEndHandler);
					break;
				
				case MagicSkillEffectBehaviorState.RUNNING:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
					break;
				
				case MagicSkillEffectBehaviorState.DISAPPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
						myBodySkinDisAppearAnimationEndHandler);
					break;
			}
		}
		
		private function hurtEmemyUintsBloodPerRener():void
		{
			var targets:Vector.<BasicOrganismElement> = GameAGlobalManager.getInstance()
				.groundSceneHelper.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);
			
			//这里是每个render的伤害 1s 的
			var hurtValue:uint = myMagicHurtValue / GameFightConstant.GAME_PER_FRAME_TIME;
			
			var n:uint = targets.length;
			for(var i:uint = 0; i < n; i++)
			{
				var target:BasicOrganismElement = targets[i];
				target.hurtBlood(hurtValue, FightAttackType.PHYSICAL_ATTACK_TYPE, false);
			}
		}
		
		private function myBodySkinAppearAnimationEndHandler():void
		{
			myMagicHurtValue = GameMathUtil.randomUintBetween(myMagicSkillTemplateInfo.minAtk, myMagicSkillTemplateInfo.maxAtk);
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
		}
		
		private function myBodySkinDisAppearAnimationEndHandler():void
		{
			destorySelf();
		}
		
		override protected function get myMagicLevel():int
		{
			return _myMagicLevel;
		}
	}
}