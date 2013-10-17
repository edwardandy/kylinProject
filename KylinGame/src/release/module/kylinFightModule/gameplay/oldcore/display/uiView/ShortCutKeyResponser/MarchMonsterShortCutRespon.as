package release.module.kylinFightModule.gameplay.oldcore.display.uiView.ShortCutKeyResponser
{
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;

	public class MarchMonsterShortCutRespon extends ShortCutKeyResponser
	{
		public function MarchMonsterShortCutRespon()
		{
			super();
		}
		
		override public function notifyShortCutKeyDown():void
		{
			GameAGlobalManager.getInstance().gameMonsterMarchManager.marchNextWave();
		}
	}
}