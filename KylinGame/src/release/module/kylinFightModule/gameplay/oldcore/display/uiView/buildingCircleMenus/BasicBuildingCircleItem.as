package release.module.kylinFightModule.gameplay.oldcore.display.uiView.buildingCircleMenus
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import kylin.echo.edward.utilities.font.FontMgr;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GameFilterManager;
	
	import utili.font.FontClsName;

	public class BasicBuildingCircleItem extends BasicView
	{
		[Inject]
		public var filterMgr:GameFilterManager;
		
		protected var myItemBGView:MovieClip;
		
		protected var myIsLock:Boolean = false;
		protected var myIsEnable:Boolean = true;
		protected var myIsMouseOverFlag:Boolean = false;
		
		protected var myClickCallback:Function;
		protected var myBuildingCircleItemOwner:BasicBuildingCircleMenu;
		
		public function BasicBuildingCircleItem(clickCallback:Function,buildingCircleMenu:BasicBuildingCircleMenu)
		{
			super();

			this.mouseChildren = false;
			this.buttonMode = true;
			
			myBuildingCircleItemOwner = buildingCircleMenu;
			myClickCallback = clickCallback;
			
			//ToolTipManager.getInstance().registGameToolTipTarget( this, ToolTipConst.TOWER_MENU_TOOL_TIP );
			//this.addEventListener( ToolTipEvent.GAME_TOOL_TIP_SHOW, onShowToolTipHandler );
		}
		
		/*protected function onShowToolTipHandler( event:ToolTipEvent ):void
		{
			if ( myIsLock )
			{
				var data:TowerMenuToolTipDataVO = new TowerMenuToolTipDataVO();
				data.status = TowerMenuToolTip.STATUS_LOCKED;
				event.toolTip.data = data;
			}
			else
			{
				event.preventDefault();
			}
		}*/
		
		override protected function onInitialize():void
		{
			myItemBGView = new BuildingCircleBuildItemSkin();
			
			FontMgr.instance.setTextStyle(myItemBGView.itemTextSkin.goldTextField,FontClsName.ButtonFont);
			myItemBGView.stop();
			addChild(myItemBGView);

			this.addEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
			this.addEventListener(MouseEvent.CLICK, mouseClickHandler);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			myClickCallback = null;
			myBuildingCircleItemOwner = null;
			
			this.removeEventListener(MouseEvent.ROLL_OVER, mouseRollOverHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT, mouseRollOutHandler);
			this.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
			this.filters = null;
		}
		
		public function Show():void
		{
			onShow();
		}
		
		protected function onShow():void
		{
			
		}
			
		
		public function setIsLock(value:Boolean):void
		{
			//if(myIsLock != value)
			{
				myIsLock = value;
				
				this.buttonMode = myIsEnable && !myIsLock;
				updateUIByCurrentState();
			}
		}
		
		public function setIsEnable(value:Boolean):void
		{
			//if(myIsEnable != value)
			{
				myIsEnable = value;
				
				this.buttonMode = myIsEnable && !myIsLock;
				updateUIByCurrentState();
			}
		}

		//event Handlers
		private function mouseClickHandler(event:MouseEvent):void
		{
			if(myIsEnable && !myIsLock)
			{
				if(myClickCallback != null)
				{
					myBuildingCircleItemOwner.notifyCircleOnItemPreClick(this);
					excuteClickCallback();
				}
			}
		}

		protected function excuteClickCallback():void
		{
			myClickCallback();
		}
		
		override protected function onRemoveFromStage():void
		{
			super.onRemoveFromStage();
			
			this.filters = null;
			myIsMouseOverFlag = false;
		}
		
		private function mouseRollOverHandler(event:MouseEvent):void
		{
			myIsMouseOverFlag = true;
			updateUIByCurrentState();
		}
		
		private function mouseRollOutHandler(event:MouseEvent):void
		{
			myIsMouseOverFlag = false;
			updateUIByCurrentState();
		}
		
		protected function updateUIByCurrentState():void
		{
			if(myIsEnable && !myIsLock)
			{
				if(myIsMouseOverFlag)
				{
					this.filters = [filterMgr.yellowGlowFilter];
					onMouseOverCallback(true);
				}
				else
				{
					this.filters = null;
					onMouseOverCallback(false);
				}
			}
			else
			{
				this.filters = [filterMgr.colorNessMatrixFilter];
			}
		}
		
		protected function onMouseOverCallback(bOver:Boolean):void
		{
			
		}
		
		public function isClickToDisfocusBuilding():Boolean
		{
			return true;
		}
	}
}