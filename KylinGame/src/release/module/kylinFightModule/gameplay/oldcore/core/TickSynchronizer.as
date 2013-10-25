package release.module.kylinFightModule.gameplay.oldcore.core
{
	import io.smash.time.IRenderAble;
	import io.smash.time.TimeManager;
	
	//游戏中所有基于帧的tick（包括动画、运动等）通知都是通过该类完成
	public final class TickSynchronizer
	{
		[Inject]
		public var timeMgr:TimeManager;
		
		public function TickSynchronizer()
		{
			super();
		}
		
		//附加到迭代器
		public function attachToTicker(value:IRenderAble):void
		{
			timeMgr.callLater(delayAttach,[value]);
		}
		
		private function delayAttach(value:IRenderAble):void
		{
			timeMgr.addAnimatedObject(value);
		}
		
		//从迭代器移除
		public function dettachFromTicker(value:IRenderAble):void
		{
			if(!timeMgr.removeAnimatedObject(value))
				timeMgr.callLater(delayDettach,[value]);	
		}
		
		private function delayDettach(value:IRenderAble):void
		{
			//timeMgr.removeTickedObject(value);
			timeMgr.removeAnimatedObject(value);
		}
	}
}
