package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.BasicMouseCursor;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.IMouseCursorSponsor;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.GameFightMainUIView;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightInteractiveManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMouseCursorManager;

	public class BasicIconView extends BasicView implements ISceneFocusElement, IMouseCursorSponsor
	{
		[Inject]
		public var interactiveMgr:GameFightInteractiveManager;
		[Inject]
		public var mouseMgr:GameFightMouseCursorManager;
		[Inject]
		public var filterMgr:GameFilterManager;
		[Inject]
		public var mainUI:GameFightMainUIView;
		
		protected var myIsInFocus:Boolean = false;
		protected var myIsDisable:Boolean = true;//默认
		
		protected var myFocusEnable:Boolean = true;
		protected var myFocusTipEnable:Boolean = false;
		
		protected var myDisableBackgroundBitmap:Bitmap;
		protected var myIconBitmapBackground:Bitmap;
		
		protected var myIconBitmap:Bitmap;
		protected var myIconIndex:int = -1;
		
		protected var myMouseCursor:BasicMouseCursor;
		
		private var _myMouseClickSprite:Sprite;
		
		//protected var _iconTip:IconTip = null;
		
		public function BasicIconView()
		{
			super();
			
			this.mouseEnabled = false;
		}
		
		//IMouseCursorSponsor Interface
		public function notifyTargetMouseCursorSuccessRealsed(mouseClickEvent:MouseEvent):void
		{
			interactiveMgr.disFocusTargetElement(this);
		}
		
		public function notifyTargetMouseCursorCanceled():void
		{
			
		}

		//API
		public function notifyOnGameStart():void
		{
			disable = true;
			//这里填充数据
		}
		
		public function notifyOnIconIsUseable():void
		{
			disable = false;
		}
		
		public function notifyOnGameEnd():void
		{
			setIconBitmapData(null);
			disable = true;
		}
		
		protected function setIconBitmapData(value:BitmapData):void
		{
			if(value == null)
			{
				if(myIconBitmap.bitmapData != null)
				{
					myIconBitmap.bitmapData.dispose();
					myIconBitmap.bitmapData = null;
				}
			}
			else
			{
				myIconBitmap.bitmapData = value;
				myIconBitmap.x = (myIconBitmapBackground.width - value.width) * 0.5;
				myIconBitmap.y = (myIconBitmapBackground.height - value.height) * 0.5;
			}
			
			stateChanged();
		}
		
		public function notifyIconUsed():void
		{
		}
		
		public final function setIconIndex(value:int):void
		{
			myIconIndex = value;
		}
		
		//ISceneFocusElement Interface
		public final function setIsOnFocus(isFocus:Boolean):void
		{
			if(myIsInFocus != isFocus)
			{
				myIsInFocus = isFocus;
				onFocusChanged();
			}
		}
		
		public final function get focusEnable():Boolean
		{
			return myFocusEnable;
		}
		
		public final function get focusTipEnable():Boolean
		{
			return myFocusTipEnable;
		}
		
		public function get focusTips():String
		{
			return null;
		}
		
		public function set disable(value:Boolean):void
		{
			if(myIsDisable != value)
			{
				myIsDisable = value;
				onDisableChanged();
			}
		}
		
		public final function get disable():Boolean
		{
			return myIsDisable;
		}
		
		protected function onFocusChanged():void
		{
			stateChanged();
			
			if(myIsInFocus)
			{
				if(needMouseCursor())
				{
					myMouseCursor = createMouseCursor();
				}
			}
			else
			{
				if(myMouseCursor != null)
				{
					mouseMgr.deactiveTargetCurrentMouseCursor(myMouseCursor);
					myMouseCursor = null;
				}
			}
		}
		
		protected function needMouseCursor():Boolean
		{
			return focusEnable;
		}
		
		protected function createMouseCursor():BasicMouseCursor
		{
			return null;
		}
		
		protected function onDisableChanged():void
		{
			stateChanged();
		}

		protected function stateChanged():void
		{
			myDisableBackgroundBitmap.visible = myIsDisable;
			myIconBitmap.visible = myIsDisable ? false : myIconBitmap.bitmapData != null;
			myIconBitmapBackground.visible = myIconBitmap.visible;
			this.mouseChildren = !myIsDisable;
			_myMouseClickSprite.buttonMode = !myIsDisable;
			this.filters = myIsInFocus ? [filterMgr.blueGlowFilter] : null;
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();

			myDisableBackgroundBitmap = new Bitmap();
			addChild(myDisableBackgroundBitmap);
			myDisableBackgroundBitmap.alpha = 0;
			
			myIconBitmapBackground = new Bitmap();
			addChild(myIconBitmapBackground);
			
			myIconBitmap = new Bitmap();
			addChild(myIconBitmap);
		}
		
		override protected function onInitializedComplete():void
		{
			_myMouseClickSprite = new Sprite();
			var r:Number = myIconBitmapBackground.width * 0.5;
			_myMouseClickSprite.graphics.clear();
			_myMouseClickSprite.graphics.beginFill(0xFF0000, 0);
			_myMouseClickSprite.graphics.drawCircle(r, r, r);
			_myMouseClickSprite.graphics.endFill();	
			addChild(_myMouseClickSprite);
			
			stateChanged();
		}
		
		override protected function onAddToStage():void
		{
			super.onAddToStage();
			
			_myMouseClickSprite.addEventListener(MouseEvent.CLICK, iconMouseClickHandler);

		}
		
		override protected function onRemoveFromStage():void
		{
			super.onRemoveFromStage();
			
			setIconBitmapData(null);
			
			myDisableBackgroundBitmap.bitmapData.dispose();
			myDisableBackgroundBitmap.bitmapData = null;
			myDisableBackgroundBitmap = null;
			
			myIconBitmapBackground.bitmapData.dispose();
			myIconBitmapBackground.bitmapData = null;
			myIconBitmapBackground = null;
			
			if(myMouseCursor != null)
			{
				mouseMgr.deactiveTargetCurrentMouseCursor(myMouseCursor);
				myMouseCursor = null;
			}
			
			_myMouseClickSprite.removeEventListener(MouseEvent.CLICK, iconMouseClickHandler);
			_myMouseClickSprite = null;

			interactiveMgr.disFocusTargetElement(this);
		}
		
		protected function onIconMouseClick():void
		{
			if(focusEnable)
			{
				interactiveMgr.setCurrentFocusdElement(this);
				//onMouseOutHandler( null );
			}
		}
		
		protected function getIsInValidIconMouseClick():Boolean
		{
			return myIsDisable || myIconBitmap.bitmapData == null || !mainUI.visible;
		}

		//event Handler
		private function iconMouseClickHandler(event:MouseEvent):void
		{
			if(getIsInValidIconMouseClick()) return;
			
			onIconMouseClick();
		}
	}
}