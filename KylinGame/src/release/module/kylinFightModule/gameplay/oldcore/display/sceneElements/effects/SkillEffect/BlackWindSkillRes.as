package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.identify.BufferID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.Interface.IMoveLogic;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.Interface.IMoveUnit;
	import release.module.kylinFightModule.gameplay.oldcore.logic.move.MoveState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.SkillState;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.BasicSkillProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;

	/**
	 * 黑暗之风
	 */
	public class BlackWindSkillRes extends BasicSkillEffectRes implements IMoveUnit
	{		
		private var _maxDistance:int = 0;
		private var _curDistance:int = 0;
		
		protected var myMoveState:MoveState;
		protected var myMoveLogic:IMoveLogic;
		
		private var _vecEffTowers:Vector.<BasicTowerElement> = new Vector.<BasicTowerElement>;
		
		public function BlackWindSkillRes(typeId:int)
		{
			super(typeId);
			myMoveState = new MoveState(this);
			myMoveLogic = GameAGlobalManager.getInstance().gameMoveLogicMgr.getMoveLogicByCategoryAndId(myElemeCategory,myObjectTypeId);
		}
		
		public function initByParam(maxDistance:int,pathPoints:Vector.<PointVO>,pathStepIndex:int):void
		{
			var processor:BasicSkillProcessor = GameAGlobalManager.getInstance().gameSkillProcessorMgr.getSkillProcessorById(myObjectTypeId,false);
			
			_maxDistance = (maxDistance>processor.effectParam[BufferFields.MIN]?maxDistance:processor.effectParam[BufferFields.MIN]);
			myMoveLogic.moveToByPath(myMoveState,pathPoints);
			myMoveLogic.updateWalkPathStepIndex(myMoveState,pathStepIndex);
		}
		
		override protected function onLifecycleActivate():void
		{
			super.onLifecycleActivate();
			myMoveState.unit = this;
			myMoveState.mySpeed = 2.0;
			myMoveLogic.initMoveUnitByState(myMoveState);
			_vecEffTowers.length = 0;
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			myMoveState.clear();
			_curDistance = 0;
			_maxDistance = 0;
		}
		
		override protected function beginToShow():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.IDLE + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END);
		}
		
		override public function render(iElapse:int):void
		{
			if(SkillEffectBehaviorState.DISAPPEAR != currentBehaviorState)
			{
				if(_curDistance >= _maxDistance)
					changeToTargetBehaviorState(SkillEffectBehaviorState.DISAPPEAR);
				else
					myMoveLogic.update(myMoveState);
			}
			super.render(iElapse);
		}
		
		override protected function onBehaviorStateChangedToDisappear():void
		{
			super.onBehaviorStateChangedToDisappear();
			myMoveLogic.pauseWalk(myMoveState);
		}
		
		private function checkStunTower():void
		{
			var processor:BasicSkillProcessor = GameAGlobalManager.getInstance().gameSkillProcessorMgr.getSkillProcessorById(myObjectTypeId,false);
			var vecTower:Vector.<BasicTowerElement> = GameAGlobalManager.getInstance().groundSceneHelper.
				searchTowersBySearchArea(this.x,this.y,80/*processor.effectParam[BufferFields.AREA]*/);
			if(!vecTower || 0 == vecTower.length)
			{
				return;
			}
			var tower:BasicTowerElement;
			for each(tower in vecTower)
			{
				if(_vecEffTowers.indexOf(tower) == -1)
				{
					_vecEffTowers.push(tower);
					var state:SkillState = new SkillState;
					state.id = myObjectTypeId;
					state.owner = mySkillOwner;
					state.vecTargets.push(tower);
					processor.processBuffers(state);
				}
			}
		}
		
		/**************** implements IMoveUnit *****************************/	
		public function getCurrentActualSpeed():Number
		{
			return myMoveState.mySpeed;
		}
		
		public function notifyMoveStateChange(horDir:int, verDir:int, bForceStop:Boolean):void
		{
		}
		
		public function notifyTeleportMove():void
		{
		}
		
		public function notifyArrivedEndPoint():void
		{
			destorySelf();
		}
		
		public function notifyMoving(oldX:Number,oldY:Number):void
		{
			_curDistance += GameMathUtil.distance(x,y,oldX,oldY);
			checkStunTower();
		}
		
		
	}
}