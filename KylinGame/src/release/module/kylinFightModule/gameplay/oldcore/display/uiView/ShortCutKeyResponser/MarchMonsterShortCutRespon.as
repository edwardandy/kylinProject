package release.module.kylinFightModule.gameplay.oldcore.display.uiView.ShortCutKeyResponser
{
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMonsterMarchManager;

	public class MarchMonsterShortCutRespon extends ShortCutKeyResponser
	{
		[Inject]
		public var monsterMarchMgr:GameFightMonsterMarchManager;
		
		public function MarchMonsterShortCutRespon()
		{
			super();
		}
		
		override public function notifyShortCutKeyDown():void
		{
			monsterMarchMgr.marchNextWave();
		}
	}
}