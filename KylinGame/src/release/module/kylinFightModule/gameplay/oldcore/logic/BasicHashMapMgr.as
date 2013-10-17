package release.module.kylinFightModule.gameplay.oldcore.logic
{
	import com.shinezone.core.datastructures.HashMap;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.BasicGameManager;

	
	public class BasicHashMapMgr extends BasicGameManager
	{
		protected var _hashMap:HashMap = new HashMap;
		
		public function BasicHashMapMgr()
		{
			super();
		}
		
		//IGameLifecycleNotifyer
		override public function onGameStart():void
		{
		}
		
		override public function onGameEnd():void
		{
			_hashMap.eachValue(disposeEachCondition);
			_hashMap.clear();
		}
		
		private function disposeEachCondition(e:IDisposeObject):void
		{
			e.dispose();
		}
		
		//IDisposeObject Interface
		override public function dispose():void
		{
			onGameEnd();
			_hashMap = null;
		}
	}
}