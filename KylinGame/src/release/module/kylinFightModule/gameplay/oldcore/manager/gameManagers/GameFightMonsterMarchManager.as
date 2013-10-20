package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{	
	import flash.events.IEventDispatcher;
	
	import mainModule.model.gameData.sheetData.monster.IMonsterSheetDataModel;
	
	import release.module.kylinFightModule.gameplay.constant.BattleEffectType;
	import release.module.kylinFightModule.gameplay.constant.GameFightConstant;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameMarchMonsterEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.vo.NewMonsterList;
	import release.module.kylinFightModule.model.interfaces.IMapRoadModel;
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
	import release.module.kylinFightModule.model.marchWave.MonsterSubWaveVO;
	import release.module.kylinFightModule.model.marchWave.MonsterWaveVO;
	import release.module.kylinFightModule.model.state.FightState;
	import release.module.kylinFightModule.utili.structure.PointVO;
	
	public final class GameFightMonsterMarchManager extends BasicGameManager
	{
		[Inject]
		public var monsterWaveModel:IMonsterWaveModel;
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		[Inject]
		public var monsterModel:IMonsterSheetDataModel;
		[Inject]
		public var mapRoadModel:IMapRoadModel;
		[Inject]
		public var fightState:FightState;
		[Inject]
		public var newMonsters:NewMonsterList;
		[Inject]
		public var timeTaskMgr:TimeTaskManager;
		[Inject]
		public var objPoolMgr:ObjectPoolManager;
		
		private static const MAX_MONSTER_MARCH_SUB_WAVE_TIME_TASK_INFO_CACHE_COUNT:uint = 50;
		private static const MARCHING:int = 1;
		private static const WAITTING:int = 0;
		private static const CURWAVECOMPLETE:int = 2;
				
		private var _timeHandlerId:int = -1;
		private var _marchBehaviorState:int = WAITTING;
		
		private var _currentMonsterMarchWaveVO:MonsterWaveVO;
		private var _currentMonsterMarchSubWaveTimeTaskInfoMap:Array;//[index->value]
		
		private var _monsterMarchSubWaveTimeTaskInfoPool:Array;//MonsterMarchSubWaveTimeTaskInfo
		
		public function GameFightMonsterMarchManager()
		{
			super();
		}
		
		override public function onFightStart():void
		{
			_monsterMarchSubWaveTimeTaskInfoPool = [];
			_currentMonsterMarchSubWaveTimeTaskInfoMap = [];
			_currentMonsterMarchWaveVO = null;
			_marchBehaviorState = WAITTING;

			eventDispatcher.dispatchEvent(new GameMarchMonsterEvent(GameMarchMonsterEvent.WAIT_AND_READ_TO_MARCH_NEXT_WAVE));
		}
		
		override public function onFightEnd():void
		{
			if(_timeHandlerId>0)
				timeTaskMgr.destoryTimeTask(_timeHandlerId);
			_timeHandlerId = -1;
		}
		[PreDestroy]
		override public function dispose():void
		{
			super.dispose();
			_monsterMarchSubWaveTimeTaskInfoPool = [];
			_currentMonsterMarchSubWaveTimeTaskInfoMap = [];
			_currentMonsterMarchWaveVO = null;
			_marchBehaviorState = WAITTING;
		}
		
		//GameMonsterMarchManager API
//		public function startMarchMonster():void
//		{
//			marchNextWave();
//		}
		
		public function marchNextWave(bForce:Boolean = false):void
		{
			if(bForce || _marchBehaviorState == WAITTING)
			{
				//计算提前时间
				var marchNextWavePreactTime:uint = EndlessBattleMgr.instance.isEndless?0:(1 - getWaitNextWaveProgress()) * GameFightConstant.MONSTER_WAVE_DURATION;
				
				preProcessMarchMonster();
				
				_marchBehaviorState = MARCHING;

				if(_timeHandlerId != -1)
				{
					var timeProgress:Number = timeTaskMgr.getTaskTimeTaskProgress(_timeHandlerId);
					var leftTime:int = int(timeProgress * GameFightConstant.MONSTER_WAVE_DURATION);
					
					timeTaskMgr.destoryTimeTask(_timeHandlerId);
				}
				
				_currentMonsterMarchWaveVO = monsterWaveModel.getMonsterWave(monsterWaveModel.curWaveCount);
				
				var subWaveVOs:Vector.<MonsterSubWaveVO> = _currentMonsterMarchWaveVO.vecSubWaves;
				var subWaveCount:uint = subWaveVOs.length;
				_currentMonsterMarchSubWaveTimeTaskInfoMap = [];
				var subWaveTimeTaskInfo:MonsterMarchSubWaveTimeTaskInfo = null;
				var subWaveVO:MonsterSubWaveVO = null;
				for(var i:int = 0; i < subWaveCount; i++)
				{
					subWaveVO = subWaveVOs[i];

					subWaveTimeTaskInfo = _monsterMarchSubWaveTimeTaskInfoPool.length > 0 ?
						_monsterMarchSubWaveTimeTaskInfoPool.pop() : 
						new MonsterMarchSubWaveTimeTaskInfo();
					
					_currentMonsterMarchSubWaveTimeTaskInfoMap[i] = subWaveTimeTaskInfo;
					subWaveTimeTaskInfo.timeTaskInfoHandleId = i;
					subWaveTimeTaskInfo.startUintTimeIndex = subWaveVO.startTime / GameFightConstant.TIME_UINT;
					subWaveTimeTaskInfo.currentMarchMonsterTimes = 0;
					subWaveTimeTaskInfo.totalMarchMonsterTimes = subWaveVO.times;
					subWaveTimeTaskInfo.intervalUintTimeCount = subWaveVO.interval / GameFightConstant.TIME_UINT;
					subWaveTimeTaskInfo.monsterCountPerTime = subWaveVO.monsterCount / subWaveVO.times;
					
					subWaveTimeTaskInfo.monsterCount = subWaveVO.monsterCount;
					subWaveTimeTaskInfo.monsterMoreUnOutCount = subWaveVO.monsterCount % subWaveVO.times;

					subWaveTimeTaskInfo.monsterTypeId = subWaveVO.monsterTypeId;
					subWaveTimeTaskInfo.roadIndex = subWaveVO.roadIndex;
					subWaveTimeTaskInfo.bRandomLine = subWaveVO.bRandomLine;
					
				}

				var event:GameMarchMonsterEvent = new GameMarchMonsterEvent(GameMarchMonsterEvent.MARCH_NEXT_WAVE);
				event.nextWavepreactTime = marchNextWavePreactTime;
				eventDispatcher.dispatchEvent(new GameMarchMonsterEvent(GameMarchMonsterEvent.MARCH_NEXT_WAVE));
								
				//do it
				_timeHandlerId = timeTaskMgr.createTimeTask(GameFightConstant.TIME_UINT, 
						marchMonsterWaveTimerTickHandler, null, 
						_currentMonsterMarchWaveVO.duration / GameFightConstant.TIME_UINT, 
						marchNextWaveCompleteHandler);
			}
		}
		
		private function preProcessMarchMonster():void
		{
			if(!EndlessBattleMgr.instance.isEndless)
			{
				var marchNextWavePreactTime:uint = (1 - getWaitNextWaveProgress()) * GameFightConstant.MONSTER_WAVE_DURATION;
				GameAGlobalManager.getInstance().gameDataInfoManager.marchMonsterEarler(marchNextWavePreactTime);
				GameAGlobalManager.getInstance()
					.game.gameFightMainUIView.fightControllBarView
					.reduceMagicSkillCDTime(0, marchNextWavePreactTime, 0,true);
			}
			
			var curWave:int =  monsterWaveModel.curWaveCount;
			const totalWave:int = monsterWaveModel.totalWaveCount;
			//战斗开始
			if(0 == curWave
			||(EndlessBattleMgr.instance.isEndless && EndlessBattleMgr.instance.recordWave == curWave))
			{
				fightState.state = FightState.StartFight;
				if(EndlessBattleMgr.instance.isEndless)
					GameAGlobalManager.getInstance().game.playBattleEffect( BattleEffectType.ENDLESS_WAVE_NUM_EFFECT, [curWave+1]);
			}
			//最后一波
			else if(curWave == totalWave - 1)
			{
				GameAGlobalManager.getInstance().game.playBattleEffect( BattleEffectType.FINAL_WAVE_EFFECT );
			}
			//无极幻境每波都提示
			else
			{
				if(EndlessBattleMgr.instance.isEndless)
					GameAGlobalManager.getInstance().game.playBattleEffect( BattleEffectType.ENDLESS_WAVE_NUM_EFFECT, [curWave+1]);
			}
			
			monsterWaveModel.increaseSceneWave();
			curWave =  monsterWaveModel.curWaveCount;
			if(EndlessBattleMgr.instance.isEndless)
			{
				EndlessBattleMgr.instance.checkRetrieveBuffEnd();
				EndlessBattleMgr.instance.setCurWaveMonsterCnts(curWave,monsterWaveModel.getMonsterWave(curWave).totalMonsters);
			}
		}
		
		public function getWaitNextWaveProgress():Number
		{
			if(_marchBehaviorState == WAITTING)
			{
				if(_timeHandlerId > 0)
				{
					return Math.min(Math.max(timeTaskMgr.getTaskTimeTaskProgress(_timeHandlerId),0),1);
				}
			}

			return 1;
		}
		
		public function isNotMarching():Boolean
		{
			return MARCHING != _marchBehaviorState;
		}
		
		private function marchNextWaveCompleteHandler():void
		{
			_timeHandlerId = -1;
			
			if(monsterWaveModel.curWaveCount >= monsterWaveModel.totalWaveCount)
			{
				monsterWaveModel.isCompleteWave = true;
				return;
			}
			
			_marchBehaviorState = CURWAVECOMPLETE;
			
			if(!(EndlessBattleMgr.instance.isEndless && EndlessBattleMgr.instance.isSavePointWave(monsterWaveModel.curWaveCount)))
				waitNextWave();
		}
		
		private function waitNextWave():void
		{
			_timeHandlerId = timeTaskMgr.createTimeTask(GameFightConstant.TIME_UINT, 
					marchMonsterWaveTimerTickHandler, null, 
					GameFightConstant.MONSTER_WAVE_DURATION / GameFightConstant.TIME_UINT, waitNextWaveCompleteHandler);
			
			_marchBehaviorState = WAITTING;
			if(!EndlessBattleMgr.instance.isEndless)
				eventDispatcher.dispatchEvent(new GameMarchMonsterEvent(GameMarchMonsterEvent.WAIT_AND_READ_TO_MARCH_NEXT_WAVE));
		}
		
		private function waitNextWaveCompleteHandler():void
		{
			_timeHandlerId = -1;
			marchNextWave();
		}

		//event handler
		private function marchMonsterWaveTimerTickHandler():void
		{
			var timeUintIndex:int = timeTaskMgr.getTimeTaskCurrentRepeatCount(_timeHandlerId);
			
			for each(var subWaveTimeTaskInfo:MonsterMarchSubWaveTimeTaskInfo in _currentMonsterMarchSubWaveTimeTaskInfoMap)
			{
				if(subWaveTimeTaskInfo.startUintTimeIndex == timeUintIndex)
				{
					subWaveTimeTaskInfo.isStartCountting = true;
				}
				
				if(subWaveTimeTaskInfo.isStartCountting)
				{
					var subWaveTimeUintIndex:int = timeUintIndex - subWaveTimeTaskInfo.startUintTimeIndex;

					if(subWaveTimeUintIndex % subWaveTimeTaskInfo.intervalUintTimeCount == 0)
					{
						subWaveTimeTaskInfo.currentMarchMonsterTimes++;
						
						if(subWaveTimeTaskInfo.currentMarchMonsterTimes > subWaveTimeTaskInfo.totalMarchMonsterTimes)
						{
							subWaveTimeTaskInfo.isStartCountting = false;
							delete _currentMonsterMarchSubWaveTimeTaskInfoMap[subWaveTimeTaskInfo.timeTaskInfoHandleId];
							if(_monsterMarchSubWaveTimeTaskInfoPool.length < MAX_MONSTER_MARCH_SUB_WAVE_TIME_TASK_INFO_CACHE_COUNT)
							{
								subWaveTimeTaskInfo.clear();
								_monsterMarchSubWaveTimeTaskInfoPool.push(subWaveTimeTaskInfo);
							}

							continue;
						}
						
						var monsterTypeId:int = subWaveTimeTaskInfo.monsterTypeId; 
						var monsterRoadIndex:int = subWaveTimeTaskInfo.roadIndex;
						var bRandomLine:Boolean = subWaveTimeTaskInfo.bRandomLine;
						
						var monsterCountPerTime:Number = subWaveTimeTaskInfo.monsterCountPerTime;
						if(monsterCountPerTime == 1)
						{
							march1MonsterPerTime(monsterTypeId, monsterRoadIndex,bRandomLine, true);
						}
						else if(monsterCountPerTime == 2)
						{
							march2MonsterPerTime(monsterTypeId, monsterRoadIndex);
						}
						else if(monsterCountPerTime == 3)
						{
							march3MonsterPerTime(monsterTypeId, monsterRoadIndex);
						}
						else if(monsterCountPerTime > 1 && monsterCountPerTime < 2)
						{
							march1Or2MonsterPerTime(monsterTypeId, monsterRoadIndex, subWaveTimeTaskInfo);
						}
						else if(monsterCountPerTime > 2 && monsterCountPerTime < 3)
						{
							march2Or3MonsterPerTime(monsterTypeId, monsterRoadIndex, subWaveTimeTaskInfo);
						}
					}
				}
			}
		}

		//每次出一个怪道路随机
		private function march1MonsterPerTime(monsterTypeId:int, roadIndex:int,bRandomLine:Boolean, checkIsBoos:Boolean = false):void
		{
			if(bRandomLine ||(checkIsBoos && monsterModel.getMonsterSheetById(monsterTypeId).isBoss))
				marchMonster(monsterTypeId, roadIndex, 1);
			else
				marchMonster(monsterTypeId, roadIndex, int(Math.random() * 3));
		}
		
		//每次出一个怪，空道路随机
		private function march2MonsterPerTime(monsterTypeId:int, roadIndex:int):void
		{
			var emptyLineIndex:int = int(Math.random() * 3);
			if(emptyLineIndex == 0)
			{
				marchMonster(monsterTypeId, roadIndex, 1);
				marchMonster(monsterTypeId, roadIndex, 2);
			}
			else if(emptyLineIndex == 1)
			{
				marchMonster(monsterTypeId, roadIndex, 0);
				marchMonster(monsterTypeId, roadIndex, 2);
			}
			else
			{
				marchMonster(monsterTypeId, roadIndex, 0);
				marchMonster(monsterTypeId, roadIndex, 1);
			}
		}
		
		private function march3MonsterPerTime(monsterTypeId:int, roadIndex:int):void
		{
			marchMonster(monsterTypeId, roadIndex, 0);
			marchMonster(monsterTypeId, roadIndex, 1);
			marchMonster(monsterTypeId, roadIndex, 2);
		}
		
		private function march1Or2MonsterPerTime(monsterTypeId:int, roadIndex:int, subWaveTimeTaskInfo:MonsterMarchSubWaveTimeTaskInfo):void
		{
			if(subWaveTimeTaskInfo.monsterMoreUnOutCount > 0)
			{
				march2MonsterPerTime(monsterTypeId, roadIndex);
				subWaveTimeTaskInfo.monsterMoreUnOutCount--;
			}
			else
			{
				march1MonsterPerTime(monsterTypeId, roadIndex,subWaveTimeTaskInfo.bRandomLine);
			}
		}

		private function march2Or3MonsterPerTime(monsterTypeId:int, roadIndex:int, subWaveTimeTaskInfo:MonsterMarchSubWaveTimeTaskInfo):void
		{
			if(subWaveTimeTaskInfo.monsterMoreUnOutCount > 0)
			{
				march3MonsterPerTime(monsterTypeId, roadIndex);
				subWaveTimeTaskInfo.monsterMoreUnOutCount--;
			}
			else
			{
				march2MonsterPerTime(monsterTypeId, roadIndex);
			}
		}
		
		private function marchMonster(monsterTypeId:int, roadIndex:int, lineIndex:int):void
		{
			var m0:BasicMonsterElement = objPoolMgr.createSceneElementObject(GameObjectCategoryType.MONSTER, monsterTypeId) as BasicMonsterElement;
			
			startMarchMonster(m0, mapRoadModel.getMapRoad(roadIndex).lineVOs[lineIndex].points, roadIndex, lineIndex);
			
			m0.ownWave = monsterWaveModel.curWaveCount;	
			
			checkNewMonster(m0.monsterTemplateInfo.resId || monsterTypeId);
		}
		
		private function startMarchMonster(m:BasicMonsterElement, pathPoints:Vector.<PointVO>, roadIndex:int, lineIndex:int):void
		{
			m.x = pathPoints[0].x;
			m.y = pathPoints[0].y;
			m.startEscapeByPath(pathPoints, roadIndex, lineIndex);
		}
		
		private function checkNewMonster(id:uint):void
		{
			if(newMonsters.isNewMonster(id))
			{
				//GameAGlobalManager.getInstance().game.gameFightMainUIView.newMonsterIconView.pushMonster(id);
				//GameAGlobalManager.getInstance().game.gameFightMainUIView.newMonsterIconView.show();
				newMonsters.removeNewMonster(id);
			}
		}
	}
}

