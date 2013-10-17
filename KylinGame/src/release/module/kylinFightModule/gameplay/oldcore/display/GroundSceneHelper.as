package release.module.kylinFightModule.gameplay.oldcore.display
{
	import com.shinezone.towerDefense.fight.algorithms.astar.AStar;
	import com.shinezone.towerDefense.fight.algorithms.astar.Grid;
	import com.shinezone.towerDefense.fight.algorithms.astar.Node;
	import com.shinezone.towerDefense.fight.algorithms.quadTree.QuadTree;
	import com.shinezone.towerDefense.fight.constants.FightAttackType;
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.OrganismDieType;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SummonDemonDoorSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.IPositionUnit;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.LineVO;
	import com.shinezone.towerDefense.fight.vo.map.MapConfigDataVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	import framecore.structure.model.constdata.GameConst;

	public final class GroundSceneHelper implements IDisposeObject
	{
		private var _astar:AStar;
		private var _sceneGrid:Grid;
//		private var _quadTree:QuadTree;
		
		private var _allMiddleDepthRenderLayerReference:Sprite = null;
		private var _towerElementsReference:Vector.<BasicTowerElement>;
		private var _organismsElementsReference:Vector.<BasicOrganismElement>;
		private var _groundeffElementsReference:Vector.<BasicGroundEffect>;
		private var _summonDoorElementsReference:Vector.<SummonDemonDoorSkillRes>;
		private var _allDepthRenderElementsReference:Vector.<DisplayObject>;
		
		private var _groundSceneDepthRenderElements:Vector.<DisplayObject> = null;
		private var _groundSceneDepthRenderElementLength:uint = 0;
		private var _groundSceneDepthRenderElementIndex:uint = 0;
		private var _curentSceneDepthRenderElement:DisplayObject;

		public function GroundSceneHelper()
		{
			super();
			
			_sceneGrid = new Grid(GameFightConstant.SCENE_MAP_CELL_COL_COUNT, GameFightConstant.SCENE_MAP_CELL_ROW_COUNT);
			_astar = new AStar();
			_astar.setGrid(_sceneGrid);
			
//			_quadTree = new QuadTree(4, new Rectangle(0, 0, GameFightConstant.SCENE_MAP_WIDTH, GameFightConstant.SCENE_MAP_HEIGHT));
		}
		
		public function initialize(towerElements:Vector.<BasicTowerElement>, 
											 organismsElements:Vector.<BasicOrganismElement>, 
											 groundeffElements:Vector.<BasicGroundEffect>,
											 summonDoorElements:Vector.<SummonDemonDoorSkillRes>,
											 allMiddleDepthRenderLayer:Sprite, 
											 allDepthRenderElements:Vector.<DisplayObject>):void
		{
			_towerElementsReference = towerElements;
			_organismsElementsReference = organismsElements;
			_groundeffElementsReference = groundeffElements;
			_summonDoorElementsReference = summonDoorElements;
			_allMiddleDepthRenderLayerReference = allMiddleDepthRenderLayer;
			_allDepthRenderElementsReference = allDepthRenderElements;
		}
		
		//-----------------------------------------------------------------------------------------
		
		public function rendSceneDepthElements():void
		{
//			var _t:int = getTimer();
			
			_groundSceneDepthRenderElements = _allDepthRenderElementsReference.concat();
			_groundSceneDepthRenderElements.sort(groundSceneDepthRenderElementSortFunction);
			
			_groundSceneDepthRenderElementLength = _groundSceneDepthRenderElements.length;
			_groundSceneDepthRenderElementIndex = 0;
			
//			try 
//			{
				for(; _groundSceneDepthRenderElementIndex < _groundSceneDepthRenderElementLength; 
					_groundSceneDepthRenderElementIndex++)
				{
					_curentSceneDepthRenderElement = _groundSceneDepthRenderElements[_groundSceneDepthRenderElementIndex];
					_allMiddleDepthRenderLayerReference.setChildIndex(_curentSceneDepthRenderElement, 0);
				}
//			}
//			catch(e:Error)
//			{
//				_curentSceneDepthRenderElement
//			}
			
//			trace(getTimer() - _t);
		}
		
		//这里返回的结果是，场景中层次高在数组的前面， -1表示在上层 1表示在下层
		private function groundSceneDepthRenderElementSortFunction(a:DisplayObject, b:DisplayObject):Number
		{
			if(a.y > b.y)
			{
				return -1;
			}
			else if(a.y < b.y)
			{
				return 1;
			}
			else//相等时
			{
				//左边的排在下面
				if(a.x > b.x)
				{
					return -1;
				}
				else if(a.x < b.x)
				{
					return 1;
				}
				else//最坏的情况所有全都相等
				{
					//原来在上层的还是在上层
					return _allMiddleDepthRenderLayerReference.getChildIndex(a) < _allMiddleDepthRenderLayerReference.getChildIndex(DisplayObject(b)) ? 1 : -1;
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//获取当前场景敌方阵营的数量
		public function getAllEnemyCampOrganismElementsCount():int
		{
			var count:uint = 0;
			for each(var element:BasicOrganismElement in _organismsElementsReference)
			{
				if(element.campType == FightElementCampType.ENEMY_CAMP && (element.isAlive || !element.isFreezedState()))
				{
					count++;
				}
			}

			return count;
		}
		/**
		 * 获取当前所有激活且生存的敌人 
		 * @return 
		 * 
		 */		
		public function getAllAliveEnemys():Vector.<BasicMonsterElement>
		{
			var result:Vector.<BasicMonsterElement> = new Vector.<BasicMonsterElement>;
			for each(var element:BasicOrganismElement in _organismsElementsReference)
			{
				if(element.campType == FightElementCampType.ENEMY_CAMP && (element.isAlive /*|| !element.isFreezedState()*/))
				{
					result.push(element);
				}
			}
			return result;
		}
		
		public function killAllEnemies():Boolean
		{
			var arrMonster:Array=[];
			for each(var element:BasicOrganismElement in _organismsElementsReference)
			{
				if(element.isAlive && element.campType == FightElementCampType.ENEMY_CAMP)
				{
					arrMonster.push(element);
				}
			}
			
			if(0 == arrMonster.length)
				return false;
			
			for each(var monster:BasicOrganismElement in arrMonster)
			{
				monster.hurtBlood(0,FightAttackType.PHYSICAL_ATTACK_TYPE,true,null,true,OrganismDieType.NORMAL_DIE,1,true);
			}
			arrMonster = [];
			return true;
		}
		
		public function addAllTowerEndlessAtkBuff(atkPct:Number):void
		{
			for each(var tower:BasicTowerElement in _towerElementsReference)
			{
				tower.addEndlessBuff(atkPct,0);
			}
		}
		
		public function addAllTowerEndlessAtkSpdBuff(atkSpdPct:int):void
		{
			for each(var tower:BasicTowerElement in _towerElementsReference)
			{
				tower.addEndlessBuff(0,atkSpdPct);
			}
		}
		
		public function getNearestUnit(orgX:int,orgY:int,vecUnits:Vector.<IPositionUnit>):IPositionUnit
		{
			if(!vecUnits || vecUnits.length<=0) 
				return null;
			var resUnit:IPositionUnit;
			var minRange:uint = uint.MAX_VALUE;
			for each(var unit:IPositionUnit in vecUnits)
			{
				var range:uint = (orgX-unit.x)*(orgX-unit.x)+(orgY-unit.y)*(orgY-unit.y);
				if(range<minRange)
				{
					minRange = range;
					resUnit = unit;
				}
			}
			return resUnit;
		}
		
		//范围搜锁, 是能搜到隐身怪的
		public function searchOrganismElementsBySearchArea(centerX:Number, centerY:Number, searchArea:int,
												  searchCamp:int,
												  necessarySearchConditionFilter:Function = null, 
												  ignoreIsAlive:Boolean = false,count:int = 0):Vector.<BasicOrganismElement>
		{
//			var _t:int = getTimer();
			
			var results:Vector.<BasicOrganismElement> = new Vector.<BasicOrganismElement>();
			
			for each(var element:BasicOrganismElement in _organismsElementsReference)
			{
				if((element.campType & searchCamp) != element.campType) 
					continue;
				if(!ignoreIsAlive && !element.isAlive) 
					continue;
				if(!element.getIsSearchable() || element.isOutOfScreen())
					continue;
				if(searchArea > 0)
				{
					if(!GameMathUtil.containsPointInEllipseSearchArea(centerX, centerY, searchArea, element.x, element.y)) continue; 
				}
				
				if(necessarySearchConditionFilter != null)
				{
					if(!necessarySearchConditionFilter(element)) continue;
				}

				results.push(element);
				if(count > 0 && results.length >= count)
					break;
			}
			
//			trace(getTimer() - _t);
			
			return results;
		}
		
		public function searchTowersBySearchArea(centerX:Number, centerY:Number, searchArea:int,count:int = 0,
												 necessarySearchConditionFilter:Function = null):Vector.<BasicTowerElement>
		{
			var results:Vector.<BasicTowerElement> = new Vector.<BasicTowerElement>();
			
			for each(var element:BasicTowerElement in _towerElementsReference)
			{
				if(searchArea > 0)
				{
					if(!GameMathUtil.containsPointInEllipseSearchArea(centerX, centerY, searchArea, element.x, element.y)) continue; 
				}
				
				if(necessarySearchConditionFilter != null)
				{
					if(!necessarySearchConditionFilter(element)) continue;
				}
				
				results.push(element);
				if(count>0 && results.length >= count)
					break;
			}
			
			return results;
		}
		
		public function searchGroundEffsBySearchArea(centerX:Number, centerY:Number, searchArea:int,count:int = 0,necessarySearchConditionFilter:Function = null):Vector.<BasicGroundEffect>
		{
			var results:Vector.<BasicGroundEffect> = new Vector.<BasicGroundEffect>();
			
			for each(var element:BasicGroundEffect in _groundeffElementsReference)
			{
				if(searchArea > 0)
				{
					if(!GameMathUtil.containsPointInEllipseSearchArea(centerX, centerY, searchArea, element.x, element.y)) continue; 
				}
				
				if(necessarySearchConditionFilter != null)
				{
					if(!necessarySearchConditionFilter(element)) continue;
				}
				
				results.push(element);
				if(count>0 && results.length >= count)
					break;
			}
			
			return results;
		}

		//个体普通搜索是搜不到隐身的怪的 
		public function searchOrganismElementEnemy(centerX:Number, centerY:Number, searchArea:int, 
									searchCamp:int,
									necessarySearchConditionFilter:Function = null,ignoreIsAlive:Boolean = false):BasicOrganismElement
		{
			var resultElement:BasicOrganismElement;
			var resultElement1:BasicOrganismElement;
			var disRatio:Number = 2;
			var disTemp:Number = 0;
			
			for each(var element:BasicOrganismElement in _organismsElementsReference)
			{
				if((!ignoreIsAlive && !element.isAlive) ||
					!element.getIsSearchable() ||
					(element.campType & searchCamp) != element.campType ||
					element.isOutOfScreen()) continue;
				
				if(searchArea > 0)
				{
					if(!GameMathUtil.containsPointInEllipseSearchArea(centerX, centerY, searchArea, element.x, element.y)) continue; 
				}
				
				if(necessarySearchConditionFilter != null)
				{
					if(!necessarySearchConditionFilter(element)) continue;
				}
				
				if(FightElementCampType.FRIENDLY_CAMP == searchCamp)
					return element;		
				else if(element is BasicMonsterElement)
				{
					disTemp = (element as BasicMonsterElement).getDisToEndPointRatio();
					if(disTemp<disRatio)
					{
						resultElement = element;
						disRatio = disTemp;
					}
					continue;
				}
				resultElement1 = element;
			}
			
			if(resultElement)
				return resultElement;
			
			return resultElement1;
		}
		
		public function findHeroElementByHeroTypeId(heroTypeId:int):HeroElement
		{
			for each(var element:BasicOrganismElement in _organismsElementsReference)
			{
				if(element is HeroElement && HeroElement(element).objectTypeId == heroTypeId)
				{
					return HeroElement(element);
				}
			}
			
			return null;
		}
		
		public function searchSummonDoorByArea(ix:int,iy:int,area:int):SummonDemonDoorSkillRes
		{
			for each(var door:SummonDemonDoorSkillRes in _summonDoorElementsReference)
			{
				if(GameMathUtil.containsPointInEllipseSearchArea(ix, iy, area, door.x, door.y,1))
					return door;
			}
			return null;
		}
		
		public function disappearAllSummonDoor():void
		{
			var arrDoors:Array = [];
			var door:SummonDemonDoorSkillRes;
			for each( door in _summonDoorElementsReference)
			{
				arrDoors.push(door);
			}
			for each( door in arrDoors)
			{
				door.destorySelf();
			}
			arrDoors = null;
		}

		//-----------------------------------------------------------------------------------
		///*Booelan 竖向*/ 可通过数据列表为一维数组，逐个表示节点的可通过属性
		public function updateGridWalkNodesWalkableData(walkDatas:Array):void
		{
			if(walkDatas == null || walkDatas.length == 0) return;
			
			var numCols:int = GameFightConstant.SCENE_MAP_CELL_COL_COUNT;
			var numRows:int = GameFightConstant.SCENE_MAP_CELL_ROW_COUNT;
			
			var colIndex:int = 0;
			var rowIndex:int = 0;
			
			for(colIndex = 0; colIndex < numCols; colIndex++)
			{
				for(rowIndex = 0; rowIndex < numRows; rowIndex++)
				{
					var walkDatasIndex:int = colIndex * numRows + rowIndex;
					_sceneGrid.setWalkable(colIndex, rowIndex, walkDatas[walkDatasIndex]);
				}
			}
		}

		public function findPath(targetPoint:PointVO, currentPoint:PointVO):Vector.<PointVO>
		{
			//			var t:int = getTimer();
			var startPosX:int = Math.floor(targetPoint.x / GameFightConstant.GRID_CELL_SIZE);
			var startPosY:int = Math.floor(targetPoint.y / GameFightConstant.GRID_CELL_SIZE);
			
			var endPosX:int = Math.floor(targetPoint.x / GameFightConstant.GRID_CELL_SIZE);
			var endPosY:int = Math.floor(targetPoint.y / GameFightConstant.GRID_CELL_SIZE);
			
			if(!_sceneGrid.getNode(endPosX, endPosY).walkable) return null;
			
			var resultNodesPath:Array = null;
			var hasBarrier:Boolean = _sceneGrid.hasBarrier(startPosX, startPosY, endPosX, endPosY);
			if(hasBarrier)
			{
				_sceneGrid.setStartNode(startPosX, startPosY);
				_sceneGrid.setEndNode(endPosX, endPosY);
				
				if(_astar.findPath() && _astar.path.length > 0)
				{
					resultNodesPath = _astar.path;
				}
			}
			else
			{
				resultNodesPath = [_sceneGrid.getNode(endPosX, endPosY)];
			}

			if(resultNodesPath == null || resultNodesPath.length == 0) return null;
			
			var resultPoints:Vector.<PointVO> = new Vector.<PointVO>();
			var n:uint = resultNodesPath.length;
			
			var node:Node = null;
			for(var i:uint = 0; i < n; i++)
			{
				node = resultNodesPath[i];
				var p:PointVO = new PointVO(int(node.x * GameFightConstant.GRID_CELL_SIZE + GameFightConstant.GRID_CELL_HALF_SIZE),
					int(node.y * GameFightConstant.GRID_CELL_SIZE + GameFightConstant.GRID_CELL_HALF_SIZE));
				resultPoints.push(p);
			}
			
			resultPoints[resultPoints.length - 1] = targetPoint;
			
			return resultPoints;
		}
		
		//======================================================================
		//roadLineIndex = -1, roadLine随机 , roadLineIndex >= 0 & < 3 指定某条路
		public function getCurrentSceneRandomRoadPointByCurrentRoadsData(roadLineIndex:int = -1,arrIdxes:Array = null,minLineIdx:int = 0,maxLineIdx:int = 0,minDistance:int = 0):PointVO
		{
			var mapConfigDataVO:MapConfigDataVO = GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo;
			
			var roadVOs:Vector.<RoadVO> = mapConfigDataVO.roadVOs;
			
			var roadIndex:int = GameMathUtil.randomIndexByLength(roadVOs.length);
			var roadVO:RoadVO = roadVOs[roadIndex];
			
			var lineIndex:int = roadLineIndex < 0 ?  GameMathUtil.randomIndexByLength(3) : roadLineIndex;
			var lineVO:LineVO = roadVO.lineVOs[lineIndex];
			
			if(0 == maxLineIdx || maxLineIdx > lineVO.points.length - 1)
				maxLineIdx = lineVO.points.length - 1;
			else if(maxLineIdx < 0)
				maxLineIdx += lineVO.points.length - 1;
			
			if(minLineIdx > lineVO.points.length - 1)
				minLineIdx = lineVO.points.length - 1;
			
			while(GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo.getDisRatioByPosIndex(lineVO.points[maxLineIdx].x
				,lineVO.points[maxLineIdx].y,maxLineIdx,lineIndex,roadIndex,false) < minDistance)
			{
				--maxLineIdx;
				if(maxLineIdx == minLineIdx)
					break;
			}
			
			if(maxLineIdx >= lineVO.points.length)
				maxLineIdx = lineVO.points.length - 1;
			
			var pointIndex:int;
			var ptNext:PointVO;
			var ptResult:PointVO;
			do
			{
				pointIndex =  GameMathUtil.randomUintBetween(minLineIdx,maxLineIdx);	
				
				ptResult = lineVO.points[pointIndex];
				
				if(pointIndex>0)
					ptNext = lineVO.points[pointIndex-1];
				else
					ptNext = lineVO.points[pointIndex+1];
			}
				while(!(ptResult.x>0 && ptResult.x<GameFightConstant.SCENE_MAP_WIDTH && ptResult.y>0 && ptResult.y<GameFightConstant.SCENE_MAP_HEIGHT
				&& ptNext.x>0 && ptNext.x<GameFightConstant.SCENE_MAP_WIDTH && ptNext.y>0 && ptNext.y<GameFightConstant.SCENE_MAP_HEIGHT));
					
			
			if(arrIdxes)
			{
				arrIdxes.length = 0;
				arrIdxes.push(roadIndex);
				arrIdxes.push(lineIndex);
				arrIdxes.push(pointIndex);
			}
			
			
			var pt:Point = GameMathUtil.interpolateTwoPoints(ptResult,ptNext,Math.random());
			
			return new PointVO(pt.x,pt.y);//lineVO.points[pointIndex].clone();
		}
		
		public function getSomeRandomRoadPoints(count:int,arrPtIdxes:Array = null,minLineIdx:int = 0,maxLineIdx:int = 0,minDistance:int = 0,bIsSummonDoor:Boolean = false):Vector.<PointVO>
		{
			if(count<=0)
				return null;
			var vecPt:Vector.<PointVO> = new Vector.<PointVO>;
			var ptResult:PointVO;
			var arrIdx:Array;
			if(arrPtIdxes)
				arrPtIdxes.length = 0;
			var num:int;
			for(var i:int= 0;i<count;++i)
			{
				arrIdx = [];
				num = 0;
				do
				{
					ptResult = getCurrentSceneRandomRoadPointByCurrentRoadsData(-1,arrIdx,minLineIdx,maxLineIdx,minDistance);
					if(++num > 300)
						break;
				}
				while(hasPtExist(ptResult,vecPt,bIsSummonDoor) || (bIsSummonDoor 
					&& null != searchSummonDoorByArea(ptResult.x,ptResult.y,60)));
						
				vecPt.push(ptResult);
				if(arrPtIdxes)
					arrPtIdxes.push(arrIdx);
			}
			return vecPt;
		}
		
		private function hasPtExist(pt:PointVO,vec:Vector.<PointVO>,bIsSummonDoor:Boolean = false):Boolean
		{
			if(!pt || !vec || vec.length<=0)
				return false;
			for each(var p:PointVO in vec)
			{
				if( (int(pt.x) == int(p.x) && int(pt.y) == int(p.y)) ||
					(bIsSummonDoor && GameMathUtil.containsPointInEllipseSearchArea(pt.x, pt.y, 80, p.x, p.y,1)))
					return true;
			}
			return false;
		}
			
		//----------------------------------------------------------------------
		//Interface IDisposeObject
		public function dispose():void
		{
			_astar = null;
			_sceneGrid = null;
//			_quadTree.removeAll();
//			_quadTree = null;
		}
	}
}