package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss
{
	import flash.events.MouseEvent;
	
	import mainModule.model.gameData.sheetData.skill.IBaseOwnerSkillSheetItem;
	
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.BlackWindSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.BasicSkillProcessor;

	/**
	 * 不朽巨龙
	 */
	public class ImmortalDragon extends BasicMonsterElement
	{				
		private var _clickRebirthTime:int = 0;
		private var _clickBlackWindTime:int = 0;
		private var _curMaxLife:uint;
		private var _leftRebirthTime:int;
				
		public function ImmortalDragon(typeId:int)
		{
			super(typeId);
			this.mouseEnabled = true;
		}
		
		override protected function onLifecycleActivate():void
		{
			_leftRebirthTime = 5;
			super.onLifecycleActivate();
		}
		
		override protected function initStateWhenActive():void
		{
			super.initStateWhenActive();
			_bNeedRebirthAnim = false;
			myFightState.rebirthTime = 5000;
			myResurrectionCDTimer.setDurationTime(5000);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_curMaxLife = 0;
			_clickRebirthTime = 0;
			_clickBlackWindTime = 0;
			if(hasEventListener(MouseEvent.CLICK))
			{
				removeEventListener(MouseEvent.CLICK,onClickWhenResurrect);
				removeEventListener(MouseEvent.CLICK,onClickBlackWind);
			}
			stopClickEff();
		}
		
		//杀死非英雄单位则召唤2个骷髅
		override public function notifyHurtTagetOnkill(beHurtTarget:BasicOrganismElement, finalHurtValue:uint):void
		{
			if(!beHurtTarget.isHero)
				notifyTriggerSkillAndBuff(TriggerConditionType.KILL_TARGET);
		}
		
		override protected function onRenderWhenResurrectionState():void
		{
			if(myResurrectionCDTimer.getIsCDEnd())
			{
				if(hasEventListener(MouseEvent.CLICK))
				{
					removeEventListener(MouseEvent.CLICK,onClickWhenResurrect);
					stopClickEff();
				}
			}
			super.onRenderWhenResurrectionState();
		}
		
		override protected function onBehaviorChangeToDying():void
		{
			clearClickWindState();
			super.onBehaviorChangeToDying();
		}
		
		override protected function checkCanResurrect():Boolean
		{
			if(myFightState.maxlife <= 3000 || _leftRebirthTime<=0)
				return false;
			return super.checkCanResurrect();
		}
		
		override protected function onBehaviorChangeToResurrect():void
		{
			super.onBehaviorChangeToResurrect();
			_curMaxLife = myFightState.maxlife/3;
			--_leftRebirthTime;
			addEventListener(MouseEvent.CLICK,onClickWhenResurrect);
			playClickEff();
		}
		
		override protected function onResurrectionComplete():void
		{
			super.onResurrectionComplete();
			_clickRebirthTime = 0;
			myFightState.maxlife = _curMaxLife;
			resetBooldBar();
		}
		
		override protected function onCurrentSearchedEnemyLeaveOffScreenSearchRangeAndThenToDoDefaultBehavior():void
		{
			setSearchedEnemy(null);
			if(OrganismBehaviorState.USE_SKILL != currentBehaviorState)
			{
				restoreMoveState();
				changeToTargetBehaviorState(OrganismBehaviorState.ENEMY_ESCAPING);
			}
		}
		
		private function onClickWhenResurrect(e:MouseEvent):void
		{
			++_clickRebirthTime;
			if(_clickRebirthTime >= 15)
			{
				destorySelf();
				successAndFailedDetector.onEnemyCampUintDied(this);
			}
		}
		
		//黑暗之风
		override protected function onSkillChantStart(skillId:uint):void
		{
			if(SkillID.BlackWind == skillId)
			{
				clearClickWindState();
				addEventListener(MouseEvent.CLICK,onClickBlackWind);
				playClickEff();
			}
			super.onSkillChantStart(skillId);
		}
		
		override protected function onSkillChantEnd(skillId:uint):void
		{
			if(SkillID.BlackWind == skillId)
			{
				stopClickEff();
			}
			super.onSkillChantEnd(skillId);
		}
		
		private function onClickBlackWind(e:MouseEvent):void
		{
			++_clickBlackWindTime;
		}
		
		private function clearClickWindState():void
		{
			_clickBlackWindTime = 0;
			removeEventListener(MouseEvent.CLICK,onClickBlackWind);
		}
		
		override protected function appearSkillEffect():void
		{	
			var skillId:uint = myFightState.curUseSkillId;
			if(SkillID.BlackWind == skillId)
			{
				var skillTemp:IBaseOwnerSkillSheetItem = getBaseSkillInfo(skillId);
				
				var skillEffect:BlackWindSkillRes = objPoolMgr
					.createSceneElementObject(GameObjectCategoryType.SKILLRES, SkillID.BlackWind) as BlackWindSkillRes;
				if(skillEffect)
				{
					skillEffect.activeSkillEffect(this,null);
					skillEffect.initByParam(calcBlackWindDistance(),myMoveState.currentPathPoints.concat(),myMoveState.currentPathStepIndex);
				}
				clearClickWindState();
				return;
			}
			super.appearSkillEffect();
		}
		
		private function calcBlackWindDistance():int
		{
			var blacWindProcessor:BasicSkillProcessor = skillProcessorMgr.getSkillProcessorById(SkillID.BlackWind);
			var dis:int = blacWindProcessor.effectParam[BufferFields.MAX] - _clickBlackWindTime * 20;
			if(dis < blacWindProcessor.effectParam[BufferFields.MIN])
				dis = blacWindProcessor.effectParam[BufferFields.MIN];
			return dis;
		}
	}
}