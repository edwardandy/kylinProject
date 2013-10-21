package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss
{
	import flash.events.MouseEvent;
	
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.constant.identify.MonsterID;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;

	/**
	 * 恶狼先锋
	 */
	public class WolfPioneer extends BasicMonsterElement
	{
		private var _searchedGoblin:BasicMonsterElement;
		
		private var _clickNetTimes:int = 0;
		private var _netSelfCd:SimpleCDTimer = new SimpleCDTimer(3000);
		
		public function WolfPioneer(typeId:int)
		{
			super(typeId);
			this.mouseEnabled = true;
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_searchedGoblin = null;
			_netSelfCd.clearCDTime();
			clearClickState();
		}
		
		override public function render(iElapse:int):void
		{
			if(OrganismBehaviorState.STUN == currentBehaviorState)
			{
				if(_netSelfCd.getIsCDEnd())
				{
					--myFightState.iStun;
					onDoDefaultBehavior();
					//changeToTargetBehaviorState(OrganismBehaviorState.ENEMY_ESCAPING);
				}
			}
			super.render(iElapse);
			checkGoblinClosed();
		}
		
		override protected function onBehaviorStateChanged():void
		{
			if(OrganismBehaviorState.STUN == currentBehaviorState)
			{
				myMoveLogic.pauseWalk(myMoveState);
				++myFightState.iStun;
				_netSelfCd.resetCDTime();
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.EFFECT+"_"+SkillID.CastNet+"_"+GameMovieClipFrameNameType.IDLE+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					GameMovieClipFrameNameType.EFFECT+"_"+SkillID.CastNet+"_"+GameMovieClipFrameNameType.IDLE+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
				return;
			}
			else if(OrganismBehaviorState.DYING == currentBehaviorState)
				var gaojian:int = 0;
			super.onBehaviorStateChanged();
		}
		
		override protected function onBehaviorChangeToDying():void
		{
			clearClickState();
			
			super.onBehaviorChangeToDying();
		}
		
		private function checkGoblinClosed():void
		{
			if(!isAlive || OrganismBehaviorState.USE_SKILL == currentBehaviorState 
				|| OrganismBehaviorState.NEAR_FIHGTTING == currentBehaviorState || myFightState.bStun)
				return;
			_searchedGoblin = sceneElementsService.searchOrganismElementEnemy(
				searchCenterX,searchCenterY,40,myCampType,searchGoblinCondition) as BasicMonsterElement;
			if(!_searchedGoblin)
				return;
			notifyTriggerSkillAndBuff(TriggerConditionType.GOBLIN_CLOSED);
		}
		
		private function searchGoblinCondition(e:BasicOrganismElement):Boolean
		{
			return MonsterID.Goblin == e.objectTypeId;
		}
		
		override protected function onBehaviorChangeToUseSkill():void
		{
			super.onBehaviorChangeToUseSkill();
			var skillId:uint = myFightState.curUseSkillId;
			if(skillId == SkillID.EatGoblin && _searchedGoblin)
			{
				_searchedGoblin.destorySelf();
				_searchedGoblin = null;
			}
		}
		
		//撒网
		override protected function onSkillChantStart(skillId:uint):void
		{
			if(skillId == SkillID.CastNet)
			{
				_clickNetTimes = 0;
				addEventListener(MouseEvent.CLICK,onClickNet);
				playClickEff();
			}
			super.onSkillChantStart(skillId);
		}
		
		override protected function onSkillChantEnd(skillId:uint):void
		{
			if(skillId == SkillID.CastNet)
			{
				clearClickState();
			}
			super.onSkillChantEnd(skillId);
		}
		
		private function onClickNet(e:MouseEvent):void
		{
			++_clickNetTimes;
			if(_clickNetTimes >= 10)
			{
				clearSkillChantState();
				myFightState.curUseSkillId = 0;
				changeToTargetBehaviorState(OrganismBehaviorState.STUN);
				clearClickState();
			}
		}
		
		private function clearClickState():void
		{
			if(hasEventListener(MouseEvent.CLICK))
				removeEventListener(MouseEvent.CLICK,onClickNet);
			_clickNetTimes = 0;
			stopClickEff();
		}
	}
}