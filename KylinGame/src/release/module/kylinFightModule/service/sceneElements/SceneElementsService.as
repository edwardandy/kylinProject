package release.module.kylinFightModule.service.sceneElements
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import io.smash.time.IRenderAble;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import release.module.kylinFightModule.gameplay.constant.FightAttackType;
	import release.module.kylinFightModule.gameplay.constant.FightElementCampType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.OrganismDieType;
	import release.module.kylinFightModule.gameplay.oldcore.core.IFightLifecycle;
	import release.module.kylinFightModule.gameplay.oldcore.core.TickSynchronizer;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SummonDemonDoorSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.IPositionUnit;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.model.roads.MapLineVO;
	import release.module.kylinFightModule.model.roads.MapRoadVO;
	import release.module.kylinFightModule.model.sceneElements.ISceneElementsModel;
	import release.module.kylinFightModule.model.sceneElements.SceneElementsModel;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 场景管理提供的功能 
	 * @author Edward
	 * 
	 */	
	public class SceneElementsService extends KylinActor implements IRenderAble,ISceneElementsService,IFightLifecycle
	{
		[Inject]
		public var sceneElementsModel:ISceneElementsModel;
		[Inject]
		public var renderMgr:TickSynchronizer;
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		[Inject]
		public var mapRoadModel:IMapRoadModel;
		
		private var _groundSceneDepthRenderElements:Vector.<DisplayObject> = null;
		private var _groundSceneDepthRenderElementLength:uint = 0;
		private var _groundSceneDepthRenderElementIndex:uint = 0;
		private var _curentSceneDepthRenderElement:DisplayObject;
		
		private var _sceneElementsModel:SceneElementsModel;
		
		public function SceneElementsService()
		{
			super();
		}
		
		[PostConstruct]
		public function onPostConstruct():void
		{
			_sceneElementsModel = sceneElementsModel as SceneElementsModel;
		}
		
		public function render(iElapse:int):void
		{
			_groundSceneDepthRenderElements = _sceneElementsModel.allDepthRenderElements.concat();
			_groundSceneDepthRenderElements.sort(groundSceneDepthRenderElementSortFunction);
			
			_groundSceneDepthRenderElementLength = _groundSceneDepthRenderElements.length;
			_groundSceneDepthRenderElementIndex = 0;

			for(; _groundSceneDepthRenderElementIndex < _groundSceneDepthRenderElementLength; 
				_groundSceneDepthRenderElementIndex++)
			{
				_curentSceneDepthRenderElement = _groundSceneDepthRenderElements[_groundSceneDepthRenderElementIndex];
				fightViewModel.middleLayer.setChildIndex(_curentSceneDepthRenderElement, 0);
			}
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function getAllEnemyCampOrganismElementsCount():int
		{
			var count:uint = 0;
			for each(var element:BasicOrganismElement in _sceneElementsModel.organismsElements)
			{
				if(element.campType == FightElementCampType.ENEMY_CAMP && (element.isAlive || !element.isFreezedState()))
					count++;
			}
			return count;
		}
		/**
		 * @inheritDoc 
		 */		
		public function getAllAliveEnemys():Vector.<BasicMonsterElement>
		{
			var result:Vector.<BasicMonsterElement> = new Vector.<BasicMonsterElement>;
			for each(var element:BasicOrganismElement in _sceneElementsModel.organismsElements)
			{
				if(element.campType == FightElementCampType.ENEMY_CAMP && (element.isAlive /*|| !element.isFreezedState()*/))
				{
					result.push(element);
				}
			}
			return result;
		}
		/**
		 * @inheritDoc 
		 */	
		public function killAllEnemies():Boolean
		{
			var arrMonster:Array=[];
			for each(var element:BasicOrganismElement in _sceneElementsModel.organismsElements)
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
		/**
		 * @inheritDoc 
		 */	
		public function addAllTowerEndlessAtkBuff(atkPct:Number):void
		{
			for each(var tower:BasicTowerElement in _sceneElementsModel.towerElements)
			{
				tower.addEndlessBuff(atkPct,0);
			}
		}
		/**
		 * @inheritDoc 
		 */	
		public function addAllTowerEndlessAtkSpdBuff(atkSpdPct:int):void
		{
			for each(var tower:BasicTowerElement in _sceneElementsModel.towerElements)
			{
				tower.addEndlessBuff(0,atkSpdPct);
			}
		}
		/**
		 * @inheritDoc 
		 */	
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
		/**
		 * @inheritDoc 
		 */			
		public function searchOrganismElementsBySearchArea(centerX:Number, centerY:Number, searchArea:int,
														   searchCamp:int,
														   necessarySearchConditionFilter:Function = null, 
														   ignoreIsAlive:Boolean = false,count:int = 0):Vector.<BasicOrganismElement>
		{			
			var results:Vector.<BasicOrganismElement> = new Vector.<BasicOrganismElement>();
			
			for each(var element:BasicOrganismElement in _sceneElementsModel.organismsElements)
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
			return results;
		}
		/**
		 * @inheritDoc 
		 */	
		public function searchTowersBySearchArea(centerX:Number, centerY:Number, searchArea:int,count:int = 0,
												 necessarySearchConditionFilter:Function = null):Vector.<BasicTowerElement>
		{
			var results:Vector.<BasicTowerElement> = new Vector.<BasicTowerElement>();
			
			for each(var element:BasicTowerElement in _sceneElementsModel.towerElements)
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
		/**
		 * @inheritDoc 
		 */	
		public function searchGroundEffsBySearchArea(centerX:Number, centerY:Number, searchArea:int,count:int = 0
													 ,necessarySearchConditionFilter:Function = null):Vector.<BasicGroundEffect>
		{
			var results:Vector.<BasicGroundEffect> = new Vector.<BasicGroundEffect>();
			
			for each(var element:BasicGroundEffect in _sceneElementsModel.groundEffElements)
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
		
		/**
		 *  个体普通搜索是搜不到隐身的怪的 
		 * @param centerX
		 * @param centerY
		 * @param searchArea
		 * @param searchCamp
		 * @param necessarySearchConditionFilter
		 * @param ignoreIsAlive
		 * @return 
		 * 
		 */		
		public function searchOrganismElementEnemy(centerX:Number, centerY:Number, searchArea:int, 
												   searchCamp:int,
												   necessarySearchConditionFilter:Function = null,ignoreIsAlive:Boolean = false):BasicOrganismElement
		{
			var resultElement:BasicOrganismElement;
			var resultElement1:BasicOrganismElement;
			var disRatio:Number = 2;
			var disTemp:Number = 0;
			
			for each(var element:BasicOrganismElement in _sceneElementsModel.organismsElements)
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
		/**
		 * @inheritDoc 
		 */	
		public function findHeroElementByHeroTypeId(heroTypeId:int):HeroElement
		{
			return _sceneElementsModel.getHeorElementByTypeId(heroTypeId);
		}
		/**
		 * @inheritDoc 
		 */	
		public function searchSummonDoorByArea(ix:int,iy:int,area:int):SummonDemonDoorSkillRes
		{
			for each(var door:SummonDemonDoorSkillRes in _sceneElementsModel.summonDoors)
			{
				if(GameMathUtil.containsPointInEllipseSearchArea(ix, iy, area, door.x, door.y,1))
					return door;
			}
			return null;
		}
		/**
		 * @inheritDoc 
		 */	
		public function disappearAllSummonDoor():void
		{
			var arrDoors:Array = [];
			var door:SummonDemonDoorSkillRes;
			for each( door in _sceneElementsModel.summonDoors)
			{
				arrDoors.push(door);
			}
			for each( door in arrDoors)
			{
				door.destorySelf();
			}
			arrDoors = null;
		}
		/**
		 * @inheritDoc 
		 */	
		public function getCurrentSceneRandomRoadPointByCurrentRoadsData(roadLineIndex:int = -1,arrIdxes:Array = null
																		 ,minLineIdx:int = 0,maxLineIdx:int = 0,minDistance:int = 0):PointVO
		{	
			var roadIndex:int = GameMathUtil.randomIndexByLength(mapRoadModel.roadCount);
			var roadVO:MapRoadVO = mapRoadModel.getMapRoad(roadIndex);
			
			var lineIndex:int = roadLineIndex < 0 ?  GameMathUtil.randomIndexByLength(3) : roadLineIndex;
			var lineVO:MapLineVO = roadVO.lineVOs[lineIndex];
			
			if(0 == maxLineIdx || maxLineIdx > lineVO.points.length - 1)
				maxLineIdx = lineVO.points.length - 1;
			else if(maxLineIdx < 0)
				maxLineIdx += lineVO.points.length - 1;
			
			if(minLineIdx > lineVO.points.length - 1)
				minLineIdx = lineVO.points.length - 1;
			
			while(mapRoadModel.getDisRatioByPosIndex(lineVO.points[maxLineIdx].x,lineVO.points[maxLineIdx].y,maxLineIdx,lineIndex,roadIndex,false)
				< minDistance)
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
			
			return new PointVO(pt.x,pt.y);
		}
		/**
		 * @inheritDoc 
		 */	
		public function getSomeRandomRoadPoints(count:int,arrPtIdxes:Array = null,minLineIdx:int = 0
												,maxLineIdx:int = 0,minDistance:int = 0,bIsSummonDoor:Boolean = false):Vector.<PointVO>
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
		
		/**
		 * 这里返回的结果是，场景中层次高在数组的前面， -1表示在上层 1表示在下层
		 * @param a
		 * @param b
		 * @return 
		 * 
		 */		
		private function groundSceneDepthRenderElementSortFunction(a:DisplayObject, b:DisplayObject):Number
		{
			if(a.y > b.y)
				return -1;
			else if(a.y < b.y)
				return 1;
			else//相等时
			{
				//左边的排在下面
				if(a.x > b.x)
					return -1;
				else if(a.x < b.x)
					return 1;
				else//最坏的情况所有全都相等//原来在上层的还是在上层
					return fightViewModel.middleLayer.getChildIndex(a) < fightViewModel.middleLayer.getChildIndex(DisplayObject(b)) ? 1 : -1;
			}
		}
		/**
		 * @inheritDoc 
		 */		
		public function onFightStart():void
		{
			renderMgr.attachToTicker(this);
		}
		/**
		 * 战斗结束 
		 * 
		 */		
		public function onFightEnd():void
		{
			renderMgr.dettachFromTicker(this);
		}
		/**
		 * @inheritDoc 
		 */		
		public function onFightPause():void
		{
			
		}
		/**
		 * @inheritDoc 
		 */		
		public function onFightResume():void
		{
			
		}
		/**
		 * @inheritDoc 
		 */	
		public function dispose():void
		{
			_groundSceneDepthRenderElements = null;
			_sceneElementsModel = null;
		}
	}
}