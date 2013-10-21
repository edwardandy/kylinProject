package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.mouse
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;

	public class MouseCursorManager
	{
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		[Inject]
		public var stage:Stage;
		
		private var _currentMouseCursor:DisplayObject;
		private var _ptStage:Point = new Point;
		private var _hasInnerEventListen:Boolean;
		
		public function MouseCursorManager()
		{
			super();
		}
		
		public function setCurrentMouseCursor(mouseCursor:DisplayObject):void
		{
			clearCurrentMouseCursor();

			if(mouseCursor != null)
			{
				_currentMouseCursor = mouseCursor;
				
				if(_currentMouseCursor is MovieClip)
				{
					MovieClip(_currentMouseCursor).play();
				}
				
				_ptStage.x = stage.mouseX;
				_ptStage.y = stage.mouseY;
				const pt:Point = fightViewModel.mouseCursorLayer.globalToLocal(_ptStage);
				_currentMouseCursor.x = pt.x;
				_currentMouseCursor.y = pt.y;
				
				fightViewModel.mouseCursorLayer.addChild(_currentMouseCursor);
				add2RemoveMouseEventListener(true);	
			}
		}

		public function clearCurrentMouseCursor():void
		{
			if(_currentMouseCursor != null)
			{
				if(_currentMouseCursor is MovieClip)
				{
					MovieClip(_currentMouseCursor).stop();
				}
				fightViewModel.mouseCursorLayer.removeChild(_currentMouseCursor);
				_currentMouseCursor = null;
			}
			
			add2RemoveMouseEventListener(false);
		}
		
		private function add2RemoveMouseEventListener(isAddListener:Boolean):void
		{
			if(_hasInnerEventListen != isAddListener)
			{
				_hasInnerEventListen = isAddListener;
				
				if(_hasInnerEventListen)
				{
					if(_currentMouseCursor != null)
					{
						fightViewModel.groundLayer.addEventListener(MouseEvent.CLICK, stageMouseEventHandler, true, int.MAX_VALUE);
						fightViewModel.groundLayer.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseEventHandler, true, int.MAX_VALUE);
						
						fightViewModel.groundLayer.addEventListener(MouseEvent.MOUSE_DOWN, stageMouseEventHandler, true, int.MAX_VALUE);
						fightViewModel.groundLayer.addEventListener(MouseEvent.MOUSE_UP, stageMouseEventHandler, true, int.MAX_VALUE);
						
						fightViewModel.groundLayer.addEventListener(MouseEvent.ROLL_OVER, stageMouseEventHandler, true, int.MAX_VALUE);
						fightViewModel.groundLayer.addEventListener(MouseEvent.ROLL_OUT, stageMouseEventHandler, true, int.MAX_VALUE);
						
						fightViewModel.groundLayer.addEventListener(MouseEvent.MOUSE_OVER, stageMouseEventHandler, true, int.MAX_VALUE);
						fightViewModel.groundLayer.addEventListener(MouseEvent.MOUSE_OUT, stageMouseEventHandler, true, int.MAX_VALUE);
						
						fightViewModel.groundLayer.addEventListener(MouseEvent.MOUSE_WHEEL, stageMouseEventHandler, true, int.MAX_VALUE);
						fightViewModel.groundLayer.addEventListener(MouseEvent.DOUBLE_CLICK, stageMouseEventHandler, true, int.MAX_VALUE);
					}
				}
				else
				{
					if(_currentMouseCursor == null)
					{
						fightViewModel.groundLayer.removeEventListener(MouseEvent.CLICK, stageMouseEventHandler, true);
						fightViewModel.groundLayer.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseEventHandler, true);
						
						fightViewModel.groundLayer.removeEventListener(MouseEvent.MOUSE_DOWN, stageMouseEventHandler, true);
						fightViewModel.groundLayer.removeEventListener(MouseEvent.MOUSE_UP, stageMouseEventHandler, true);
						
						fightViewModel.groundLayer.removeEventListener(MouseEvent.ROLL_OVER, stageMouseEventHandler, true);
						fightViewModel.groundLayer.removeEventListener(MouseEvent.ROLL_OUT, stageMouseEventHandler, true);
						
						fightViewModel.groundLayer.removeEventListener(MouseEvent.MOUSE_OVER, stageMouseEventHandler, true);
						fightViewModel.groundLayer.removeEventListener(MouseEvent.MOUSE_OUT, stageMouseEventHandler, true);
						
						fightViewModel.groundLayer.removeEventListener(MouseEvent.MOUSE_WHEEL, stageMouseEventHandler, true);
						fightViewModel.groundLayer.removeEventListener(MouseEvent.DOUBLE_CLICK, stageMouseEventHandler, true);
					}
				}
			}
		}

		private function stageMouseEventHandler(event:MouseEvent):void
		{
			if(event.type == MouseEvent.MOUSE_MOVE)
			{
				_ptStage.x = event.stageX;
				_ptStage.y = event.stageY;
				const pt:Point = fightViewModel.mouseCursorLayer.globalToLocal(_ptStage);
				_currentMouseCursor.x = pt.x;
				_currentMouseCursor.y = pt.y;
			}
			else if(event.type == MouseEvent.CLICK)
			{
				if(_currentMouseCursor is IMouseCursor)
				{
					IMouseCursor(_currentMouseCursor).notifyMouseCursorClick(event);
				}
			}
			event.stopImmediatePropagation();
		}
	}
}