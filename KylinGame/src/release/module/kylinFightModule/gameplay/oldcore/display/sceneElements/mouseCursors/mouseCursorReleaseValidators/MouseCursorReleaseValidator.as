package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseValidators
{
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadLineVOHelperUtil;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public final class MouseCursorReleaseValidator
	{
		private static var _instance:MouseCursorReleaseValidator;
		
		public static function getInstance():MouseCursorReleaseValidator
		{
			return 	_instance ||= new MouseCursorReleaseValidator();
		}
		
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
					return GameAGlobalManager.getInstance().groundScene.hisTestMapRoad(mouseEvent.stageX,mouseEvent.stageY);
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
					if(!GameAGlobalManager.getInstance().groundScene.hisTestMapRoad(mouseEvent.stageX,mouseEvent.stageY)) return false;
					
					var roadVOs:Vector.<RoadVO> = GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo.roadVOs;
					var n:uint = roadVOs.length;
					var pathPointVOs:Vector.<PointVO>;
					var s:Array = [];
					for(var i:uint = 0; i < n; i++)
					{
						var roadVO:RoadVO = roadVOs[i];
						
						var roadPathStepIndex:int = RoadLineVOHelperUtil.caculatePointInfoOnRoadPathStepIndex(
							GameMathUtil.convertStagePtToGame(mouseEvent.stageX,mouseEvent.stageY,GameAGlobalManager.getInstance().game), roadVO.lineVOs); 

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