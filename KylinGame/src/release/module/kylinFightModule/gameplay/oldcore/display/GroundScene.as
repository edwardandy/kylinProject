package release.module.kylinFightModule.gameplay.oldcore.display
{
	import com.shinezone.towerDefense.fight.algorithms.astar.Grid;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.GroundSceneElementLayerType;
	import com.shinezone.towerDefense.fight.constants.SceneType;
	import com.shinezone.towerDefense.fight.constants.TowerDefenseGameState;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.core.IRenderAble;
	import release.module.kylinFightModule.gameplay.oldcore.core.TickSynchronizer;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.basics.BasicSceneElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.ToftElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SummonDemonDoorSkillRes;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.bulletEffects.BasicBulletEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.groundEffect.BasicGroundEffect;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.BasicOrganismElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.LineVO;
	import com.shinezone.towerDefense.fight.vo.map.MapConfigDataParserHelperUtil;
	import com.shinezone.towerDefense.fight.vo.map.MapConfigDataVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	import release.module.kylinFightModule.gameplay.oldcore.vo.map.SceneElementVO;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import framecore.structure.model.user.UserData;
	
	import mx.core.mx_internal;


	public class GroundScene extends BasicView implements IDisposeObject, IMonsterMarchImplementor, IRenderAble
	{
		private var _allTopDepthRenderLayer:Sprite = null;
		private var _allMiddleDepthRenderLayer:Sprite = null;
		private var _allBottomDepthRenderLayer:Sprite = null;

		private var _roadShape:Shape = null;
		//test
		private var _roadTestShape:Shape = null;
		
		private var _groundMap:Sprite = null;
		private var _endPointFlag:MovieClip;
		private var _endPointLayerIdx:int;
		private var _endPointFlag1:EndPointFlag_1;
		private var _endPointFlag2:EndPointFlag_2;
		private var _endPointFlag3:EndPointFlag_3;
		private var _endPointFlag4:EndPointFlag_4;
		private var _endPointFlag5:EndPointFlag_5;
		private var _endPointFlag6:EndPointFlag_6;
		
		private var _allDepthRenderElements:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		private var _towerElements:Vector.<BasicTowerElement> = new Vector.<BasicTowerElement>();
		private var _organismsElements:Vector.<BasicOrganismElement> = new Vector.<BasicOrganismElement>();
		private var _heroElements:Vector.<HeroElement> = new Vector.<HeroElement>();
		private var _groundEffElements:Vector.<BasicGroundEffect> = new Vector.<BasicGroundEffect>();	
		private var _summonDoors:Vector.<SummonDemonDoorSkillRes> = new Vector.<SummonDemonDoorSkillRes>;

		private var _allElementsMap:Dictionary = new Dictionary();

		public function GroundScene()
		{
			super();
		}

		//GroundScene Interface
		//初始化场景数据
		public function initializeGameSceneMapData(data:MapConfigDataVO, backgroundMap:Sprite):void
		{
			if(!isInitialized || 
				GameAGlobalManager.getInstance().game.gameState != TowerDefenseGameState.GAME_READY) return;

			updateBackgroundMap(backgroundMap);
			GameAGlobalManager.getInstance().groundSceneHelper.updateGridWalkNodesWalkableData(data.walkDatas);
			updateMapRoadShape(data);
//			updateMapRoadTestShape(data);
			//initializeSceneElement(data);
			checkEndPointFlag(data.sceneType);
			_endPointFlag.x = data.endPointMarkPosition.x;
			_endPointFlag.y = data.endPointMarkPosition.y;
			
			TickSynchronizer.getInstance().attachToTicker(this);
		}
		
		private function checkEndPointFlag(iType:int):void
		{
			if(_endPointFlag && contains(_endPointFlag))
			{
				_endPointFlag.gotoAndStop(1);
				removeChild(_endPointFlag);
			}
			
			switch(iType)
			{
				case SceneType.Grassland:
					_endPointFlag1 ||= new EndPointFlag_1;
					_endPointFlag = _endPointFlag1 as MovieClip;
					break;
				case SceneType.Snowland:
					_endPointFlag2 ||= new EndPointFlag_2;
					_endPointFlag = _endPointFlag2 as MovieClip;
					break;
				case SceneType.Lavaland:
					_endPointFlag3 ||= new EndPointFlag_3;
					_endPointFlag = _endPointFlag3 as MovieClip;
					break;
				case SceneType.Desert:
					_endPointFlag4 ||= new EndPointFlag_4;
					_endPointFlag = _endPointFlag4 as MovieClip;
					break;
				case SceneType.Swamp:
					_endPointFlag5 ||= new EndPointFlag_5;
					_endPointFlag = _endPointFlag5 as MovieClip;
					break;
				case SceneType.EndlessMap:
					_endPointFlag6 ||= new EndPointFlag_6;
					_endPointFlag = _endPointFlag6 as MovieClip;
					break;
				default:
					return;
			}
			
			_endPointFlag.mouseEnabled = false;
			_endPointFlag.mouseChildren = false;
			_endPointFlag.gotoAndPlay(1);
			addChildAt(_endPointFlag,_endPointLayerIdx+1);
		}
		
		//发怪
		public function marchMonster(m:BasicMonsterElement, pathPoints:Vector.<PointVO>, roadIndex:int, lineIndex:int):void
		{
//			return;
			m.x = pathPoints[0].x;
			m.y = pathPoints[0].y;
			m.startEscapeByPath(pathPoints, roadIndex, lineIndex);
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
				/*case GameObjectCategoryType.SKILLRES:
					_allDepthRenderElements.push(e);
					break;	*/
			}
			
			if(e is SummonDemonDoorSkillRes)
				_summonDoors.push(e);
			
			var layerType:int = e.groundSceneLayerType;
			switch(layerType)
			{
				case GroundSceneElementLayerType.LAYER_MIDDLE:
					_allMiddleDepthRenderLayer.addChild(e);
					break;
				
				case GroundSceneElementLayerType.LAYER_TOP:
					_allTopDepthRenderLayer.addChild(e);
					break;
				
				case GroundSceneElementLayerType.LAYER_BOTTOM:
					_allBottomDepthRenderLayer.addChild(e);
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
					_allMiddleDepthRenderLayer.removeChild(e);
					break;
				
				case GroundSceneElementLayerType.LAYER_TOP:
					_allTopDepthRenderLayer.removeChild(e);
					break;
				
				case GroundSceneElementLayerType.LAYER_BOTTOM:
					_allBottomDepthRenderLayer.removeChild(e);
					break;

				default:
					throw new Error("GroundScene::addSceneElemet unknow layerType " + e.groundSceneLayerType);
					break;
			}
		}
		
		public final function destoryAllSceneElements():void
		{
			for(var sceneElement:* in _allElementsMap)
			{
				BasicSceneElement(sceneElement).destorySelf();
			}
		}
		
		public final function getHeorElementByTypeId(heroTypeId:int):HeroElement
		{
			for each(var heroElement:HeroElement in _heroElements)
			{
				if(heroElement.objectTypeId == heroTypeId) return heroElement
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
				_allTopDepthRenderLayer.removeChild(e);
				_allBottomDepthRenderLayer.addChild(e);
				e.notifySwapSceneElementLayerType(toGroundSceneLayerType);
			}
			else
			{
				throw new Error("GroundScene::swapSceneElementLayerType forbidden toGroundSceneLayerType " + toGroundSceneLayerType);
			}
		}
		
		public function hisTestMapRoad(x:Number, y:Number):Boolean
		{
			return _roadShape.hitTestPoint(x, y, true);
		}

		//IDisposeObject Interface
		override public function dispose():void
		{
			super.dispose();
			
			removeChild(_roadShape);
			_roadShape = null;
			
			removeChild(_endPointFlag);
			_endPointFlag = null;
			
			while(_allTopDepthRenderLayer.numChildren > 0) _allTopDepthRenderLayer.removeChildAt(0);
			removeChild(_allTopDepthRenderLayer);
			_allTopDepthRenderLayer = null;
			
			while(_allMiddleDepthRenderLayer.numChildren > 0) _allMiddleDepthRenderLayer.removeChildAt(0);
			removeChild(_allMiddleDepthRenderLayer);
			_allMiddleDepthRenderLayer = null;
			
			while(_allBottomDepthRenderLayer.numChildren > 0) _allBottomDepthRenderLayer.removeChildAt(0);
			removeChild(_allBottomDepthRenderLayer);
			_allBottomDepthRenderLayer = null;
			
			removeChild(_groundMap);
			_groundMap = null;
			
			_towerElements = null;
			_organismsElements = null;
			_groundEffElements = null;
			_summonDoors = null;
			//遍历时删除元素可能有问题，by gaojian
			var element:BasicSceneElement = null;
			for each(element in _allElementsMap)
			{
				element.dispose();
				delete _allElementsMap[element];
			}
			_allElementsMap = null;
		}
		
		override protected function onInitialize():void
		{
			_roadShape = new Shape();
			addChild(_roadShape);

			/*_endPointFlag = new EndPointFlag();
			_endPointFlag.mouseEnabled = false;
			_endPointFlag.mouseChildren = false;
			addChild(_endPointFlag);*/
			
			_endPointLayerIdx = this.numChildren;
			
			_roadTestShape = new Shape();
			addChild(_roadTestShape);
			
			_allBottomDepthRenderLayer = new Sprite();
			_allBottomDepthRenderLayer.mouseEnabled = false;
			addChild(_allBottomDepthRenderLayer);
			
			_allMiddleDepthRenderLayer = new Sprite();
			_allMiddleDepthRenderLayer.mouseEnabled = false;
			addChild(_allMiddleDepthRenderLayer);

			_allTopDepthRenderLayer = new Sprite();
			_allTopDepthRenderLayer.mouseEnabled = false;
			_allTopDepthRenderLayer.mouseChildren = false;
			addChild(_allTopDepthRenderLayer);
			
			GameAGlobalManager.getInstance().groundSceneHelper.initialize(_towerElements, _organismsElements,_groundEffElements,_summonDoors, _allMiddleDepthRenderLayer, _allDepthRenderElements);
		}
		
		//IRenderAble Interface
		public function update(iElapse:int):void
		{
			
		}
		
		public function render(iElapse:int):void
		{
			GameAGlobalManager.getInstance().groundSceneHelper.rendSceneDepthElements();
//			ObjectPoolManager.getInstance().printPoolInfo();
			
//			if(_allMiddleDepthRenderLayer.numChildren > 200 && 
//				Stats(root["stats"]).getFPS() < 29)
//			{
//				TickSynchronizer.getInstance().pauseTick();
//				trace(this._allMiddleDepthRenderLayer.numChildren, Stats(root["stats"]).getFPS());
//				return;
//			}
//			
//			var m:MockMoveElement = new MockMoveElement();
//			m.x = 100;
//			m.y = 300;
//			addSceneElemet(m);
		}
		
		private function updateBackgroundMap(backgroundMap:Sprite):void
		{
			if(_groundMap != null)
			{
				removeChild(_groundMap);
				_groundMap = null;
			}
			
			_groundMap = backgroundMap;
			
			if(_groundMap != null)
			{
				_groundMap.mouseChildren = false;
				_groundMap.mouseEnabled = false;
				addChildAt(_groundMap, getChildIndex(_roadShape) + 1);
				
				//test			
				//_groundMap.visible = false;
			}
		}
		
		private function updateMapRoadShape(data:MapConfigDataVO):void
		{
			_roadShape.graphics.clear();
			_roadShape.graphics.lineStyle(GameFightConstant.ROAD_WIDTH, 0x0);
			
			var i:uint = 0;
			var j:uint = 0; 
			var n:uint = 0;
			var m:uint = 0;
			
			var roadVO:RoadVO = null;
			var middleLineVO:LineVO = null; 
			var point:PointVO = null;

			n = data.roadVOs.length;
			for(i = 0; i< n; i++)
			{
				roadVO = data.roadVOs[i];
				middleLineVO = roadVO.lineVOs[1];

				_roadShape.graphics.moveTo(middleLineVO.points[0].x, middleLineVO.points[0].y);
				
				m = middleLineVO.points.length;
				for(j = 1; j < m; j++)
				{
					point = middleLineVO.points[j];
					_roadShape.graphics.lineTo(point.x, point.y);
				}
			}
			
			_roadShape.graphics.endFill();
		}
		
		//test
//		private function updateMapRoadTestShape(data:MapConfigDataVO):void
//		{
//			_roadTestShape.graphics.clear();
//			_roadTestShape.graphics.lineStyle(1, 0xFFFFFF);
//			var i:uint = 0;
//			var j:uint = 0; 
//			var k:uint = 0;
//			
//			var n:uint = 0;
//			var m:uint = 0;
//			var p:uint = 0;
//			
//			var roadVO:RoadVO = null;
//			var middleLineVO:LineVO = null; 
//			var point:PointVO = null;
//			
//			n = data.roadVOs.length;
//			for(i = 0; i< n; i++)
//			{
//				roadVO = data.roadVOs[i];
//				
//				m = roadVO.lineVOs.length;
//				for(j = 0; j < 1; j++)
//				{
//					middleLineVO = roadVO.lineVOs[j];	
//					_roadTestShape.graphics.moveTo(middleLineVO.points[0].x, middleLineVO.points[0].y);
//					
//					p = middleLineVO.points.length;
//					for(k = 1; k < p; k++)
//					{
//						point = middleLineVO.points[k];
//						var text:TextField = new TextField();
//						text.border = true;
//						text.mouseEnabled = false;
//						var tf:TextFormat = new TextFormat();
////						text.autoSize = TextFieldAutoSize.LEFT;
//						tf.size = 10;
//						tf.align = TextFormatAlign.LEFT;
//						tf.leftMargin = 0;
//						text.defaultTextFormat = tf;
//						text.width = 100;
//						text.height = 14;
//						addChild(text);
//						text.x = point.x;
//						text.y = point.y;
//						text.text = point.toString();
////						trace(point);
//						_roadTestShape.graphics.lineTo(point.x, point.y);
//						_roadTestShape.graphics.beginFill(0xFF0000, 0.2);
//						_roadTestShape.graphics.drawCircle(point.x, point.y, 4);
//						_roadTestShape.graphics.beginFill(0xFF0000, 0);
//						_roadTestShape.graphics.moveTo(point.x, point.y);
//					}
//				}
//			}
//			
////			_roadTestShape.graphics.endFill();
//		}

		public function initializeSceneElement(data:MapConfigDataVO):void
		{
			//配置
			var elementVOs:Vector.<SceneElementVO> = data.elemetVOs;
			for each(var elementVO:SceneElementVO in elementVOs)
			{
				var category:String = elementVO.category;
				if(category == GameObjectCategoryType.HERO) continue;//不允许配置文件里面添加英雄单位
				
				var sceneElement:BasicSceneElement = ObjectPoolManager.getInstance()
					.createSceneElementObject(category, elementVO.typeId, false) as BasicSceneElement; 

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
			var currentHeroIds:Array = UserData.getInstance().userExtendInfo.currentHeroIds;
			if(currentHeroIds == null || currentHeroIds.length == 0) return;
			
			var mapConfigDataVO:MapConfigDataVO = GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo;
			var endPointMarkPosition:PointVO = mapConfigDataVO.endPointMarkPosition;
			//这里终点是应该所有的路都合并了，所以取任意一条路都可以
			
			var roadLinePointPath:Vector.<PointVO> = mapConfigDataVO.roadVOs[0].lineVOs[1].points;
			
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
				heroElement1 = ObjectPoolManager.getInstance()
					.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[0], false) as HeroElement;
				heroElement1.x = endPointMarkPosition.x;
				heroElement1.y = endPointMarkPosition.y;
				heroElement1.notifyLifecycleActive();
				heroElement1.setAngle(directionRadian, true);
			}
			else if(n > 1)
			{
				var leftAndRightHeroStandPoints:Array =  GameMathUtil.caculateTwoEqualDistanceLRPointByCenterPointAndDirection(mapConfigDataVO.endPointMarkPosition,
					directionRadian, GameFightConstant.HERO_DEFAULT_STAND_CIRCLE_RADIUS);

				if(n == 2)
				{
					heroElement0 = ObjectPoolManager.getInstance()
						.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[0], false) as HeroElement;
					heroElement0.x = leftAndRightHeroStandPoints[0].x;
					heroElement0.y = leftAndRightHeroStandPoints[0].y;
					heroElement0.notifyLifecycleActive();
					heroElement0.setAngle(directionRadian, true);
					
					heroElement2 = ObjectPoolManager.getInstance()
						.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[1], false) as HeroElement;
					heroElement2.x = leftAndRightHeroStandPoints[1].x;
					heroElement2.y = leftAndRightHeroStandPoints[1].y;
					heroElement2.notifyLifecycleActive();
					heroElement2.setAngle(directionRadian, true);
				}
				else if(n == 3)
				{
					heroElement0 = ObjectPoolManager.getInstance()
						.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[0], false) as HeroElement;
					heroElement0.x = leftAndRightHeroStandPoints[0].x;
					heroElement0.y = leftAndRightHeroStandPoints[0].y;
					heroElement0.notifyLifecycleActive();
					heroElement0.setAngle(directionRadian, true);
					
					heroElement1 = ObjectPoolManager.getInstance()
						.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[1], false) as HeroElement;
					heroElement1.x = endPointMarkPosition.x;
					heroElement1.y = endPointMarkPosition.y;
					heroElement1.notifyLifecycleActive();
					heroElement1.setAngle(directionRadian, true);
					
					heroElement2 = ObjectPoolManager.getInstance()
						.createSceneElementObject(GameObjectCategoryType.HERO, currentHeroIds[2], false) as HeroElement;
					heroElement2.x = leftAndRightHeroStandPoints[1].x;
					heroElement2.y = leftAndRightHeroStandPoints[1].y;
					heroElement2.notifyLifecycleActive();
					heroElement2.setAngle(directionRadian, true);
				}
			}
		}
	}
}