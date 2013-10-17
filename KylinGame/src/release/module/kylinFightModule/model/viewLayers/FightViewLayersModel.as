package release.module.kylinFightModule.model.viewLayers
{
	import flash.display.DisplayObjectContainer;
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
		//private var _parent:DisplayObjectContainer;
		[Inject]
		public var mainViewLayers:ViewLayersMgr;
		private var _groundLayer:Sprite;
		private var _roadHitTestShape:Shape;
		private var _bottomLayer:Sprite;
		private var _middleLayer:Sprite;
		private var _topLayer:Sprite;
		
		public function FightViewLayersModel()
		{
			super();
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
		public function postConstruct():void
		{
			_groundLayer = new Sprite;
			_groundLayer.mouseEnabled = false;
			_roadHitTestShape = new Shape;
			_bottomLayer = new Sprite;
			_bottomLayer.mouseEnabled = false;
			_middleLayer = new Sprite;
			_middleLayer.mouseEnabled = false;
			_topLayer = new Sprite;
			_topLayer.mouseEnabled = false;
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		public function initialize():void
		{
			mainViewLayers.fightScene.addChild(_groundLayer);
			mainViewLayers.fightScene.addChild(_roadHitTestShape);
			mainViewLayers.fightScene.addChild(_bottomLayer);
			mainViewLayers.fightScene.addChild(_middleLayer);
			mainViewLayers.fightScene.addChild(_topLayer);
		}
		/**
		 * 销毁
		 * 
		 */		
		[PreDestroy]
		public function destroy():void
		{
			_groundLayer.removeChildren();
			_bottomLayer.removeChildren();
			_middleLayer.removeChildren();
			_topLayer.removeChildren();
			
			mainViewLayers.fightScene.removeChild(_groundLayer);
			mainViewLayers.fightScene.removeChild(_roadHitTestShape);
			mainViewLayers.fightScene.removeChild(_bottomLayer);
			mainViewLayers.fightScene.removeChild(_middleLayer);
			mainViewLayers.fightScene.removeChild(_topLayer);
		}
	}
}