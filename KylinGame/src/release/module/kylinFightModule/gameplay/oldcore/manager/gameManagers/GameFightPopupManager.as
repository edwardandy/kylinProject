package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.GamePauseView;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.PopupManager;

	public final class GameFightPopupManager extends BasicGameManager
	{
		private var _gamePauseView:GamePauseView;
//		private var _gameSettingView:DisplayObject;
		
		public function GameFightPopupManager()
		{
			super();
		}
		
		public function open2CloseGamePauseView(isOpen:Boolean):void
		{
			if(isOpen)
			{
				if(_gamePauseView == null)
				{
					_gamePauseView = new GamePauseView();	
					_gamePauseView.x = (GameFightConstant.SCENE_MAP_WIDTH>>1) - 192.5;
					_gamePauseView.y = (GameFightConstant.SCENE_MAP_HEIGHT>>1) - 68;
				}
				
				PopupManager.getInstacne().addPopup(_gamePauseView);
			}
			else
			{
				if(_gamePauseView != null)
				{
					PopupManager.getInstacne().removePopup(_gamePauseView);
				}
			}
		}
	}
}