package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;

	public class BaoFengXueMagicSkill extends BasicMagicSkillEffect
	{
		//private var _hasBuffer2:Boolean = false;
		//private var _buffer2Probability:Number = 0;
		
		//减少非该法术的， CD时间
		private var _hasReDuceOtherMagicCDTime:Boolean = false;
		
		private var _minAtk:int;
		private var _maxAtk:int;
		
		public function BaoFengXueMagicSkill(typeId:int)
		{
			super(typeId);
			
			if(!myEffectParameters)
				return;
			var strDmg:String = myEffectParameters[SkillResultTyps.DMG];
			var arr:Array = strDmg.split("-");
			_minAtk = arr[0];
			_maxAtk = arr[1];
			/*_hasBuffer2 = myMagicLevel >= 5;
			if(_hasBuffer2)
			{
				_buffer2Probability = myEffectParameters.odd / 100;
			}
*/			
			_hasReDuceOtherMagicCDTime = myEffectParameters.skillCdTime!=null;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.APPEAR);
			
			if(_hasReDuceOtherMagicCDTime)
			{
				GameAGlobalManager.getInstance()
					.game.gameFightMainUIView.fightControllBarView
						.reduceMagicSkillCDTime(myObjectTypeId, Math.abs(myEffectParameters.skillCdTime), -1);
			}
		}
		
		override public function render(iElapse:int):void
		{
			switch(currentBehaviorState)
			{
				case MagicSkillEffectBehaviorState.RUNNING:
					//myMagicSkillCDTimer.tick();
					/*if(myMagicSkillCDTimer.getIsCDEnd())
					{
						changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
					}
					else*/
					{
						//myPerSceondCDTimer.tick();
						//if(myPerSceondCDTimer.getIsCDEnd())
						{
							//myPerSceondCDTimer.resetCDTime();
							attachEmemyUintsBufferPerSecond();
						}
						
						//hurtEmemyUintsBloodPerRener();
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
				{
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.FIRE_POINT+"_1",1,onFirstAttack);
					//myMagicSkillCDTimer.resetCDTime();
				}
					break;
				
				case MagicSkillEffectBehaviorState.DISAPPEAR:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.DISAPPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, 
						myBodySkinDisAppearAnimationEndHandler);
					break;
			}
		}
		
		private function onFirstAttack():void
		{
			hurtEmemyUintsBloodPerRener();
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.FIRE_POINT+"_1",GameMovieClipFrameNameType.FIRE_POINT+"_2", 1,onSecondeAttack);
		}
		
		private function onSecondeAttack():void
		{
			hurtEmemyUintsBloodPerRener();
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.FIRE_POINT+"_2"
				,GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1,onAttackEnd);
		}
		
		private function onAttackEnd():void
		{
			changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
		}
			
		/**
		 * 改为分2次伤害 
		 * 
		 */		
		private function hurtEmemyUintsBloodPerRener():void
		{
			var targets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);
			
			//这里是每个render的伤害 1s 的
			var hurtValue:uint = GameMathUtil.randomUintBetween(_minAtk, _maxAtk) /*/ GameFightConstant.GAME_PER_FRAME_TIME*/;
			
			var n:uint = targets.length;
			for(var i:uint = 0; i < n; i++)
			{
				var target:BasicOrganismElement = targets[i];
				target.hurtBlood(hurtValue, FightAttackType.MAGIC_ATTACK_TYPE, false,null,false,OrganismDieType.NORMAL_DIE,0.5);
			}
		}
		
		private function attachEmemyUintsBufferPerSecond():void
		{
			var targets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);
			
			var n:uint = targets.length;
			for(var i:uint = 0; i < n; i++)
			{
				var target:BasicOrganismElement = targets[i];
				var bAttached:Boolean = false;
				//有一定的概率
				if(myPerSceondCDTimer.getIsCDEnd())
				{
					myPerSceondCDTimer.resetCDTime();
					if(myBuffer2Parameters)
					{
						target.notifyAttachBuffer(myBuffer2Parameters.buff, myBuffer2Parameters,null);
						bAttached = true;
					}
				}
				if(!bAttached && myBuffer1Parameters)
					target.notifyAttachBuffer(myBuffer1Parameters.buff, myBuffer1Parameters,null);
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
	}
}