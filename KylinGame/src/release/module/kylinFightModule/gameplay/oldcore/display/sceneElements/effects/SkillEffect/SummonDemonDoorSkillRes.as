package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect
{
	import com.shinezone.towerDefense.fight.constants.GameMovieClipFrameNameType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import com.shinezone.towerDefense.fight.constants.identify.MonsterID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.events.MouseEvent;

	/**
	 * 恶魔之门
	 */
	public class SummonDemonDoorSkillRes extends BasicSkillEffectRes
	{
		private var _clickCount:int = 0;
		private var _roadIdx:int = 0;
		private var _lineIdx:int = 0;
		private var _pointIdx:int = 0;
		private var _marchCd:SimpleCDTimer = new SimpleCDTimer(6000);
		private var _curMarchType:int = 1;
		
		public function SummonDemonDoorSkillRes(typeId:int)
		{
			super(typeId);
			this.mouseEnabled = true;
			this.buttonMode = true;
			myGroundSceneLayerType = GroundSceneElementLayerType.LAYER_BOTTOM;
		}
		
		override protected function beginToShow():void
		{
			myBodySkin.gotoAndPlay2(GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_START,
				GameMovieClipFrameNameType.APPEAR + GameMovieClipFrameNameType.FRAME_NAME_SUFFIX_END, 1, onSkillEffEndHandler);
		}
		
		override protected function onSkillEffEndHandler():void
		{
			myBodySkin.gotoAndStop2(GameMovieClipFrameNameType.IDLE);
			changeToTargetBehaviorState(SkillEffectBehaviorState.RUNNING);
			_marchCd.resetCDTime();
			addEventListener(MouseEvent.CLICK,onClickDoor);
			playClickEff();
		}
		
		private function onClickDoor(e:MouseEvent):void
		{
			++_clickCount;
			if(_clickCount >= 2)
				changeToTargetBehaviorState(SkillEffectBehaviorState.DISAPPEAR);
		}
		
		override protected function onLifecycleFreeze():void
		{
			super.onLifecycleFreeze();
			_roadIdx = 0;
			_lineIdx = 0;
			_pointIdx = 0;
			_clickCount = 0;
			if(hasEventListener(MouseEvent.CLICK))
				removeEventListener(MouseEvent.CLICK,onClickDoor);
			stopClickEff();
		}
		
		override protected function onBehaviorStateChangedToDisappear():void
		{
			super.onBehaviorStateChangedToDisappear();
			if(hasEventListener(MouseEvent.CLICK))
				removeEventListener(MouseEvent.CLICK,onClickDoor);
			stopClickEff();
		}
		
		override public function render(iElapse:int):void
		{
			super.render(iElapse);
			if(SkillEffectBehaviorState.RUNNING == currentBehaviorState)
			{
				if(_marchCd.getIsCDEnd())
				{
					marchDemon();
					_marchCd.resetCDTime();
				}
			}
		}
		
		public function setRouteLineIdxes(arr:Array):void
		{
			if(!arr || arr.length<3)
				return;
			_roadIdx = arr[0];
			_lineIdx = arr[1];
			_pointIdx = arr[2];
		}
		
		private function marchDemon():void
		{
			var demonId:uint;
			if(1 == _curMarchType)
				demonId = MonsterID.SmallDemon;
			else if(-1 == _curMarchType)
				demonId = MonsterID.Cerberus;
			
			var monster:BasicMonsterElement = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.MONSTER, demonId) as BasicMonsterElement;
			monster.x = this.x;
			monster.y = this.y;
			var pathPoints:Vector.<PointVO> = GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo.roadVOs[_roadIdx].lineVOs[_lineIdx].points;
			monster.startEscapeByPath(pathPoints, _roadIdx, _lineIdx);
			monster.updateWalkPathStepIndex(_pointIdx);
			
			_curMarchType *= -1;
		}
	}
}