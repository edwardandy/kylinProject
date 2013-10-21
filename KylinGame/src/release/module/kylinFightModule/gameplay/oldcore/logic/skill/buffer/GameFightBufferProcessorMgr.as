package release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.BasicHashMapMgr;
	
	import robotlegs.bender.framework.api.IInjector;
	
	public class GameFightBufferProcessorMgr extends BasicHashMapMgr
	{
		[Inject]
		public var injector:IInjector;
		
		public function GameFightBufferProcessorMgr()
		{
			super();
		}
		
		public function getBufferProcessorById(uid:uint):BasicBufferProcessor
		{
			var result:BasicBufferProcessor = _hashMap.get(uid) as BasicBufferProcessor;
			if(result)
			{
				return result;
			}
			
			result = createBufferProcessor(uid);
			if(result)
				_hashMap.put(uid,result);
			return result;
		}		
		
		private function createBufferProcessor(uid:uint):BasicBufferProcessor
		{
			var result:BasicBufferProcessor;
			switch(uid)
			{
				default:
					result = new BasicBufferProcessor(uid);
					break;
			}
			injector.injectInto(result);
			return result;
		}
	}
}