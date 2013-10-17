package release.module.kylinFightModule.gameplay.oldcore.logic.skill.buffer
{
	import release.module.kylinFightModule.gameplay.oldcore.logic.BasicHashMapMgr;
	
	public class GameFightBufferProcessorMgr extends BasicHashMapMgr
	{
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
			return result;
		}
	}
}