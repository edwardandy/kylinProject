package release.module.kylinFightModule.gameplay.oldcore.display.uiView
{
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import kylin.echo.edward.ui.McButton;
	import kylin.echo.edward.utilities.font.FontMgr;
	
	import release.module.kylinFightModule.controller.fightState.FightStateEvent;
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	
	import utili.font.FontClsName;

	public class GamePauseView extends BasicView
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
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
			
			_background = new GamePauseBgView();
			_pauseBtn = new McButton();
			_pauseBtn.setSkin( _background.pauseBtn );
			FontMgr.instance.setTextStyle( _pauseBtn.getSkin()["label"], FontClsName.ButtonFont );
			FontMgr.instance.setTextStyle( _background["contentTF"], FontClsName.NormalFont );
			
			_pauseBtn.addActionEventListener( gamePauseViewBtnClickHandler);
			addChild(_background);
		}
		
		override protected function onRemoveFromStage():void
		{
			_pauseBtn.removeActionEventListener();
			dispose();
			//GameAGlobalManager.getInstance().game.removeEventListener(MouseEvent.CLICK, gamePauseViewBtnClickHandler);
		}
	
		override public function dispose():void
		{
			super.dispose();
			
			//_background.pauseBtn.removeEventListener(MouseEvent.CLICK, gamePauseViewBtnClickHandler);
			removeChild(_background);
			_background = null;
		}
		
		//event handler
		private function gamePauseViewBtnClickHandler(e:MouseEvent):void
		{
			this.parent.removeChild(this);
			eventDispatcher.dispatchEvent(new FightStateEvent(FightStateEvent.FightResume));
		}
	}
}