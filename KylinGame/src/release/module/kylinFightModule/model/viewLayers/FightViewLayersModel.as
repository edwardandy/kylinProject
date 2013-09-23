package release.module.kylinFightModule.model.viewLayers
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import kylin.echo.edward.framwork.model.KylinModel;
	
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;

	/**
	 * 战斗模块显示层次 
	 * @author Edward
	 * 
	 */	
	public class FightViewLayersModel extends KylinModel implements IFightViewLayersModel
	{
		private var _parent:DisplayObjectContainer;
		private var _groundLayer:Sprite;
		private var _bottomLayer:Sprite;
		private var _middleLayer:Sprite;
		private var _topLayer:Sprite;
		
		public function FightViewLayersModel()
		{
			super();
		}
		
		[Inject]
		public function set parent(value:DisplayObjectContainer):void
		{
			_parent = value;
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
			_bottomLayer = new Sprite;
			_middleLayer = new Sprite;
			_topLayer = new Sprite;
		}
		
		/**
		 * 初始化 
		 * 
		 */		
		public function initialize():void
		{
			_parent.addChild(_groundLayer);
			_parent.addChild(_bottomLayer);
			_parent.addChild(_middleLayer);
			_parent.addChild(_topLayer);
		}
		/**
		 * 销毁
		 * 
		 */		
		public function destroy():void
		{
		}
	}
}