package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.OrganismDieType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.AeroliteBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import com.shinezone.towerDefense.fight.vo.PointVO;

	public class YiCiYuanZhiMenMagicSkill extends BasicMagicSkillEffect
	{
		private static const YI_CI_YUAN_ZHI_MENMAGIC_SKILL_HEIGHT:Number = 100;
		
		private var _isNeedImmediatelyKillEnemy:Boolean = false;
		private var _isNeedTeleportEnemy:Boolean = false;

		private var _detectEnemyCDTimer:SimpleCDTimer;
		
		public function YiCiYuanZhiMenMagicSkill(typeId:int)
		{
			super(typeId);

			_isNeedImmediatelyKillEnemy = (myMagicLevel == 4 || myMagicLevel == 5);
			_isNeedTeleportEnemy = myMagicLevel == 6;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_detectEnemyCDTimer = new SimpleCDTimer(200);//0.2
			
			myBodySkin.y = -YI_CI_YUAN_ZHI_MENMAGIC_SKILL_HEIGHT;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			_detectEnemyCDTimer.resetCDTime();
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
					else if(_isNeedImmediatelyKillEnemy || _isNeedTeleportEnemy)
					{
						//_detectEnemyCDTimer.tick();
						if(_detectEnemyCDTimer.getIsCDEnd())
						{
							_detectEnemyCDTimer.resetCDTime();
							effectTargetEnemyes();
						}
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
						GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, myBodySkinAppearAnimationEndHandler);
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
		
		private function myBodySkinAppearAnimationEndHandler():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
			
			if(myMagicLevel == 6)
				return;
			//发出陨石子弹
			var hasBullet:Boolean = myEffectParameters.weapon;
			if(hasBullet)
			{
				var hurtValue:uint = GameMathUtil.randomUintBetween(myMagicSkillTemplateInfo.minAtk, myMagicSkillTemplateInfo.maxAtk);
				var bulletEffect:AeroliteBulletEffect = ObjectPoolManager.getInstance()
					.createSceneElementObject(GameObjectCategoryType.BULLET, int(myEffectParameters.weapon), false) as AeroliteBulletEffect;
				bulletEffect.fire(null, null, 
					new PointVO(this.x, this.y - YI_CI_YUAN_ZHI_MENMAGIC_SKILL_HEIGHT + 20), 
					hurtValue, null, new PointVO(this.x, this.y));
				bulletEffect.setBufferParam(myBuffer1Parameters,myMagicSkillTemplateInfo.range);
				bulletEffect.notifyLifecycleActive();
			}
		}
		
		private function effectTargetEnemyes():void
		{
			var targets:Vector.<BasicOrganismElement> = null;
			var target:BasicOrganismElement = null;
			var n:uint = 0;
			var i:uint = 0;
			
			targets = GameAGlobalManager.getInstance()
				.groundSceneHelper.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);
			n = targets.length;
			
			for(i = 0; i < n; i++)
			{
				target = targets[i];
								
				if(_isNeedImmediatelyKillEnemy)
				{
					var killProbability:Boolean = GameMathUtil.randomTrueByProbability(0.15);
					if(killProbability)
					{
						target.hurtBlood(0, FightAttackType.MAGIC_ATTACK_TYPE, false, null, true,OrganismDieType.FIRE_EXPLODE_DIE);
					}
				}					
				else if(_isNeedTeleportEnemy)
				{
					if(target is BasicMonsterElement)
					{
						var results:Array = target.getRollbackPositionVOByDistance(GameMathUtil.randomUintBetween(400, 800)); 
						
						if(target is BasicMonsterElement)
						{
							BasicMonsterElement(target).setAppearRoadPathStepIndex(results[0]);
						}
						var p:PointVO = results[1];
						target.enforceDisappear(p, true);
					}	
				}
			}
		}
		
		private function myBodySkinDisAppearAnimationEndHandler():void
		{
			destorySelf();
		}
	}
}