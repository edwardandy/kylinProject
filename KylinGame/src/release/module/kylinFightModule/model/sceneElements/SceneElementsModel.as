package release.module.kylinFightModule.model.sceneElements
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import mainModule.model.gameData.dynamicData.hero.IHeroDynamicDataModel;
	
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.GroundSceneElementLayerType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.ToftElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SummonDemonDoorSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import release.module.kylinFightModule.gameplay.oldcore.vo.map.SceneElementVO;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;
	import release.module.kylinFightModule.model.roads.MapLineVO;
	import release.module.kylinFightModule.model.roads.MapRoadVO;
	import release.module.kylinFightModule.model.scene.SceneTypeConst;
	import release.module.kylinFightModule.utili.structure.PointVO;

	/**
	 * 战斗场景显示元素管理器 
	 * @author Edward
	 * 
	 */	
	public class SceneElementsModel extends KylinActor implements ISceneElementsModel
	{
		[Inject]
		public var fightViewLayers:IFightViewLayersModel;
		[Inject]
		public var mapRoadModel:IMapRoadModel;
		[Inject]
		public var sceneModel:ISceneDataModel;
		[Inject]
		public var heroData:IHeroDynamicDataModel;
		[Inject]
		public var objPoolMgr:ObjectPoolManager;
		
		private var _allDepthRenderElements:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private var _allElementsMap:Dictionary = new Dictionary();
		
		private var _towerElements:Vector.<BasicTowerElement> = new Vector.<BasicTowerElement>();
		private var _organismsElements:Vector.<BasicOrganismElement> = new Vector.<BasicOrganismElement>();
		private var _heroElements:Vector.<HeroElement> = new Vector.<HeroElement>();
		private var _groundEffElements:Vector.<BasicGroundEffect> = new Vector.<BasicGroundEffect>();	
		private var _summonDoors:Vector.<SummonDemonDoorSkillRes> = new Vector.<SummonDemonDoorSkillRes>;
		
		private var _endPointFlag:MovieClip;
		
		public function SceneElementsModel()
		{
			super();
		}
		
		public function get summonDoors():Vector.<SummonDemonDoorSkillRes>
		{
			return _summonDoors;
		}

		public function get groundEffElements():Vector.<BasicGroundEffect>
		{
			return _groundEffElements;
		}

		public function get organismsElements():Vector.<BasicOrganismElement>
		{
			return _organismsElements;
		}

		public function get towerElements():Vector.<BasicTowerElement>
		{
			return _towerElements;
		}

		public function get allDepthRenderElements():Vector.<DisplayObject>
		{
			return _allDepthRenderElements;
		}

		public function initBeforeFightStart():void
		{
			updateMapRoadShape();
			checkEndPointFlag(sceneModel.sceneType);
		}
		
		public final function addSceneElemet(e:BasicSceneElement):void
		{
			if(e == null || _allElementsMap[e] != undefined) return;
			
			_allElementsMap[e] = true;
			
			var elemeCategory:String = e.elemeCategory;
			switch(e.elemeCategory)
			{
				case GameObjectCategoryType.MONSTER:
				case GameObjectCategoryType.SOLDIER:
				case GameObjectCategoryType.HERO:
				case GameObjectCategoryType.SUPPORT_SOLDIER:
				case GameObjectCategoryType.SUMMON_BY_ORGANISM:
				case GameObjectCategoryType.SUMMON_BY_TOWER:
					_organismsElements.push(e);
					_allDepthRenderElements.push(e);
					
					if(elemeCategory == GameObjectCategoryType.HERO)
					{
						_heroElements.push(e);
					}
					break;
				
				case GameObjectCategoryType.TOWER:
					_towerElements.push(e);
					_allDepthRenderElements.push(e);
					break; 
				case GameObjectCategoryType.GROUNDEFFECT:
					_groundEffElements.push(e);
					break; 
			}
			
			if(e is SummonDemonDoorSkillRes)
				_summonDoors.push(e);
			
			var layerType:int = e.groundSceneLayerType;
			switch(layerType)
			{
				case GroundSceneElementLayerType.LAYER_MIDDLE:
					fightViewLayers.middleLayer.addChild(e);
					break;
				
				case GroundSceneElementLayerType.LAYER_TOP:
					fightViewLayers.topLayer.addChild(e);
					break;
				
				case GroundSceneElementLayerType.LAYER_BOTTOM:
					fightViewLayers.bottomLayer.addChild(e);
					break;
				
				default:
					throw new Error("GroundScene::addSceneElemet unknow layerType " + layerType);
					break;
			}
		}
		
		public final function removeSceneElemet(e:BasicSceneElement):void
		{
			if(e == null || _allElementsMap[e] == undefined) 
				return;
			
			delete _allElementsMap[e];
			
			var elemeCategory:String = e.elemeCategory;
			switch(e.elemeCategory)
			{
				case GameObjectCategoryType.MONSTER:
				case GameObjectCategoryType.SOLDIER:
				case GameObjectCategoryType.HERO:
				case GameObjectCategoryType.SUPPORT_SOLDIER:
				case GameObjectCategoryType.SUMMON_BY_ORGANISM:
				case GameObjectCategoryType.SUMMON_BY_TOWER:
					_organismsElements.splice(_organismsElements.indexOf(e as BasicOrganismElement), 1);
					_allDepthRenderElements.splice(_allDepthRenderElements.indexOf(e), 1);
					
					if(elemeCategory == GameObjectCategoryType.HERO)
					{
						_heroElements.splice(_heroElements.indexOf(e as HeroElement), 1);
					}
					break;
				
				case GameObjectCategoryType.TOWER:
					_towerElements.splice(_towerElements.indexOf(e as BasicTowerElement), 1);
					_allDepthRenderElements.splice(_allDepthRenderElements.indexOf(e), 1);
					break;
				case GameObjectCategoryType.GROUNDEFFECT:
					_groundEffElements.splice(_groundEffElements.indexOf(e as BasicGroundEffect), 1);
					break;
				/*case GameObjectCategoryType.SKILLRES:
				_allDepthRenderElements.splice(_allDepthRenderElements.indexOf(e), 1);
				break;	*/
			}
			
			if(e is SummonDemonDoorSkillRes)
				_summonDoors.splice(_summonDoors.indexOf(e as SummonDemonDoorSkillRes), 1);
			
			switch(e.groundSceneLayerType)
			{
				case GroundSceneElementLayerType.LAYER_MIDDLE:
					fightViewLayers.middleLayer.removeChild(e);
					break;
				
				case GroundSceneElementLayerType.LAYER_TOP:
					fightViewLayers.topLayer.removeChild(e);
					break;
				
				case GroundSceneElementLayerType.LAYER_BOTTOM:
					fightViewLayers.bottomLayer.removeChild(e);
					break;
				
				default:
					throw new Error("GroundScene::addSceneElemet unknow layerType " + e.groundSceneLayerType);
					break;
			}
		}
		
		public final function destoryAllSceneElements():void
		{
			var element:BasicSceneElement = null;
			var tempElements:Vector.<BasicSceneElement> = new Vector.<BasicSceneElement>;
			
			for(var e:* in _allElementsMap)
			{
				tempElements.push(e);	
			}
			
			for each(element in tempElements)
			{
				element.destorySelf();
			}
			tempElements.length = 0;
		}
		
		public final function getHeorElementByTypeId(heroTypeId:int):HeroElement
		{
			for each(var heroElement:HeroElement in _heroElements)
			{
				if(heroElement.objectTypeId == heroTypeId) 
					return heroElement;
			}
			return null;
		}
		
		public final function swapSceneElementLayerType(e:BasicSceneElement, toGroundSceneLayerType:int):void
		{
			if(e == null || _allElementsMap[e] == undefined) return;
			
			switch(e.elemeCategory)
			{
				case GameObjectCategoryType.MONSTER:
				case GameObjectCategoryType.SOLDIER:
				case GameObjectCategoryType.HERO:
				case GameObjectCategoryType.SUPPORT_SOLDIER:
				case GameObjectCategoryType.TOWER:
					return;//不允许
					break;
			}
			
			//目前只允许从 GroundSceneElementLayerType.LAYER_TOP -> GroundSceneElementLayerType.LAYER_BOTTOM;
			if(e.groundSceneLayerType == GroundSceneElementLayerType.LAYER_TOP && 
				toGroundSceneLayerType == GroundSceneElementLayerType.LAYER_BOTTOM)
			{
				fightViewLayers.topLayer.removeChild(e);
				fightViewLayers.bottomLayer.addChild(e);
				e.notifySwapSceneElementLayerType(toGroundSceneLayerType);
			}
			else
			{
				throw new Error("GroundScene::swapSceneElementLayerType forbidden toGroundSceneLayerType " + toGroundSceneLayerType);
			}
		}
		
		public function hisTestMapRoad(x:Number, y:Number):Boolean
		{
			return fightViewLayers.roadHitTestShape.hitTestPoint(x, y, true);
		}
		
		public function onFightStart():void
		{
			initializeSceneElement();
		}
		/**
		 * 战斗结束 
		 * 
		 */		
		public function onFightEnd():void
		{
			destoryAllSceneElements();
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
		
		public function dispose():void
		{
			_towerElements = null;
			_organismsElements = null;
			_groundEffElements = null;
			_summonDoors = null;
			_allElementsMap = null;
			_endPointFlag = null;
			_allDepthRenderElements = null;
		}
		
		/**
		 * 更新怪物逃跑路径点击测试的形状 
		 * 
		 */		
		private function updateMapRoadShape():void
		{
			fightViewLayers.roadHitTestShape.graphics.clear();
			fightViewLayers.roadHitTestShape.graphics.lineStyle(GameFightConstant.ROAD_WIDTH, 0x0);
			
			var i:uint = 0;
			var j:uint = 0; 
			var n:uint = 0;
			var m:uint = 0;
			
			var roadVO:MapRoadVO = null;
			var middleLineVO:MapLineVO = null; 
			var point:PointVO = null;
			
			n = mapRoadModel.roadCount;
			for(i = 0; i< n; i++)
			{
				roadVO = mapRoadModel.getMapRoad(i);
				middleLineVO = roadVO.lineVOs[1];
				
				fightViewLayers.roadHitTestShape.graphics.moveTo(middleLineVO.points[0].x, middleLineVO.points[0].y);
				
				m = middleLineVO.points.length;
				for(j = 1; j < m; j++)
				{
					point = middleLineVO.points[j];
					fightViewLayers.roadHitTestShape.graphics.lineTo(point.x, point.y);
				}
			}
			
			fightViewLayers.roadHitTestShape.graphics.endFill();
		}
		/**
		 * 添加怪物逃跑终点动画 
		 * @param iType 场景类型
		 * 
		 */		
		private function checkEndPointFlag(iType:int):void
		{
			if(_endPointFlag && fightViewLayers.groundLayer.contains(_endPointFlag))
			{
				_endPointFlag.gotoAndStop(1);
				fightViewLayers.groundLayer.removeChild(_endPointFlag);
			}
			
			switch(iType)
			{
				case SceneTypeConst.Grass:
					_endPointFlag = new EndPointFlag_1;
					break;
				case SceneTypeConst.Snow:
					_endPointFlag = new EndPointFlag_2;
					break;
				case SceneTypeConst.Lava:
					_endPointFlag = new EndPointFlag_3;
					break;
				case SceneTypeConst.Desert:
					_endPointFlag = new EndPointFlag_4;
					break;
				case SceneTypeConst.Swamp:
					_endPointFlag = new EndPointFlag_5;
					break;
				case SceneTypeConst.EndlessMap:
					_endPointFlag = new EndPointFlag_6;
					break;
				default:
					return;
			}
			_endPointFlag.x = mapRoadModel.ptRoadEnd.x;
			_endPointFlag.y = mapRoadModel.ptRoadEnd.y;
			_endPointFlag.mouseEnabled = false;
			_endPointFlag.mouseChildren = false;
			_endPointFlag.gotoAndPlay(1);
			fightViewLayers.groundLayer.addChild(_endPointFlag);
		}
		
		/**
		 * 初始化场景元素，包括塔基，英雄等 
		 * 
		 */		
		private function initializeSceneElement():void
		{
			//配置
			var elementVOs:Vector.<SceneElementVO> = sceneModel.sceneInitElementsVo;
			for each(var elementVO:SceneElementVO in elementVOs)
			{
				var category:String = elementVO.category;
				if(category == GameObjectCategoryType.HERO) 
					continue;//不允许配置文件里面添加英雄单位
				
				var sceneElement:BasicSceneElement = objPoolMgr.createSceneElementObject(category, elementVO.typeId, false) as BasicSceneElement; 
				
				if(sceneElement != null)
				{
					sceneElement.x = elementVO.x;
					sceneElement.y = elementVO.y;
					
					if(category == GameObjectCategoryType.TOFT)
					{
						var toftPointArr:Array = String(elementVO.xmlData.@meetPoint).split("|");
						ToftElement(sceneElement).setMeetingCenterPoint(new PointVO(int(toftPointArr[0]), int(toftPointArr[1])));
						sceneElement.notifyLifecycleActive();
						sceneElement.render(0);
						if(1 == int(elementVO.xmlData.@locked))
							ToftElement(sceneElement).enable = false;
						else
							ToftElement(sceneElement).enable = true;
					}
					else
						sceneElement.notifyLifecycleActive();
				}
			}
			
			//英雄
			var currentHeroIds:Array = heroData.arrHeroIdsInFight;
			if(currentHeroIds == null || currentHeroIds.length == 0) return;
			
			var endPointMarkPosition:PointVO = mapRoadModel.ptRoadEnd;
			//这里终点是应该所有的路都合并了，所以取任意一条路都可以
			var roadLinePointPath:Vector.<PointVO> = mapRoadModel.getMapRoad(0).lineVOs[1].points;
			
			//最后一点和前面一点的角度
			var directionRadian:Number = GameMathUtil.caculateDirectionRadianByTwoPoint(
				roadLinePointPath[roadLinePointPath.length - 1], 
				roadLinePointPath[roadLinePointPath.length - 2]);
			
			var heroElement0:HeroElement = null;//左边
			var heroElement1:HeroElement = null;//中间
			var heroElement2:HeroElement = null;//右边
			
			var n:uint = currentHeroIds.length;//n可能的值为0，1，2，3
			if(n == 1)
			{
				heroElement1 = objPoolMgr.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[0], false) as HeroElement;
				heroElement1.x = endPointMarkPosition.x;
				heroElement1.y = endPointMarkPosition.y;
				heroElement1.notifyLifecycleActive();
				heroElement1.setAngle(directionRadian, true);
			}
			else if(n > 1)
			{
				var leftAndRightHeroStandPoints:Array =  GameMathUtil.caculateTwoEqualDistanceLRPointByCenterPointAndDirection(endPointMarkPosition,
					directionRadian, GameFightConstant.HERO_DEFAULT_STAND_CIRCLE_RADIUS);
				
				if(n == 2)
				{
					heroElement0 = objPoolMgr.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[0], false) as HeroElement;
					heroElement0.x = leftAndRightHeroStandPoints[0].x;
					heroElement0.y = leftAndRightHeroStandPoints[0].y;
					heroElement0.notifyLifecycleActive();
					heroElement0.setAngle(directionRadian, true);
					
					heroElement2 = objPoolMgr.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[1], false) as HeroElement;
					heroElement2.x = leftAndRightHeroStandPoints[1].x;
					heroElement2.y = leftAndRightHeroStandPoints[1].y;
					heroElement2.notifyLifecycleActive();
					heroElement2.setAngle(directionRadian, true);
				}
				else if(n == 3)
				{
					heroElement0 = objPoolMgr.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[0], false) as HeroElement;
					heroElement0.x = leftAndRightHeroStandPoints[0].x;
					heroElement0.y = leftAndRightHeroStandPoints[0].y;
					heroElement0.notifyLifecycleActive();
					heroElement0.setAngle(directionRadian, true);
					
					heroElement1 = objPoolMgr.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[1], false) as HeroElement;
					heroElement1.x = endPointMarkPosition.x;
					heroElement1.y = endPointMarkPosition.y;
					heroElement1.notifyLifecycleActive();
					heroElement1.setAngle(directionRadian, true);
					
					heroElement2 = objPoolMgr.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[2], false) as HeroElement;
					heroElement2.x = leftAndRightHeroStandPoints[1].x;
					heroElement2.y = leftAndRightHeroStandPoints[1].y;
					heroElement2.notifyLifecycleActive();
					heroElement2.setAngle(directionRadian, true);
				}
			}
		}
	}
}