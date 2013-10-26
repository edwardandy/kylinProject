package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss
{
	import mainModule.model.gameData.sheetData.skill.monsterSkill.IMonsterSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.constant.identify.BufferID;
	import release.module.kylinFightModule.gameplay.constant.identify.MonsterID;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.ColdStormSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 寒冰之心
	 */
	public class HeartOfIce extends BasicMonsterElement
	{
		private var _splitCd:SimpleCDTimer = new SimpleCDTimer(10000);
		private var _vecIceElement:Vector.<IceElement> = new Vector.<IceElement>;
		private var _totleElementsCount:int = 10;
		private var _coldStormRes:ColdStormSkillRes;
		private var _notBeAttackCd:SimpleCDTimer = new SimpleCDTimer(7000);
		
		public function HeartOfIce(typeId:int)
		{
			super(typeId);
		}
		
		[PostConstruct]
		override public function onPostConstruct():void
		{
			super.onPostConstruct();
			injector.injectInto(_splitCd);
			injector.injectInto(_notBeAttackCd);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			_notBeAttackCd.resetCDTime();
			this.visible = true;
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_totleElementsCount = 10;
			_vecIceElement.length = 0;
			if(_coldStormRes)
				_coldStormRes.destorySelf();
			_coldStormRes = null;
		}
		
		override public function dispose():void
		{
			super.dispose();
			_vecIceElement = null;
			_splitCd = null;
			_coldStormRes = null;
			_notBeAttackCd = null;
		}
		
		override protected function onBehaviorStateChanged():void
		{
			super.onBehaviorStateChanged();
			if(OrganismBehaviorState.ICE_RESTORE == currentBehaviorState)
			{
				this.visible = true;
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.SPELL_SUFFIX+SkillID.IceElementSplit+"_1_"+GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
					GameMovieClipFrameNameType.SPELL_SUFFIX+SkillID.IceElementSplit+"_1_"+GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,
					onRestoreAnimCmp);
				_notBeAttackCd.resetCDTime();
			}
			else if(OrganismBehaviorState.ICE_SPLIT == currentBehaviorState)
			{
				this.visible = false;
			}
		}
		
		override public function render(iElapse:int):void
		{
			switch(currentBehaviorState)
			{
				case OrganismBehaviorState.ICE_SPLIT:
				{
					if(_splitCd.getIsCDEnd())
					{
						onRestoreIce();
					}
					return;
				}
					break;
				case OrganismBehaviorState.ENEMY_ESCAPING:
				{
					if(0 == myFightState.iIceShield && _notBeAttackCd.getIsCDEnd())
					{
						notifyTriggerSkillAndBuff(TriggerConditionType.NOT_UNDER_ATTACK_IN_FIVE_SEC);
					}
				}
					break;
			}
			super.render(iElapse);
		}
		
		override protected function checkCanUseSkill():Boolean
		{
			//return false;
			return super.checkCanUseSkill();
		}
		
		override public function notifyTriggerSkillAndBuff(condition:int):void
		{
			if(TriggerConditionType.BEFORE_UNDER_ATTACK == condition)
			{
				_notBeAttackCd.resetCDTime();
			}
			super.notifyTriggerSkillAndBuff(condition);
		}
		
		override protected function canChangeBehaviorState(behaviorState:int):Boolean
		{
			if(OrganismBehaviorState.ICE_SPLIT == currentBehaviorState 
				&& OrganismBehaviorState.ICE_WAIT != behaviorState
				&& OrganismBehaviorState.ICE_RESTORE != behaviorState)
			{
				return false;
			}
			
			if(OrganismBehaviorState.USE_SKILL == currentBehaviorState)
			{
				var gaojian:int = 0;
			}
			return super.canChangeBehaviorState(behaviorState);
		}
		
		override protected function onBehaviorChangeToUseSkill():void
		{
			if(SkillID.IceElementSplit == myFightState.curUseSkillId)
			{
				myFightState.bInvincible = true;
				myFightState.bInvisible = true;
			}
			super.onBehaviorChangeToUseSkill();
		}
		
		override protected function appearSkillEffect():void
		{
			//元素分裂
			if(SkillID.IceElementSplit == myFightState.curUseSkillId)
			{
				onSplitIce();
				return;
			}
			super.appearSkillEffect();
		}
		
		override protected function onStartChant(state:SkillState,duration:int):void
		{
			if(SkillID.ColdStorm != state.id)
			{
				super.onStartChant(state,duration);
				return;
			}
			
			_skillChantTimeTick = timeTaskMgr.createTimeTask(GameFightConstant.TIME_UINT*10,onSkillChantInterval,[state.id],
				getColdStormDuration()/(GameFightConstant.TIME_UINT*10),onSkillChantEnd,[state.id]);
			skillActionSkin.gotoAndPlay2(state.strIdleName + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				state.strIdleName + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
			onSkillChantStart(state.id);
		}
		
		override protected function onSkillChantStart(skillId:uint):void
		{
			if(SkillID.ColdStorm == skillId)
			{
				_coldStormRes = objPoolMgr.createSceneElementObject(GameObjectCategoryType.SKILLRES, skillId, false) as ColdStormSkillRes;
				if(_coldStormRes)
				{
					_coldStormRes.activeSkillEffect(this,null);
					_coldStormRes.notifyLifecycleActive();
				}
				appearSkillEffect();
				return;
			}
			super.onSkillChantStart(skillId);
		}
		
		override protected function onSkillChantEnd(skillId:uint):void
		{
			if(SkillID.ColdStorm == skillId)
			{
				if(_coldStormRes)
				{
					_coldStormRes.notifyDisappear();
					_coldStormRes = null;
				}
				onSkillDisappear();
				return;
			}
			super.onSkillChantEnd(skillId);	
		}
		
		override protected function onSkillDisappearAnimEnd():void
		{
			var state:SkillState = mySkillStates.get(myFightState.curUseSkillId) as SkillState;
			state.skillCd.resetCDTime();
			if(OrganismBehaviorState.ICE_SPLIT == currentBehaviorState || OrganismBehaviorState.ICE_RESTORE == currentBehaviorState)
				return;
			super.onSkillDisappearAnimEnd();
		}
		
		//元素分裂
		private function onSplitIce():void
		{
			changeToTargetBehaviorState(OrganismBehaviorState.ICE_SPLIT);
			_splitCd.resetCDTime();
			splitIceElements();
			dispatchLeaveOffScreenSearchRangeEvent();
		}
		
		private function splitIceElements():void
		{
			var ice:IceElement;
			var vecDestPts:Vector.<PointVO> = sceneElementsService.getSomeRandomRoadPoints(_totleElementsCount,null,1,-1);
			for(var i:int=0;i<_totleElementsCount;++i)
			{
				ice = objPoolMgr.createSceneElementObject(GameObjectCategoryType.MONSTER,MonsterID.IceElement,false) as IceElement;
				ice.initByBoss(this,vecDestPts[i].x,vecDestPts[i].y);
				ice.notifyLifecycleActive();
				_vecIceElement.push(ice);
			}
		}
		//还原
		private function onRestoreIce():void
		{
			changeToTargetBehaviorState(OrganismBehaviorState.ICE_WAIT);
			
			if(_totleElementsCount>0)
			{
				for each(var e:IceElement in _vecIceElement)
				{
					e.notifyBackToBoss();
				}
			}
			else
			{
				changeToTargetBehaviorState(OrganismBehaviorState.ICE_RESTORE);
				_totleElementsCount = 10;
			}
	
		}
		
		private function onRestoreAnimCmp():void
		{
			myFightState.bInvincible = false;
			myFightState.bInvisible = false;
			var state:SkillState = mySkillStates.get(SkillID.IceElementSplit) as SkillState;
			if(state)
				state.skillCd.resetCDTime();
			changeToTargetBehaviorState(OrganismBehaviorState.ENEMY_ESCAPING);
		}
				
		public function notifyRestore(e:IceElement):void
		{
			var idx:int = _vecIceElement.indexOf(e);
			if(-1 == idx)
				return;
			_vecIceElement.splice(idx,1);
			if(0 == _vecIceElement.length)
				changeToTargetBehaviorState(OrganismBehaviorState.ICE_RESTORE);
		}
		
		public function notifyElementDie(e:IceElement):void
		{
			var idx:int = _vecIceElement.indexOf(e);
			if(-1 == idx)
				return;
			_vecIceElement.splice(idx,1);
			--_totleElementsCount;
			if(0 == _totleElementsCount)
				onRestoreIce();
		}
			
		public function getColdStormDuration():uint
		{
			return _totleElementsCount>1?_totleElementsCount * 500:1000;
		}
		
		override public function hasIceShield():Boolean
		{
			return myFightState.iIceShield>0;
		}
		
		override public function addIceShield(pct:int,owner:ISkillOwner):Boolean
		{
			myFightState.iIceShield = myFightState.getRealMaxLife() * pct/100;
			return true;
		}
		
		override protected function RemoveIceShield():void
		{
			notifyDettachBuffer(BufferID.IceShield);
		}
	}
}