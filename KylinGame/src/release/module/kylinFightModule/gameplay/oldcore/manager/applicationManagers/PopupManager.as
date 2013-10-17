package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.utils.Dictionary;

	public class PopupManager
	{
		private static var _instance:PopupManager;
		
		public static function getInstacne():PopupManager
		{
			return _instance ||= new PopupManager();
		}

		private var _popupLayer:Sprite;
		private var _gameTopLayerModalShape:Sprite;
		
		private var _childs:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		public function PopupManager()
		{
			super();
		}
		
		public function initialize(...parameters:Array):void
		{
			_popupLayer = parameters[0];
			_gameTopLayerModalShape = parameters[1];
		}
		
		public function addPopup(view:DisplayObject):void
		{
			if(!hasPopup(view))
			{
				_childs.push(view);
				_popupLayer.addChild(view);
				
				if(_childs.length == 1)
				{
					drawModalShape();
				}
			}
		}
		
		public function moveUp(view:DisplayObject):void
		{
			if(hasPopup(view))
			{
				if(_popupLayer.getChildIndex(view) < _popupLayer.numChildren - 1)
				{
					_popupLayer.setChildIndex(view, _popupLayer.getChildIndex(view) + 1);	
				}
			}
		}
		
		public function removePopup(view:DisplayObject):void
		{
			if(hasPopup(view))
			{
				_popupLayer.removeChild(view);
				_childs.splice(_childs.indexOf(view), 1);
				
				if(_childs.length == 0)
				{
					drawModalShape();
				}
			}
		}
		
		public function hasPopup(view:DisplayObject):Boolean
		{
			return _childs.indexOf(view) != -1;
		}
		
		private function drawModalShape():void
		{
			_gameTopLayerModalShape.graphics.clear();
			if(_childs.length > 0)
			{
				_gameTopLayerModalShape.graphics.beginFill(0x000000, 0.4);
				_gameTopLayerModalShape.graphics.drawRect(0, 0, GameFightConstant.SCENE_MAP_WIDTH, GameFightConstant.SCENE_MAP_HEIGHT);
			}
			_gameTopLayerModalShape.graphics.endFill();
		}
	}
}