class MonsterMarchSubWaveTimeTaskInfo
{
	public var timeTaskInfoHandleId:int = 0;
	
	public var startUintTimeIndex:int = 0;
	
	public var currentMarchMonsterTimes:int = 0;
	public var totalMarchMonsterTimes:int = 0;
	public var intervalUintTimeCount:int = 0;
	public var monsterCountPerTime:Number = 0;
	
	//info
	public var monsterCount:int = 0;
	public var monsterTypeId:int = 0;
	public var roadIndex:int = 0;
	/**
	 * 怪物所走的道路类型，0为随机，1为只走中间 
	 */		
	public var bRandomLine:Boolean;
	
	//那怪物总数除以次数的剩余怪的数量
	public var monsterMoreUnOutCount:uint = 0;
	
	//flag
	public var isStartCountting:Boolean = false;
	
	public function clear():void
	{
		timeTaskInfoHandleId = 0;
		startUintTimeIndex = 0;
		currentMarchMonsterTimes = 0;
		totalMarchMonsterTimes = 0;
		intervalUintTimeCount = 0;
		monsterCountPerTime = 0;
		monsterCount = 0;
		monsterTypeId = 0;
		roadIndex = 0;
		monsterMoreUnOutCount = 0;
		isStartCountting = false;
	}
}