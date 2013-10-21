package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseValidators.MouseCursorReleaseValidator;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.mouse.IMouseCursor;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.model.sceneElements.ISceneElementsModel;

	public class BasicMouseCursor extends BasicView implements IMouseCursor
	{
		[Inject]
		public var mouseCursorMgr:GameFightMouseCursorManager;
		[Inject]
		public var mouseCursorValidator:MouseCursorReleaseValidator;
		[Inject]
		public var loadService:ILoadAssetsServices;
		[Inject]
		public var objPoolMgr:ObjectPoolManager;
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		[Inject]
		public var sceneElementsModel:ISceneElementsModel
		
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
				
				mouseCursorMgr.deactiveTargetCurrentMouseCursor(this);
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
			return mouseCursorValidator.validByMouseCursor(mouseClickEvent, 
				myMouseCursorReleaseValidatorType);
		}

		protected function doWhenValidMouseClick(mouseCursorReleaseValidateResult:Object):void
		{
		}
		
		protected final function deactiveSelf():void
		{
			mouseCursorMgr.deactiveCurrentMouseCursor();
		}
	}
}