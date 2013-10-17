package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.TriggerConditionType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.OrganismBehaviorState;

	/**
	 * 比蒙巨兽
	 */
	public class Behemoth extends BasicMonsterElement
	{
		private var _bAngry:Boolean = false;
		
		public function Behemoth(typeId:int)
		{
			super(typeId);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_bAngry = false;
		}		
		
		override protected function onBehaviorStateChanged():void
		{
			if(OrganismBehaviorState.BEASTANGRY == currentBehaviorState)
			{
				myMoveLogic.pauseWalk(myMoveState);
				myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,GameMovieClipFrameNameType.APPEAR
					+GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END,1,onAngryEnd);
				return;
			}
			super.onBehaviorStateChanged();
		}
		
		override public function notifyTriggerSkillAndBuff(condition:int):void
		{
			super.notifyTriggerSkillAndBuff(condition);
			
			if(condition == TriggerConditionType.LIFE_OR_MAXLIFE_CHANGED)
			{
				if(myFightState.beastState.bHasState)
				{
					var lifePct:int = myFightState.getCurLifePct();
					if(lifePct <= myFightState.beastState.iLifeDownPct)
					{
						_bAngry = true;
						myFightState.range = myFightState.beastState.iAtkArea;
						addPassiveAtkSpdPct(myFightState.beastState.iAtkSpd,this);
						addPassiveMoveSpeedPct(myFightState.beastState.iMoveSpd,this);
						changeToTargetBehaviorState(OrganismBehaviorState.BEASTANGRY);
						myFightState.beastState.dispose();
					}
				}
			}
		}
		
		private function onAngryEnd():void
		{
			onDoDefaultBehavior();
		}
		
		
		
		override protected function getUpWalkTypeStr():String
		{
			if(_bAngry)
				return GameMovieClipFrameNameType.UP_WALK_1;
			return GameMovieClipFrameNameType.UP_WALK;
		}
		
		override protected function getDownWalkTypeStr():String
		{
			if(_bAngry)
				return GameMovieClipFrameNameType.DOWN_WALK_1;
			return GameMovieClipFrameNameType.DOWN_WALK;
		}
		
		override protected function getWalkTypeStr():String
		{
			if(_bAngry)
				return GameMovieClipFrameNameType.WALK_1;
			return GameMovieClipFrameNameType.WALK;
		}
		
		override protected function getNearAttackTypeStr():String
		{
			if(_bAngry)
				return GameMovieClipFrameNameType.NEAR_ATTACK_1;
			return GameMovieClipFrameNameType.NEAR_ATTACK;
		}
		
		override protected function getNearFirePointTypeStr():String
		{
			if(_bAngry)
				return GameMovieClipFrameNameType.NEAR_FIRE_POINT_1;
			return GameMovieClipFrameNameType.NEAR_FIRE_POINT;
		}
		
		override protected function getIdleTypeStr():String
		{
			if(_bAngry)
				return GameMovieClipFrameNameType.IDLE_1;
			return GameMovieClipFrameNameType.IDLE;
		}
			
	}
}