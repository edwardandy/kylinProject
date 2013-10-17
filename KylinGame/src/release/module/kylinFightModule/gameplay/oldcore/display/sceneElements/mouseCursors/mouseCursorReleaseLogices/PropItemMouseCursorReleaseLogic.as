package release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.mouseCursors.mouseCursorReleaseLogices
{
	public final class PropItemMouseCursorReleaseLogic extends BasicMouseCursorReleaseLogic 
	{
		private static var _instance:PropItemMouseCursorReleaseLogic;
		
		public static function getInstance():PropItemMouseCursorReleaseLogic
		{
			return 	_instance ||= new PropItemMouseCursorReleaseLogic();
		}
		
		public function PropItemMouseCursorReleaseLogic()
		{
			super();
		}
	}
}