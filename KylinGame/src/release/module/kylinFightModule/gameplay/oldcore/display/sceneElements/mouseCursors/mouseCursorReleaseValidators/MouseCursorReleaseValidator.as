package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseValidators
{
	import flash.events.MouseEvent;
	
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.model.roads.MapRoadVO;
	import release.module.kylinFightModule.model.sceneElements.ISceneElementsModel;
	import release.module.kylinFightModule.utili.RoadLineVOHelperUtil;
	import release.module.kylinFightModule.utili.structure.PointVO;

	public final class MouseCursorReleaseValidator
	{	
		[Inject]
		public var sceneElementsModel:ISceneElementsModel;
		[Inject]
		public var mapRoadModel:IMapRoadModel;
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		//这里返回 可以的话 则一般返回 true, 有些比较特殊会返回 数据， 不可以返回false
		public function validByMouseCursor(mouseEvent:MouseEvent, type:int):Object
		{
			switch(type)
			{
				case MouseCursorReleaseValidatorType.NO_VALID:
				case MouseCursorReleaseValidatorType.ANY:
					return true;
					break;
				
				case MouseCursorReleaseValidatorType.ONLY_ROAD:
					return sceneElementsModel.hisTestMapRoad(mouseEvent.stageX,mouseEvent.stageY);
					break;
				
				case MouseCursorReleaseValidatorType.ONLY_ENEMY:
					if((mouseEvent.target is BasicOrganismElement) && 
						BasicOrganismElement(mouseEvent.target).campType == FightElementCampType.ENEMY_CAMP 
						&& (mouseEvent.target as BasicOrganismElement).isAlive)
					{
						return mouseEvent.target;
					}
					else return null;
					break;
				
				case MouseCursorReleaseValidatorType.ONLY_STRICT_ROAD:
					if(!sceneElementsModel.hisTestMapRoad(mouseEvent.stageX,mouseEvent.stageY)) return false;
					
					var n:uint = mapRoadModel.roadCount;
					var pathPointVOs:Vector.<PointVO>;
					var s:Array = [];
					for(var i:uint = 0; i < n; i++)
					{
						
						var roadVO:MapRoadVO = mapRoadModel.getMapRoad(i);
						
						var roadPathStepIndex:int = RoadLineVOHelperUtil.caculatePointInfoOnRoadPathStepIndex(
							GameMathUtil.convertStagePtToGame(mouseEvent.stageX,mouseEvent.stageY,fightViewModel.groundLayer), roadVO.lineVOs); 

						if(roadPathStepIndex != -1)//表示该点不再路上
						{
//							pathPointVOs = GameMathUtil.caculateReversedPathPointsByCurrentPathPointsAndPathStepIndex(
//								roadVO.lineVOs[1].points, pathStepIndex);
//							s.push([i, pathPointVOs]);
							s.push([i, roadVO, roadPathStepIndex]);
						}
					}
					
					if(s.length == 0) return false;
					
					return s;
					break;
			}
			
			return false;
		}
	}
}