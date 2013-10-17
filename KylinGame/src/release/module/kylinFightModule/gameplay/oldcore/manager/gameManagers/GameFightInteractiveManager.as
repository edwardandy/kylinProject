package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import com.shinezone.towerDefense.fight.constants.TowerDefenseGameState;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.GroundScene;
	import release.module.kylinFightModule.gameplay.oldcore.display.TowerDefenseGame;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicBuildingElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.buildings.BasicTowerElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.soldiers.HeroElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.ShortCutKeyResponser.IShortCutKeyResponser;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameDataInfoEvent;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementEvent;
	import release.module.kylinFightModule.gameplay.oldcore.events.SceneElementFocusEvent;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.sampler.getInvocationCount;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import framecore.structure.model.constdata.GameConst;
	import framecore.structure.model.user.UserData;
	import framecore.structure.model.varMoudle.HttpVar;
	import framecore.structure.views.newguidPanel.NewbieGuideManager;
	
	import io.smash.time.TimeManager;

	public final class GameFightInteractiveManager extends BasicGameManager implements IEventDispatcher
	{
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
				dispatchEvent(sceneElementFocusEvent);
			}
		}
		
		//IDisposeObject Interface
		override public function dispose():void
		{
			add2RemoveSystemEventListener(false);
			setCurrentFocusdElement(null);
		}
		
		override public function onGameStart():void
		{
			add2RemoveSystemEventListener(true);
		}

		override public function onGamePause():void
		{
			add2RemoveSystemEventListener(false);
			
			setCurrentFocusdElement(null);
		}
		
		override public function onGameResume():void
		{
			add2RemoveSystemEventListener(true);
		}

		override public function onGameEnd():void
		{
			add2RemoveSystemEventListener(false);
			setCurrentFocusdElement(null);
		}
		
		private function add2RemoveSystemEventListener(isListen:Boolean):void
		{
			if(isListen)
			{
				GameAGlobalManager.getInstance().groundScene.addEventListener(MouseEvent.CLICK, groundSceneClickHandler,true);
				GameAGlobalManager.getInstance().groundScene.addEventListener(MouseEvent.CLICK, groundSceneClickHandler1);
				GameAGlobalManager.getInstance().stage.addEventListener(KeyboardEvent.KEY_UP, stageKeyUpHandler);
			}
			else
			{
				GameAGlobalManager.getInstance().groundScene.removeEventListener(MouseEvent.CLICK, groundSceneClickHandler,true);
				GameAGlobalManager.getInstance().groundScene.removeEventListener(MouseEvent.CLICK, groundSceneClickHandler1);
				GameAGlobalManager.getInstance().stage.removeEventListener(KeyboardEvent.KEY_UP, stageKeyUpHandler);
			}
		}
		
		private function groundSceneClickHandler1(event:MouseEvent):void
		{
			if(event.target != GameAGlobalManager.getInstance().groundScene)
				return;
			
			var sceneElement:ISceneFocusElement = event.target as ISceneFocusElement;	
			
			if(_currentFocusdSceneElement != null && _currentFocusdSceneElement is HeroElement)
			{
				if(!HeroElement(_currentFocusdSceneElement).isAlive)
				{
					setCurrentFocusdElement(null);
					return;
				}
				
				/*var targetPoint:PointVO = new PointVO(GameAGlobalManager.getInstance().groundScene.mouseX, 
					GameAGlobalManager.getInstance().groundScene.mouseY);
				
				if(!GameAGlobalManager.getInstance().groundScene.hisTestMapRoad(targetPoint.x, targetPoint.y))
				{
					setCurrentFocusdElement(null);
					return;
				}
				
				var path:Vector.<PointVO> = GameAGlobalManager
					.getInstance()
					.groundSceneHelper
					.findPath(targetPoint, new PointVO(HeroElement(_currentFocusdSceneElement).x, 
						HeroElement(_currentFocusdSceneElement).y));
				
				HeroElement(_currentFocusdSceneElement).moveToAppointPointByPath(path);
				
				setCurrentFocusdElement(null);*/
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
				
				/*var targetPoint:PointVO = new PointVO(GameAGlobalManager.getInstance().groundScene.mouseX, 
					GameAGlobalManager.getInstance().groundScene.mouseY);
				
				if(!GameAGlobalManager.getInstance().groundScene.hisTestMapRoad(targetPoint.x, targetPoint.y))
				{
					setCurrentFocusdElement(null);
					return;
				}

				var path:Vector.<PointVO> = GameAGlobalManager
					.getInstance()
					.groundSceneHelper
					.findPath(targetPoint, new PointVO(HeroElement(_currentFocusdSceneElement).x, 
						HeroElement(_currentFocusdSceneElement).y));

				HeroElement(_currentFocusdSceneElement).moveToAppointPointByPath(path);
				
				setCurrentFocusdElement(null);*/
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
			if(NewbieGuideManager.getInstance().isGuiding)
				return;
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
					GameAGlobalManager.getInstance().gameMouseCursorManager.deactiveCurrentMouseCursor();
				}
					break;
				case Keyboard.NUMPAD_ADD:
				{
					if( HttpVar.PHP_GATEWAY.indexOf("dev-fb-td.shinezoneapp.com") > 0 && TimeManager.instance.timeScale <3)
					{
						TimeManager.instance.stop();
						//GameConst.stage.frameRate += 30;
						TimeManager.instance.timeScale++;
						TimeManager.instance.start();
						trace("GameConst.stage.frameRate:" + GameConst.stage.frameRate + "timeScale: " + TimeManager.instance.timeScale);
					}
					
				}
					break;
				case Keyboard.NUMPAD_SUBTRACT:
				{
					if( HttpVar.PHP_GATEWAY.indexOf("dev-fb-td.shinezoneapp.com") > 0 )
					{
						TimeManager.instance.stop();
						/*GameConst.stage.frameRate -= 30;
						if(GameConst.stage.frameRate<30)
							GameConst.stage.frameRate = 30;*/
						if(TimeManager.instance.timeScale > 1)
							TimeManager.instance.timeScale--;
						
						TimeManager.instance.start();
						trace("GameConst.stage.frameRate:" + GameConst.stage.frameRate + "timeScale: " + TimeManager.instance.timeScale);
					}
				}
					break;
				default:
					break;
			}
		}
	}
}