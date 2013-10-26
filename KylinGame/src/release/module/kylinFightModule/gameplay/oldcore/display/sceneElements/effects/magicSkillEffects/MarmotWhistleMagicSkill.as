package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.magicSkillEffects
{
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.identify.MagicID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 土拨鼠的哨子
	 */
	public class MarmotWhistleMagicSkill extends BasicMagicSkillEffect
	{
		private var _vecEffectTargets:Vector.<BasicOrganismElement> = new Vector.<BasicOrganismElement>;
		
		private var _randomStartTime:int = 0;
		[Inject]
		public var _randomStartCDTimer:SimpleCDTimer;
		
		public function MarmotWhistleMagicSkill(typeId:int)
		{
			super(typeId);
		}
		
		public function setRandomStartTime(randomStartTime:uint):void
		{
			_randomStartTime = randomStartTime;
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			
			if(_randomStartTime > 0)
			{
				_randomStartCDTimer.setDurationTime(_randomStartTime);
				_randomStartCDTimer.resetCDTime();
				changeToTargetBehaviorState(MagicSkillEffectBehaviorState.PRE_APPEAR);
				myMagicSkillCDTimer.setDurationTime(myMagicSkillTemplateInfo.duration*0.5);
				myBodySkin.visible = false;
			}
			else
			{
				changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
			}
			
			if(myMagicLevel == 4 && 0 == _randomStartTime)
			{
				//在3个同等法术
				for(var i:uint = 0; i < 3; i++)
				{
					var daDiZhenchanMagicSkill:MarmotWhistleMagicSkill = objPoolMgr
						.createSceneElementObject(GameObjectCategoryType.MAGIC_SKILL, MagicID.MarmotWhistle+3, false) as MarmotWhistleMagicSkill;
					
					var rTime:uint = uint(GameMathUtil.randomFromValues([1000, 1500, 2000]));
					daDiZhenchanMagicSkill.setRandomStartTime(rTime);
					
					var randomPosition:PointVO = sceneElementsService.getCurrentSceneRandomRoadPointByCurrentRoadsData(1);
					daDiZhenchanMagicSkill.x = randomPosition.x;
					daDiZhenchanMagicSkill.y = randomPosition.y;
					daDiZhenchanMagicSkill.notifyLifecycleActive();
				}
			}
		}
		
		override protected function get myMagicLevel():int
		{
			return _myMagicLevel;
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
				case MagicSkillEffectBehaviorState.RUNNING:
					//myMagicSkillCDTimer.tick();
					if(myMagicSkillCDTimer.getIsCDEnd())
					{
						changeToTargetBehaviorState(MagicSkillEffectBehaviorState.DISAPPEAR);
					}
					else
					{
					//myPerSceondCDTimer.tick();
						//if(myPerSceondCDTimer.getIsCDEnd())
						{
							//myPerSceondCDTimer.resetCDTime();
							attachEmemyUintsBufferPerSecond();
						}
					}
					break;
				case MagicSkillEffectBehaviorState.PRE_APPEAR:
					//_randomStartCDTimer.tick();
					if(_randomStartCDTimer.getIsCDEnd())
					{
						myBodySkin.visible = true;
						changeToTargetBehaviorState(MagicSkillEffectBehaviorState.RUNNING);
						myMagicSkillCDTimer.resetCDTime();
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
				case MagicSkillEffectBehaviorState.RUNNING:
					myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START, 
						GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
					break;
				
				case MagicSkillEffectBehaviorState.DISAPPEAR:
					onDisappear();
					destorySelf();
					break;
			}
		}
		
		private function attachEmemyUintsBufferPerSecond():void
		{
			if(!myBuffer1Parameters)
				return;
			
			checkOutsideEnemys();
			
			var targets:Vector.<BasicOrganismElement> = sceneElementsService.searchOrganismElementsBySearchArea(this.x, this.y, 
					myMagicSkillTemplateInfo.range, 
					FightElementCampType.ENEMY_CAMP, necessarySearchConditionFilter);
			
			var n:uint = targets.length;
			for(var i:uint = 0; i < n; i++)
			{
				var target:BasicOrganismElement = targets[i];
				if(myBuffer1Parameters)
					target.notifyAttachBuffer(myBuffer1Parameters.buff, myBuffer1Parameters,null);
				_vecEffectTargets.push(target);
			}
		}
		
		override protected function necessarySearchConditionFilter(element:BasicOrganismElement):Boolean
		{
			if(!super.necessarySearchConditionFilter(element))
				return false;
			return (_vecEffectTargets.indexOf(element) == -1);
		}
		
		private function checkOutsideEnemys():void
		{
			for(var i:int=0;i<_vecEffectTargets.length;++i)
			{
				if(_vecEffectTargets[i].x < this.x-myMagicSkillTemplateInfo.range
				|| _vecEffectTargets[i].x > this.x+myMagicSkillTemplateInfo.range
				|| _vecEffectTargets[i].y < this.y-myMagicSkillTemplateInfo.range
				|| _vecEffectTargets[i].y > this.y+myMagicSkillTemplateInfo.range
				|| !_vecEffectTargets[i].isAlive)
				{
					if(myBuffer1Parameters && _vecEffectTargets[i].hasBuffer(myBuffer1Parameters.buff))
						_vecEffectTargets[i].notifyDettachBuffer(myBuffer1Parameters.buff);
					_vecEffectTargets.splice(i,1);
					--i;
				}
			}
		}
		
		private function onDisappear():void
		{
			for each(var target:BasicOrganismElement in _vecEffectTargets)
			{
				if(myBuffer1Parameters)
					target.notifyDettachBuffer(myBuffer1Parameters.buff);	
			}
			_vecEffectTargets.length = 0;
		}
	}
}