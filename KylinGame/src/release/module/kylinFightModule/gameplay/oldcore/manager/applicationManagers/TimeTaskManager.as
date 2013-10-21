package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers
{
 
    import io.smash.time.TimeManager;
    
    import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
    import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.BasicGameManager;

    public class TimeTaskManager extends BasicGameManager
    {
		private static const MAX_TIME_TASK_CACHE_COUNT:uint = 50;
		
		[Inject]
		public var timeMgr:TimeManager;
        //private var _timer:Timer = null;
		
        private var _timeTasksTimeHandleIdMap:Object;//id -> TimeTask
        private var _timeTasksPool:Array;

		private var _timeTaskHandleCount:int;

        public function TimeTaskManager()
        {
            super();
			
			//_timer = new Timer(GameFightConstant.TIME_UINT);
			//_timer.addEventListener(TimerEvent.TIMER, timerTimeHandler);
        }
		
		override public function onFightStart():void
		{
			super.onFightStart();
			_timeTasksTimeHandleIdMap = {};
			_timeTasksPool = [];
			_timeTaskHandleCount = 0;
		}
		
		override public function onFightEnd():void
		{
			super.onFightEnd();
			clearTimeTasksTimeHandleIdMapAndPool();
		}
		//IDisposeObject Interface
		[PreDestroy]
		override public function dispose():void
		{
			//_timer.stop();
			//_timer.removeEventListener(TimerEvent.TIMER, timerTimeHandler);
			//_timer = null;	
			_timeTasksTimeHandleIdMap = null;
			_timeTasksPool = null;
		}
		
		private function clearTimeTasksTimeHandleIdMapAndPool():void
		{
			var timeTask:TimeTask = null;
			for each(timeTask in _timeTasksTimeHandleIdMap) 
				timeTask.clear();
			for each(timeTask in _timeTasksPool) 
				timeTask.clear();
		}
		
        public function createTimeTask(interval:uint/*单位毫秒, 一定是TIME_UINT 整数倍*/, 
									   callBackFunc:Function = null, 
									   callBackArgs:Array = null,
									   repeatCount:int = -1,
									   completeFunc:Function = null,
									   completeArgs:Array = null):int
        {
            var timeTask:TimeTask = _timeTasksPool.length > 0 ? 
				_timeTasksPool.pop() :
				new TimeTask();

			timeTask.interval = interval;
			//timeTask.currentCount = 0;
			//timeTask.totalCount = Math.ceil(interval / GameFightConstant.TIME_UINT);
			timeTask.currentRepeatCount = 0;
			timeTask.totalRepeatCount = repeatCount;
			timeTask.callbackFunc = callBackFunc;
			timeTask.callbackArgs = callBackArgs;
			
			if(repeatCount <= 0)
			{
				completeFunc = null;
				completeArgs = null;
			}
			
			timeTask.completeFunc = completeFunc;
			timeTask.completeArgs = completeArgs;
			
            if(_timeTaskHandleCount == int.MAX_VALUE) _timeTaskHandleCount = 1;
            else _timeTaskHandleCount++;

			_timeTasksTimeHandleIdMap[_timeTaskHandleCount] = timeTask;
			timeTask.timeTaskHandleId = _timeTaskHandleCount;
			
			timeTask.startTick = timeMgr.virtualTime;
			timeMgr.schedule(interval,null,onTimeTaskInterval,timeTask.timeTaskHandleId);
			
            return _timeTaskHandleCount;
        }
		
		private function onTimeTaskInterval(tid:uint):void
		{
			var timeTask:TimeTask = _timeTasksTimeHandleIdMap[tid];
			if(!timeTask)
				return;
			if(timeTask.beDestroy)
			{
				realDestoryTimeTask(tid);
				return;
			}
			
			if(timeTask.totalRepeatCount > 0)
			{
				timeTask.currentRepeatCount++;
				
				if(timeTask.callbackFunc != null)
				{
					timeTask.callbackFunc.apply(null, timeTask.callbackArgs);
				}
				
				if(timeTask.currentRepeatCount >= timeTask.totalRepeatCount)
				{
					if(timeTask.completeFunc != null)
					{
						timeTask.completeFunc.apply(null, timeTask.completeArgs);
					}
					
					realDestoryTimeTask(timeTask.timeTaskHandleId);
					return;
				}
			}
			else
			{
				if(timeTask.callbackFunc != null)
				{
					timeTask.callbackFunc.apply(null, timeTask.callbackArgs);
				}
			}
			timeTask.startTick = timeMgr.virtualTime;
			timeMgr.schedule(timeTask.interval,null,onTimeTaskInterval,timeTask.timeTaskHandleId);
		}
		
		public function destoryTimeTask(timeTaskHandleId:int):void
		{
			if(timeTaskHandleId <= 0) return;
			
			if(!_timeTasksTimeHandleIdMap[timeTaskHandleId]) return;
			
			var timeTask:TimeTask = getTaskTimeTaskByHandleId(timeTaskHandleId);
			if(timeTask)
				timeTask.beDestroy = true;
		}	
        
        private function realDestoryTimeTask(timeTaskHandleId:int):void
        {
			if(timeTaskHandleId <= 0) return;

            if(!_timeTasksTimeHandleIdMap[timeTaskHandleId]) return;
			
			var timeTask:TimeTask = getTaskTimeTaskByHandleId(timeTaskHandleId);
			
			delete _timeTasksTimeHandleIdMap[timeTaskHandleId];
			timeTask.clear();
			
			if(_timeTasksPool.length <  MAX_TIME_TASK_CACHE_COUNT)
			{
				_timeTasksPool.push(timeTask);
			}
        }
        
        public function getAllTimeTaskCount():uint
        {
            var count:uint = 0;
            for each(var o:Object in _timeTasksTimeHandleIdMap)
            {
                count++;
            }
            return count;
        }
		
		public function getTaskTimeTaskProgress(timeTaskHandleId:int):Number
		{
			var timeTask:TimeTask = getTaskTimeTaskByHandleId(timeTaskHandleId);
			if(timeTask == null) return 0;
			
			var rate:Number = (timeMgr.virtualTime - timeTask.startTick)/timeTask.interval;
			if(timeTask.totalRepeatCount <= 0) 
				return rate;
			
			return (timeTask.currentRepeatCount + rate) / timeTask.totalRepeatCount;
		}
		
		public function getTimeTaskCurrentRepeatCount(timeTaskHandleId:int):int
		{
			var timeTask:TimeTask = getTaskTimeTaskByHandleId(timeTaskHandleId);
			if(timeTask == null) return -1;
			
			return timeTask.currentRepeatCount;
		}

		private function getTaskTimeTaskByHandleId(timeTaskHandleId:int):TimeTask
		{
			if(timeTaskHandleId < 0) return null;
			return _timeTasksTimeHandleIdMap[timeTaskHandleId] as TimeTask;
		}
    }
}

class TimeTask
{
	public var timeTaskHandleId:int = 0;
    public var callbackFunc:Function = null;
    public var callbackArgs:Array = null;
	
	public var completeFunc:Function = null;
	public var completeArgs:Array = null;
	
	public var currentRepeatCount:int = 0;
	public var totalRepeatCount:int = 0;
	
	public var startTick:uint = 0;
	public var interval:uint = 0;
	public var beDestroy:Boolean = false;

    public function TimeTask()
    {
		super();
    }

	public function clear():void
	{
		timeTaskHandleId = 0;
		callbackFunc = null;
		callbackArgs = null;
		currentRepeatCount = 0;
		totalRepeatCount = 0;
		completeFunc = null;
		completeArgs = null;
		interval = 0;
		beDestroy = false;
		startTick = 0;
	}
}