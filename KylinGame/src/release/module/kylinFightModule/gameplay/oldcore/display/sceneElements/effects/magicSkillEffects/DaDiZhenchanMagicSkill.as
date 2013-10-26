package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	public class DaDiZhenchanMagicSkill extends BasicMagicSkillEffect
	{
		private var _randomStartCDTimer:SimpleCDTimer;
		
		private var _mainAttackTotalTimes:int = 0;//default
		private var _mainAttackCurrentTimes:int = 0;
		
		private var _randomStartTime:int = 0;
		
		private var _hasAftershockState:Boolean = false;
		private var _minAfterShockHurtBloodValue:uint = 0;
		private var _maxAfterShockHurtBloodValue:uint = 0;
		
		public function DaDiZhenchanMagicSkill(typeId:int)
		{
			super(typeId);			
		}
		
		[PostConstruct]
		override public function onPostConstruct():void
		{
			super.onPostConstruct();
			
			this.myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_BOTTOM;
			
			_mainAttackTotalTimes = myEffectParameters.times;
			_hasAftershockState = myEffectParameters.dmg;
			
			if(_hasAftershockState)
			{
				var dmgStrArr:Array = String(myEffectParameters.dmg).split("-");
				_minAfterShockHurtBloodValue = dmgStrArr[0];
				_maxAfterShockHurtBloodValue = dmgStrArr[1];
			}
		}
		
		public function setRandomStartTime(randomStartTime:uint):void
		{
			_randomStartTime = randomStartTime;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			_randomStartCDTimer = new SimpleCDTimer(0);
			injector.injectInto(_randomStartCDTimer);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();

			_mainAttackCurrentTimes = 0;
			
			if(_randomStartTime > 0)
			{
				_randomStartCDTimer.setDurationTime(_randomStartTime);
				_randomStartCDTimer.resetCDTime();
				changeToTargetBehaviorState(MagicSkillEffectBehaviorState.PRE_APPEAR);
			}
			else
			{
				changeToTargetBehaviorState(MagicSkillEffectBehaviorState.APPEAR);
			}
			
			if(myMagicLevel == 6)
			{
				//在3个同等法术
				for(var i:uint = 0; i < 3; i++)
				{
					var daDiZhenchanMagicSkill:DaDiZhenchanMagicSkill = objPoolMgr
						.createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL, 210761, false) as DaDiZhenchanMagicSkill;
					
					var rTime:uint = uint(GameMathUtil.randomFromValues([200, 600, 800]));
					daDiZhenchanMagicSkill.setRandomStartTime(rTime);
					
					var randomPosition:PointVO = sceneElementsService.getCurrentSceneRandomRoadPointByCurrentRoadsData(1);
					daDiZhenchanMagicSkill.x = randomPosition.x;
					daDiZhenchanMagicSkill.y = randomPosition.y;
					daDiZhenchanMagicSkill.notifyLifecycleActive();
				}
			}
		}
		
		override protected function playSound(id:String):void
		{
			if(7 != myMagicLevel)
				super.playSound(id);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_randomStartTime = 0;
		}
		
		override public function render(iElapse:int):void
		{
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.PRE_APPEAR:
					//_randomStartCDTimer.tick();
					if(_randomStartCDTimer.getIsCDEnd())
					{
						changeToTargetBehaviorState(MagicSkillEffectBehaviorState.APPEAR);
					}
					break;

				case MagicSkillEffectBehaviorState.RUNNING:
					//myMagicSkillCDTimer.tick();
					if(myMagicSkillCDTimer.getIsCDEnd())
					{
						changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
					}
					else
					{
						hurtEnemyUintsBloodPerRender();
					}
					break;
			}
			
			super.render(iElapse);
		}

		//地面燃烧伤害
		private function hurtEnemyUintsBloodPerRender():void
		{
			var targets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);
			
			//这里是每个render的伤害 1s 的
			var hurtValue:uint = GameMathUtil.randomUintBetween(_minAfterShockHurtBloodValue, _maxAfterShockHurtBloodValue) / GameFightConstant.GAME_PER_FRAME_TIME;
			
			var n:uint = targets.length;
			for(var i:uint = 0; i < n; i++)
			{
				var target:BasicOrganismElement = targets[i];
				target.hurtBlood(hurtValue, FightAttackType.MAGIC_ATTACK_TYPE, false,null,false,OrganismDieType.FIRE_EXPLODE_DIE);
			}
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.PRE_APPEAR:
					myBodySkin.gotoAndStop2(1);
					break;
				
				case MagicSkillEffectBehaviorState.APPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
						myBodySkinAppearAnimationEndHandler);
					break;
				
				case MagicSkillEffectBehaviorState.ATTACKING:
					nextMainShockAttack();
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
			
		private function nextMainShockAttack():void
		{
			_mainAttackCurrentTimes++;
			
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.ATTACK + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
				GameMovieClipFrameNameType.ATTACK + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1,
				myBodySkinMainAttackAnimationEndHandler,
				GameMovieClipFrameNameType.FIRE_POINT, myBodySkinMainAttackTimeHandler);
		}
		
		private function myBodySkinMainAttackTimeHandler():void
		{
			var targets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);
			
			const arrDmg:Array = (myMagicSkillTemplateInfo.objEffect[SkillResultTyps.DMG] as String).split("-");
			var hurtValue:uint = GameMathUtil.randomUintBetween(arrDmg[0], arrDmg[1]);
			var n:uint = targets.length;
			for(var i:uint = 0; i < n; i++)
			{
				var target:BasicOrganismElement = targets[i];
				target.hurtBlood(hurtValue, FightAttackType.MAGIC_ATTACK_TYPE, false,null,false,OrganismDieType.FIRE_EXPLODE_DIE);
			}
		}
		
		private function myBodySkinMainAttackAnimationEndHandler():void
		{
			if(_mainAttackCurrentTimes >= _mainAttackTotalTimes) 
			{
				_mainAttackCurrentTimes = _mainAttackTotalTimes;
				if(_hasAftershockState)
					changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
				else 
					changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
			}
			else
			{
				nextMainShockAttack();
			}
		}
		
		private function myBodySkinAppearAnimationEndHandler():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.ATTACKING);
		}
		
		private function myBodySkinDisAppearAnimationEndHandler():void
		{
			destorySelf();
		}
	}
}