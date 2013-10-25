package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import io.smash.time.TimeManager;
	
	import kylin.echo.edward.utilities.datastructures.DictionaryUtil;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.ShortCutKeyResponser.IShortCutKeyResponser;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementFocusEvent;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;

	public final class GameFightInteractiveManager extends BasicGameManager
	{
		[Inject]
		public var fightViewData:IFightViewLayersModel;
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		[Inject]
		public var stage:Stage;
		[Inject]
		public var timeMgr:TimeManager;
		[Inject]
		public var gameMouseMgr:GameFightMouseCursorManager;
		
		private var _currentFocusdSceneElement:ISceneFocusElement;
		private var _dicShortCutKeyResponser:Dictionary = new Dictionary(true);

		public function GameFightInteractiveManager()
		{
			super();
		}
		
		public function get currentFocusdSceneElement():ISceneFocusElement
		{
			return _currentFocusdSceneElement;
		}
		
		//让对象失去焦点
		public function disFocusTargetElement(value:ISceneFocusElement):void
		{
			if(_currentFocusdSceneElement == value)
			{
				setCurrentFocusdElement(null);
			}
		}
		
		//设置目标对象为焦点对象
		public function setCurrentFocusdElement(value:ISceneFocusElement):void
		{
			if(value != null && !value.focusEnable) return;
			
			if(_currentFocusdSceneElement != value)
			{
				if(_currentFocusdSceneElement != null)
				{
					_currentFocusdSceneElement.setIsOnFocus(false);
					_currentFocusdSceneElement = null;
				}
				
				_currentFocusdSceneElement = value;
				
				if(_currentFocusdSceneElement != null)
				{
					_currentFocusdSceneElement.setIsOnFocus(true);
				}
				
				var sceneElementFocusEvent:SceneElementFocusEvent = new SceneElementFocusEvent(SceneElementFocusEvent.SCENE_ELEMENT_FOCUSED);
				sceneElementFocusEvent.focusedElement = _currentFocusdSceneElement;
				eventDispatcher.dispatchEvent(sceneElementFocusEvent);
			}
		}
		
		override public function onFightStart():void
		{
			add2RemoveSystemEventListener(true);
		}

		override public function onFightPause():void
		{
			add2RemoveSystemEventListener(false);	
			setCurrentFocusdElement(null);
		}
		
		override public function onFightResume():void
		{
			add2RemoveSystemEventListener(true);
		}

		override public function onFightEnd():void
		{
			add2RemoveSystemEventListener(false);
			setCurrentFocusdElement(null);
			
		}
		
		override public function dispose():void
		{
			super.dispose();
			for each(var key:* in DictionaryUtil.getKeys(_dicShortCutKeyResponser))
			{
				_dicShortCutKeyResponser[key] = null;
				delete _dicShortCutKeyResponser[key];
			}
			_dicShortCutKeyResponser = null;
		}
		
		private function add2RemoveSystemEventListener(isListen:Boolean):void
		{
			if(isListen)
			{
				fightViewData.groundLayer.addEventListener(MouseEvent.CLICK, groundSceneClickHandler,true);
				fightViewData.groundLayer.addEventListener(MouseEvent.CLICK, groundSceneClickHandler1);
				stage.addEventListener(KeyboardEvent.KEY_UP, stageKeyUpHandler);
			}
			else
			{
				fightViewData.groundLayer.removeEventListener(MouseEvent.CLICK, groundSceneClickHandler,true);
				fightViewData.groundLayer.removeEventListener(MouseEvent.CLICK, groundSceneClickHandler1);
				stage.removeEventListener(KeyboardEvent.KEY_UP, stageKeyUpHandler);
			}
		}
		
		private function groundSceneClickHandler1(event:MouseEvent):void
		{
			if(event.target != fightViewData.groundLayer)
				return;
						
			if(_currentFocusdSceneElement != null && _currentFocusdSceneElement is HeroElement)
			{
				if(!HeroElement(_currentFocusdSceneElement).isAlive)
				{
					setCurrentFocusdElement(null);
					return;
				}
			}
			else
				setCurrentFocusdElement(null);
			
		}

		//event Handlers
		private function groundSceneClickHandler(event:MouseEvent):void
		{
			var sceneElement:ISceneFocusElement = event.target as ISceneFocusElement;
			
			if(sceneElement && sceneElement != _currentFocusdSceneElement)
			{
				setCurrentFocusdElement(sceneElement);	
				return;
			}
			
			if(sceneElement == _currentFocusdSceneElement && _currentFocusdSceneElement is BasicTowerElement)
			{
				setCurrentFocusdElement(null);	
				return;
			}
			
			if(_currentFocusdSceneElement != null && _currentFocusdSceneElement is HeroElement)
			{
				if(sceneElement == _currentFocusdSceneElement ||
					!HeroElement(_currentFocusdSceneElement).isAlive)
				{
					setCurrentFocusdElement(null);
					return;
				}
			}	
		}	
		
		public function registerShortCutKeyResponser(keyCode:uint,responser:IShortCutKeyResponser):void
		{
			if(responser)
				_dicShortCutKeyResponser[keyCode] = responser;
		}
		
		//当按下ESCAPE，SPACE取消当前焦点对象
		private function stageKeyUpHandler(event:KeyboardEvent):void
		{
			var keyCode:uint = event.keyCode;
			if(_dicShortCutKeyResponser[keyCode] as IShortCutKeyResponser)
			{
				(_dicShortCutKeyResponser[keyCode] as IShortCutKeyResponser).notifyShortCutKeyDown();
				return;
			}
			
			switch(event.keyCode)
			{
				case Keyboard.ESCAPE:
				case Keyboard.SPACE:
				{
					setCurrentFocusdElement(null);
					gameMouseMgr.deactiveCurrentMouseCursor();
				}
					break;
				case Keyboard.NUMPAD_ADD:
				{
					if( /*HttpVar.PHP_GATEWAY.indexOf("dev-fb-td.shinezoneapp.com") > 0 &&*/ timeMgr.timeScale <3)
					{
						timeMgr.stop();
						//GameConst.stage.frameRate += 30;
						timeMgr.timeScale++;
						timeMgr.start();
						//trace("GameConst.stage.frameRate:" + GameConst.stage.frameRate + "timeScale: " + TimeManager.instance.timeScale);
					}
				}
					break;
				case Keyboard.NUMPAD_SUBTRACT:
				{
					//if( HttpVar.PHP_GATEWAY.indexOf("dev-fb-td.shinezoneapp.com") > 0 )
					{
						timeMgr.stop();
						if(timeMgr.timeScale > 1)
							timeMgr.timeScale--;
						
						timeMgr.start();
						//trace("GameConst.stage.frameRate:" + GameConst.stage.frameRate + "timeScale: " + TimeManager.instance.timeScale);
					}
				}
					break;
				default:
					break;
			}
		}
	}
}