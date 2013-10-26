package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect
{
	import flash.events.MouseEvent;
	
	import release.module.kylinFightModule.gameplay.constant.GameMovieClipFrameNameType;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.constant.identify.MonsterID;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 恶魔之门
	 */
	public class SummonDemonDoorSkillRes extends BasicSkillEffectRes
	{
		[Inject]
		public var mapRoadModel:IMapRoadModel;
		
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
		
		[PostConstruct]
		override public function onPostConstruct():void
		{
			super.onPostConstruct();
			injector.injectInto(_marchCd);
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
			
			var monster:BasicMonsterElement = objPoolMgr
				.createSceneElementObject(GameObjectCategoryType.MONSTER, demonId) as BasicMonsterElement;
			monster.x = this.x;
			monster.y = this.y;
			
			var pathPoints:Vector.<PointVO> = mapRoadModel.getMapRoad(_roadIdx).lineVOs[_lineIdx].points;
			monster.startEscapeByPath(pathPoints, _roadIdx, _lineIdx);
			monster.updateWalkPathStepIndex(_pointIdx);
			
			_curMarchType *= -1;
		}
	}
}