package release.module.kylinFightModule.gameplay.oldcore.display.uiView
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import kylin.echo.edward.ui.McButton;
	import kylin.echo.edward.utilities.font.FontMgr;
	
	import release.module.kylinFightModule.controller.fightState.FightStateEvent;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	
	import utili.font.FontClsName;

	public class GamePauseView extends BasicView
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		[Inject]
		public var g_stage:Stage;
		
		private var bgMask:Sprite;
		private var _background:GamePauseBgView;
		private var _tick:uint;
		private var _pauseBtn:McButton;
		
		public function GamePauseView()
		{
			super();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			bgMask = new Sprite;
			addChild(bgMask);
			drawMask();
			
			_background = new GamePauseBgView();
			addChild(_background);
			_background.x = (GameFightConstant.SCENE_MAP_WIDTH - _background.width)>>1;
			_background.y =  (GameFightConstant.SCENE_MAP_HEIGHT - _background.height)>>1;
			
			_pauseBtn = new McButton();
			_pauseBtn.setSkin( _background.pauseBtn );
			FontMgr.instance.setTextStyle( _pauseBtn.getSkin()["label"], FontClsName.ButtonFont );
			
			FontMgr.instance.setTextStyle( _background["contentTF"], FontClsName.NormalFont );
			
			
		}
		
		private function drawMask():void
		{
			var pt:Point = new Point;
			pt = fightViewModel.UILayer.localToGlobal(pt);
			bgMask.graphics.beginFill(0x333333,0.2);
			bgMask.graphics.drawRect(-pt.x,-pt.y,stage.stageWidth,stage.stageHeight);
			bgMask.graphics.endFill();
		}
		
		override protected function onAddToStage():void
		{
			super.onAddToStage();
			this.addEventListener(MouseEvent.CLICK,gamePauseViewBtnClickHandler);
			//_pauseBtn.addActionEventListener( gamePauseViewBtnClickHandler);
		}
		
		override protected function onRemoveFromStage():void
		{
			this.removeEventListener(MouseEvent.CLICK,gamePauseViewBtnClickHandler);
			//_pauseBtn.removeActionEventListener();
			//dispose();
			//GameAGlobalManager.getInstance().game.removeEventListener(MouseEvent.CLICK, gamePauseViewBtnClickHandler);
		}
	
		override public function dispose():void
		{
			super.dispose();
			
			//_background.pauseBtn.removeEventListener(MouseEvent.CLICK, gamePauseViewBtnClickHandler);
			removeChildren();
			_background = null;
			bgMask = null;
		}
		
		//event handler
		private function gamePauseViewBtnClickHandler(e:MouseEvent = null):void
		{
			this.parent.removeChild(this);
			eventDispatcher.dispatchEvent(new FightStateEvent(FightStateEvent.FightResume));
		}
	}
}