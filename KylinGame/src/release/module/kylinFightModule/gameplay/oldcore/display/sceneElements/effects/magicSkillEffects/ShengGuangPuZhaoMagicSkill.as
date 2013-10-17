package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.OrganismDieType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import framecore.tools.GameStringUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;

	//圣光普照
	public class ShengGuangPuZhaoMagicSkill extends BasicMagicSkillEffect
	{
		private static const SHENG_GUANG_PU_ZHAO_MAGIC_HEIGHT:Number = 100;
		
		private var _minBenifitBlood:uint = 0;
		private var _maxBenifitBlood:uint = 0;
		
		private var _isNeedHurtEnemyBlood:Boolean = false;
		private var _hurtEnemyMinBlood:uint = 0;
		private var _hurtEnemyMaxBlood:uint = 0;
		
		private var _isNeedImmediatelyResurrectionFriendlyUints:Boolean = false;
		//无敌buffer
		private var _isNeedAttachInvincibilityBufferEffect:Boolean = false;
		
		public function ShengGuangPuZhaoMagicSkill(typeId:int)
		{
			super(typeId);
			
			var benifitBloodStrArr:Array = String(myEffectParameters.life).split("-");
			_minBenifitBlood = benifitBloodStrArr[0];
			_maxBenifitBlood = benifitBloodStrArr[1];
			
			_isNeedHurtEnemyBlood = myEffectParameters.dmg != null;
			if(_isNeedHurtEnemyBlood)
			{
				var hurtBloodStrArr:Array = String(myEffectParameters.dmg).split("-");	
				_hurtEnemyMinBlood = hurtBloodStrArr[0];
				_hurtEnemyMaxBlood = hurtBloodStrArr[1];
			}

			_isNeedAttachInvincibilityBufferEffect = myMagicLevel == 6;
			_isNeedImmediatelyResurrectionFriendlyUints = myMagicLevel >= 5;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			myBodySkin.y = -SHENG_GUANG_PU_ZHAO_MAGIC_HEIGHT;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.APPEAR);
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			
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
						//myPerSceondCDTimer.tick();
						if(myPerSceondCDTimer.getIsCDEnd())
						{
							myPerSceondCDTimer.resetCDTime();
							benifitFriendlyUintsPerSecond();
						}
						
						if(_isNeedImmediatelyResurrectionFriendlyUints)
						{
							immediatelyResurrectionFriendlyUintsPerRender();
						}
						
						if(_isNeedHurtEnemyBlood)
						{
							hurtEnemyUintsBloodPerRender();	
						}
					}
					break;
			}
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
		
		private function myBodySkinAppearAnimationEndHandler():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
		}
		
		private function myBodySkinDisAppearAnimationEndHandler():void
		{
			destorySelf();
		}
		
		//友军单位每秒加血, 添加无敌
		private function benifitFriendlyUintsPerSecond():void
		{
			var targets:Vector.<BasicOrganismElement> = null;
			var target:BasicOrganismElement = null;
			var n:uint = 0;
			var i:uint = 0;
			
			var benifitBlood:uint = GameMathUtil.randomUintBetween(_minBenifitBlood, _maxBenifitBlood);
			
			targets = GameAGlobalManager.getInstance()
				.groundSceneHelper.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.FRIENDLY_CAMP);
			n = targets.length;

			for(i = 0; i < n; i++)
			{
				target = targets[i];
				
				if(_isNeedAttachInvincibilityBufferEffect)
				{
					//这里添加无敌buffer
					target.notifyAttachBuffer(myBuffer1Parameters.buff, myBuffer1Parameters, null);
				}

				target.benefitBlood(benifitBlood, true, true);
			}
		}
		
		//检测正在复活的单位，并让他立即复活
		private function immediatelyResurrectionFriendlyUintsPerRender():void
		{
			var targets:Vector.<BasicOrganismElement> = null;
			var target:BasicOrganismElement = null;
			var n:uint = 0;
			var i:uint = 0;
			
			targets = GameAGlobalManager.getInstance()
				.groundSceneHelper.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.FRIENDLY_CAMP, searchDeadTarget, true);
			n = targets.length;
			
			for(i = 0; i < n; i++)
			{
				target = targets[i];
				target.forceToResurrection(1);
			}
		}
		
		private function searchDeadTarget(e:BasicOrganismElement):Boolean
		{
			return !e.isAlive && !e.isHero;
		}
		
		private function hurtEnemyUintsBloodPerRender():void
		{
			var targets:Vector.<BasicOrganismElement> = null;
			
			var target:BasicOrganismElement = null;
			var n:uint = 0;
			var i:uint = 0;
			
			var hurtBlood:uint = GameMathUtil.randomUintBetween(_hurtEnemyMinBlood, _hurtEnemyMaxBlood)/* / GameFightConstant.GAME_PER_FRAME_TIME*/;
			
			targets = GameAGlobalManager.getInstance()
				.groundSceneHelper.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP);
			n = targets.length;
			for(i = 0; i < n; i++)
			{
				target = targets[i];
				target.hurtBlood(hurtBlood, FightAttackType.MAGIC_ATTACK_TYPE, false,null,false,OrganismDieType.NORMAL_DIE,1/GameFightConstant.GAME_PER_FRAME_TIME);
			}
		}
	}
}