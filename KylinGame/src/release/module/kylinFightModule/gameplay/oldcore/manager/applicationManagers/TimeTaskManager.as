package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers
{
    import com.shinezone.towerDefense.fight.constants.GameFightConstant;
    import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
    
    import flash.events.TimerEvent;
    import flash.utils.Timer;
    import flash.utils.getTimer;
    
    import io.smash.time.TimeManager;

    public class TimeTaskManager implements IDisposeObject
    {
		private static const MAX_TIME_TASK_CACHE_COUNT:uint = 50;
		
		private static var _instance:TimeTaskManager;
		
		public static function getInstance():TimeTaskManager
		{
			return _instance ||= new TimeTaskManager();
		}
		
        //private var _timer:Timer = null;
		
        private var _timeTasksTimeHandleIdMap:Object = {};//id -> TimeTask
        private var _timeTasksPool:Array = [];

		private var _timeTaskHandleCount:int = 0;
		private var _isRunning:Boolean = false;

        public function TimeTaskManager()
        {
            super();
			
			//_timer = new Timer(GameFightConstant.TIME_UINT);
			//_timer.addEventListener(TimerEvent.TIMER, timerTimeHandler);
        }

		//IDisposeObject Interface
		public function dispose():void
		{
			//_timer.stop();
			//_timer.removeEventListener(TimerEvent.TIMER, timerTimeHandler);
			//_timer = null;
			clearTimeTasksTimeHandleIdMapAndPool();
			_timeTasksTimeHandleIdMap = null;
			_timeTasksPool = null;
			
			_instance = null;
		}

		//TimeTaskManager Interface
		//暂停
        /*public function pause():void
        {
			if(!_isRunning) return;
			_isRunning = false;
			//_timer.stop();
        }*/
        
        /*public function resume():void
        {
			if(_isRunning) return;
			_isRunning = true;
			//_timer.start();
        }*/
		
		//重置
		public function reset():void
		{
			//pause();
			clearTimeTasksTimeHandleIdMapAndPool();
			_timeTasksTimeHandleIdMap = {};
			_timeTaskHandleCount = 0;
		}
		
		private function clearTimeTasksTimeHandleIdMapAndPool():void
		{
			var timeTask:TimeTask = null;
			for each(timeTask in _timeTasksTimeHandleIdMap) timeTask.clear();
			for each(timeTask in _timeTasksPool) timeTask.clear();
		}
		
		/*public function start():void
		{
			if(_isRunning) return;
			_isRunning = true;
			//_timer.start();
		}*/
		
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
			
			timeTask.startTick = TimeManager.instance.virtualTime;
			TimeManager.instance.schedule(interval,null,onTimeTaskInterval,timeTask.timeTaskHandleId);
			
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
			timeTask.startTick = TimeManager.instance.virtualTime;
			TimeManager.instance.schedule(timeTask.interval,null,onTimeTaskInterval,timeTask.timeTaskHandleId);
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
			
			var rate:Number = (TimeManager.instance.virtualTime - timeTask.startTick)/timeTask.interval;
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
		
		//event handler
		/*private var tick:int = 0;
		private function timerTimeHandler(event:TimerEvent):void
		{	
			var timeTask:TimeTask = null;
			for each(timeTask in _timeTasksTimeHandleIdMap)
			{
				timeTask.currentCount++;
				
				if(timeTask.currentCount >= timeTask.totalCount)
				{
					timeTask.currentCount = 0;

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
							
							destoryTimeTask(timeTask.timeTaskHandleId);
							break;
						}
					}
					else
					{
						if(timeTask.callbackFunc != null)
						{
							timeTask.callbackFunc.apply(null, timeTask.callbackArgs);
						}
					}
				}
			}
		}*/
    }
}

class TimeTask
{
	public var timeTaskHandleId:int = 0;
    public var callbackFunc:Function = null;
    public var callbackArgs:Array = null;
	
	public var completeFunc:Function = null;
	public var completeArgs:Array = null;

    //public var currentCount:int = 0;//当前次数
	//public var totalCount:int = 0;
	
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
		//currentCount = 0;
		//totalCount = 0;
		currentRepeatCount = 0;
		totalRepeatCount = 0;
		completeFunc = null;
		completeArgs = null;
		interval = 0;
		beDestroy = false;
		startTick = 0;
	}
}