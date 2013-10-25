package release.module.kylinFightModule.model.scene
{	
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetDataModel;
	import mainModule.model.gameData.sheetData.tollgate.ITollgateSheetItem;
	
	import release.module.kylinFightModule.gameplay.oldcore.events.GameDataInfoEvent;
	import release.module.kylinFightModule.gameplay.oldcore.vo.map.SceneElementVO;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;

	/**
	 * 战斗场景数据 
	 * @author Edward
	 * 
	 */	
	public class SceneDataModel extends KylinActor implements ISceneDataModel
	{
		[Inject]
		public var fightData:IFightDynamicDataModel;
		[Inject]
		public var tollgateSheet:ITollgateSheetDataModel;
	
		private var _sceneGoods:int = 0;
		private var _sceneLife:int = 0;
		private var _sceneTotalLife:int = 0;
		private var _sceneType:int = -1;
		private var _vecSceneInitElements:Vector.<SceneElementVO> = new Vector.<SceneElementVO>;
		
		public function SceneDataModel()
		{
			super();
		}
		
		public function get sceneInitElementsVo():Vector.<SceneElementVO>
		{
			return _vecSceneInitElements;
		}
		
		public function get sceneType():int
		{
			return _sceneType;
		}

		public function get sceneTotalLife():int
		{
			return _sceneTotalLife;
		}

		public function get sceneLife():int
		{
			return _sceneLife;
		}

		public function set sceneLife(value:int):void
		{
			_sceneLife = value;
		}

		public function get sceneGoods():int
		{
			return _sceneGoods;
		}

		public function set sceneGoods(value:int):void
		{
			_sceneGoods = value;
		}

		public function initialize():void
		{
			var tollgateItem:ITollgateSheetItem = tollgateSheet.getTollgateSheetById(fightData.tollgateId);
			_sceneGoods = fightData.initGoods>0 ? fightData.initGoods : tollgateItem.goods;
			_sceneLife = tollgateItem.life;
			_sceneTotalLife = _sceneLife;
			_sceneType = tollgateItem.sceneType;
		}
		
		public function updateSceneElements(data:XML):void
		{
			var elementXMLs:XMLList = data.elements.Element;
			var sceneElementVO:SceneElementVO = null;
			for each(var elementXML:XML in elementXMLs)
			{
				sceneElementVO = new SceneElementVO();
				sceneElementVO.x = elementXML.@x;
				sceneElementVO.y = elementXML.@y;
				sceneElementVO.category = elementXML.@category;
				sceneElementVO.typeId = elementXML.@typeId;
				sceneElementVO.xmlData = elementXML;
				_vecSceneInitElements.push(sceneElementVO);
			}
		}
		
		/**
		 * 更新场景生命
		 * @param value
		 * 
		 */		
		public function updateSceneLife(value:int):void
		{
			_sceneLife += value;
			
			if(_sceneLife < 0)
				_sceneLife = 0;
			
			var event:GameDataInfoEvent = new GameDataInfoEvent(GameDataInfoEvent.UPDATE_SCENE_LIFE);
			dispatch(event);
		}
		
		/**
		 * 更新场景物资
		 * @param value
		 * 
		 */		
		public function updateSceneGold(value:int):void
		{
			_sceneGoods += value;
			
			if(_sceneGoods < 0)
				_sceneGoods = 0;
			
			var event:GameDataInfoEvent = new GameDataInfoEvent(GameDataInfoEvent.UPDATE_SCENE_GOLD);
			dispatch(event);
		}
		/**
		 * 更新场景积分 
		 * 
		 */		
		public function updateSceneScore():void
		{
			var event:GameDataInfoEvent = new GameDataInfoEvent(GameDataInfoEvent.UPDATE_SCENE_SCORE);
			dispatch(event);
		}
		
		public function destroy():void
		{
			fightData = null;
			tollgateSheet = null;
		}
		
		/**
		 * @inheritDoc 
		 */		
		public function onFightStart():void
		{
			initialize();
		}
		/**
		 * 战斗结束 
		 * 
		 */		
		public function onFightEnd():void
		{
			
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
			destroy();
		}
	}
}