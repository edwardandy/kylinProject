package release.module.kylinFightModule.gameplay.oldcore.logic
{
	import flash.utils.Dictionary;
	
	import kylin.echo.edward.utilities.datastructures.HashMap;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.BasicGameManager;

	
	public class BasicHashMapMgr extends BasicGameManager
	{
		protected var _hashMap:HashMap = new HashMap;
		private var _dicTemp:Dictionary = new Dictionary;
		
		public function BasicHashMapMgr()
		{
			super();
		}
		
		//IGameLifecycleNotifyer
		override public function onFightStart():void
		{
		}
		
		override public function onFightEnd():void
		{
			_hashMap.eachValue(disposeEachCondition);
			_dicTemp = new Dictionary;
			_hashMap.clear();
		}
		
		private function disposeEachCondition(e:IDisposeObject):void
		{
			if(_dicTemp[e])
				return;
			_dicTemp[e] = true;
			e.dispose();
		}
		
		//IDisposeObject Interface
		override public function dispose():void
		{
			_hashMap = null;
			_dicTemp = null;
		}
	}
}