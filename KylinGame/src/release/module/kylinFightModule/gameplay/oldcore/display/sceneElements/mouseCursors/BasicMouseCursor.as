package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseLogices.BasicMouseCursorReleaseLogic;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseValidators.MouseCursorReleaseValidator;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseValidators.MouseCursorReleaseValidatorType;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadLineVOHelperUtil;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import framecore.tools.mouse.IMouseCursor;

	public class BasicMouseCursor extends BasicView implements IMouseCursor
	{
		protected var myValideMouseCursorView:MovieClip;
		protected var myErrorMouseCursorView:MovieClip;
		
		protected var myCurrentValidMouseClickEvent:MouseEvent;
		protected var myMouseCursorReleaseValidatorType:int = -1;//MouseCursorReleaseValidatorType
		
		protected var myMouseCursorSponsor:IMouseCursorSponsor;
		
		private var _isPlayingErrorMode:Boolean = false;
		
		private var _myMouseCursorName:String;

		public function BasicMouseCursor()
		{
			super();
			
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		
		//API
		public final function setMouseCursorName(value:String):void
		{
			_myMouseCursorName = value;
		}
		
		public final function getMouseCursorName():String
		{
			return _myMouseCursorName;
		}
		
		public function setMouseCursorSponsor(value:IMouseCursorSponsor):void
		{
			myMouseCursorSponsor = value;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();

			if(myValideMouseCursorView != null)
			{
				addChild(myValideMouseCursorView);
			}
			
			if(myErrorMouseCursorView != null)
			{
				addChild(myErrorMouseCursorView);
				myErrorMouseCursorView.addFrameScript(myErrorMouseCursorView.totalFrames - 1, 
					myErrorMouseCursorViewAnimationEndHandler);
			}
		}
		
		private function myErrorMouseCursorViewAnimationEndHandler():void
		{
			changeToValideMouseCursorView();
		}
		
		private function changeToValideMouseCursorView():void
		{
			if(myErrorMouseCursorView != null)
			{
				myErrorMouseCursorView.visible = false;
				myErrorMouseCursorView.gotoAndStop(1);
			}
			
			if(myValideMouseCursorView != null)
			{
				_isPlayingErrorMode = false;
				myValideMouseCursorView.visible = true;
				myValideMouseCursorView.gotoAndPlay(1);
			}
		}
		
		private function changeToInValideMouseCursorView():void
		{
			if(myValideMouseCursorView != null)
			{
				myValideMouseCursorView.visible = false;
				myValideMouseCursorView.gotoAndStop(1);
			}

			if(myErrorMouseCursorView != null)
			{
				_isPlayingErrorMode = true;
				myErrorMouseCursorView.visible = true;
				myErrorMouseCursorView.gotoAndPlay(1);
			}
		}
		
		public function notifyIsActive(isActive:Boolean):void
		{
			if(isActive)
			{
				changeToValideMouseCursorView();
			}
			else
			{
				myMouseCursorSponsor.notifyTargetMouseCursorCanceled();
				myMouseCursorSponsor = null;
			}
		}

		//IDisposeObject Interface
		override public function dispose():void
		{
			super.dispose();

			if(myValideMouseCursorView != null)
			{
				removeChild(myValideMouseCursorView);
				myValideMouseCursorView = null;
			}

			if(myErrorMouseCursorView)
			{
				myErrorMouseCursorView.addFrameScript(myErrorMouseCursorView.totalFrames - 1, null);
				removeChild(myErrorMouseCursorView);
				myErrorMouseCursorView = null;
			}
			
			myCurrentValidMouseClickEvent = null;
		}
		
		//IMouseCursor Interface
		public function notifyMouseCursorClick(mouseClickEvent:MouseEvent):void
		{
			if(_isPlayingErrorMode) return;
			
			var mouseCursorReleaseValidateResult:Object = checkIsValidMouseClick(mouseClickEvent);
			if(mouseCursorReleaseValidateResult)
			{
				myCurrentValidMouseClickEvent = mouseClickEvent;
				
				doWhenValidMouseClick(mouseCursorReleaseValidateResult);
				
				if(myMouseCursorSponsor != null)
				{
					myMouseCursorSponsor.notifyTargetMouseCursorSuccessRealsed(myCurrentValidMouseClickEvent);
				}
				
				GameAGlobalManager.getInstance()
					.gameMouseCursorManager.deactiveTargetCurrentMouseCursor(this);
			}
			else
			{
				if(myErrorMouseCursorView == null)
				{
					changeToValideMouseCursorView();
				}
				else
				{
					changeToInValideMouseCursorView();
				}
			}
		}

		protected function checkIsValidMouseClick(mouseClickEvent:MouseEvent):Object
		{
			return MouseCursorReleaseValidator.getInstance().validByMouseCursor(mouseClickEvent, 
				myMouseCursorReleaseValidatorType);
		}

		protected function doWhenValidMouseClick(mouseCursorReleaseValidateResult:Object):void
		{
		}
		
		protected final function deactiveSelf():void
		{
			GameAGlobalManager.getInstance().gameMouseCursorManager.deactiveCurrentMouseCursor();
		}
	}
}