package release.module.kylinFightModule.gameplay.oldcore.display.uiView
{
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import framecore.tools.button.McButton;
	import framecore.tools.font.FontUtil;

	public class GamePauseView extends BasicView
	{
		private var _background:GamePauseBgView;
		private var _tick:uint;
		public function GamePauseView()
		{
			super();
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_background = new GamePauseBgView();
			var pauseBtn:McButton = new McButton();
			pauseBtn.setSkin( _background.pauseBtn );
			FontUtil.useFont( pauseBtn.getSkin()["label"], FontUtil.FONT_TYPE_BUTTON );
			FontUtil.useFont( _background["contentTF"], FontUtil.FONT_TYPE_NORMAL );
			
			//pauseBtn.addActionEventListener( gamePauseViewBtnClickHandler);
			addChild(_background);
		}
		
		override protected function onAddToStage():void 
		{
			_tick = setTimeout(onListenClick,10);
			
		}
		
		override protected function onRemoveFromStage():void
		{
			GameAGlobalManager.getInstance().game.removeEventListener(MouseEvent.CLICK, gamePauseViewBtnClickHandler);
		}
		
		private function onListenClick():void
		{
			if(_tick>0)
			{
				clearTimeout(_tick);
				_tick = 0;
			}
			GameAGlobalManager.getInstance().game.addEventListener(MouseEvent.CLICK,gamePauseViewBtnClickHandler);
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			//_background.pauseBtn.removeEventListener(MouseEvent.CLICK, gamePauseViewBtnClickHandler);
			GameAGlobalManager.getInstance().game.removeEventListener(MouseEvent.CLICK, gamePauseViewBtnClickHandler);
			removeChild(_background);
			_background = null;
		}
		
		//event handler
		private function gamePauseViewBtnClickHandler(e:MouseEvent):void
		{
			GameAGlobalManager.getInstance().game.removeEventListener(MouseEvent.CLICK, gamePauseViewBtnClickHandler);
			GameAGlobalManager.getInstance().gamePopupManager.open2CloseGamePauseView(false);
			GameAGlobalManager.getInstance().game.resume();
		}
	}
}