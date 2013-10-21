package release.module.kylinFightModule.model.viewLayers
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	
	import mainModule.extensions.viewLayers.ViewLayersMgr;
	
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;

	/**
	 * 战斗模块显示层次 
	 * @author Edward
	 * 
	 */	
	public class FightViewLayersModel extends KylinActor implements IFightViewLayersModel
	{
		[Inject]
		public var mainViewLayers:ViewLayersMgr;
		private var _mapLayer:Sprite;
		private var _groundLayer:Sprite;
		private var _roadHitTestShape:Shape;
		private var _bottomLayer:Sprite;
		private var _middleLayer:Sprite;
		private var _topLayer:Sprite;
		private var _mouseCursorLayer:Sprite;
		private var _UILayer:Sprite;
		
		public function FightViewLayersModel()
		{
			super();
		}
		
		public function get UILayer():Sprite
		{
			return _UILayer;
		}

		public function set UILayer(value:Sprite):void
		{
			_UILayer = value;
		}

		public function get mapLayer():Sprite
		{
			return _mapLayer;
		}

		public function set mapLayer(value:Sprite):void
		{
			_mapLayer = value;
		}

		public function get mouseCursorLayer():Sprite
		{
			return _mouseCursorLayer;
		}

		public function get roadHitTestShape():Shape
		{
			return _roadHitTestShape;
		}

		public function get topLayer():Sprite
		{
			return _topLayer;
		}

		public function get middleLayer():Sprite
		{
			return _middleLayer;
		}

		public function get bottomLayer():Sprite
		{
			return _bottomLayer;
		}

		public function get groundLayer():Sprite
		{
			return _groundLayer;
		}
		
		[PostConstruct]
		public function initialize():void
		{
			_mapLayer = new Sprite;
			_mapLayer.mouseEnabled = false;
			_mapLayer.mouseChildren = false;
			_groundLayer = new Sprite;
			_roadHitTestShape = new Shape;
			_bottomLayer = new Sprite;
			_bottomLayer.mouseEnabled = false;
			_middleLayer = new Sprite;
			_middleLayer.mouseEnabled = false;
			_topLayer = new Sprite;
			_topLayer.mouseEnabled = false;
			_mouseCursorLayer = new Sprite;
			_mouseCursorLayer.mouseEnabled = false;
			_mouseCursorLayer.mouseChildren = false;
			_UILayer = new Sprite;
			_UILayer.mouseEnabled = false;
			onInitialize();
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		private function onInitialize():void
		{
			mainViewLayers.fightScene.addChild(_mapLayer);
			_mapLayer.addChild(_roadHitTestShape);
			mainViewLayers.fightScene.addChild(_groundLayer);
			_groundLayer.addChild(_bottomLayer);
			_groundLayer.addChild(_middleLayer);
			_groundLayer.addChild(_topLayer);
			_groundLayer.addChild(_mouseCursorLayer);
			mainViewLayers.fightScene.addChild(_UILayer);
		}
		/**
		 * 销毁
		 * 
		 */		
		[PreDestroy]
		public function destroy():void
		{
			_mapLayer.removeChildren();
			_groundLayer.removeChildren();
			_bottomLayer.removeChildren();
			_middleLayer.removeChildren();
			_topLayer.removeChildren();
			_mouseCursorLayer.removeChildren();		
			mainViewLayers.fightScene.removeChildren();
			_UILayer.removeChildren();
			
			_mapLayer = null;
			_groundLayer = null;
			_bottomLayer = null;
			_middleLayer = null;
			_topLayer = null;
			_roadHitTestShape = null;
			_mouseCursorLayer = null;
			_UILayer = null;
		}
	}
}