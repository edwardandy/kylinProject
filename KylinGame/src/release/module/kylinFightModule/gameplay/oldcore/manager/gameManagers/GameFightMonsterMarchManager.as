package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import com.shinezone.towerDefense.fight.constants.BattleEffectType;
	import com.shinezone.towerDefense.fight.constants.GameFightConstant;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.display.IMonsterMarchImplementor;
	import release.module.kylinFightModule.gameplay.oldcore.display.TowerDefenseGame;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.BasicMonsterElement;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameMarchMonsterEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.ObjectPoolManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.TimeTaskManager;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.vo.NewMonsterList;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.MonsterMarchSubWaveVO;
	import com.shinezone.towerDefense.fight.vo.map.MonsterMarchWaveVO;
	import com.shinezone.towerDefense.fight.vo.map.RoadVO;
	
	import framecore.structure.model.constdata.NewbieConst;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.tollgate.TollgateData;
	import framecore.structure.views.newguidPanel.NewbieGuideManager;
	
	public final class GameFightMonsterMarchManager extends BasicGameManager
	{
		private static const MAX_MONSTER_MARCH_SUB_WAVE_TIME_TASK_INFO_CACHE_COUNT:uint = 50;
		
		private static const MARCHING:int = 1;
		private static const WAITTING:int = 0;
		private static const CURWAVECOMPLETE:int = 2;
		
		private var _monsterMarchImplementor:IMonsterMarchImplementor;
		private var _monsterMarchWaveVOs:Vector.<MonsterMarchWaveVO>;
		
		private var _timeHandlerId:int = -1;
		private var _marchBehaviorState:int = WAITTING;
		
		private var _currentMonsterMarchWaveVO:MonsterMarchWaveVO;
		private var _currentMonsterMarchSubWaveTimeTaskInfoMap:Array;//[index->value]
		
		private var _monsterMarchSubWaveTimeTaskInfoPool:Array;//MonsterMarchSubWaveTimeTaskInfo
		
		public function GameFightMonsterMarchManager()
		{
			super();
		}
		
		override public function initialize(...parameters:Array):void
		{
			_monsterMarchImplementor = GameAGlobalManager.getInstance().groundScene;
		}
		
		//IDisposeObject Interface
		override public function dispose():void
		{
			_monsterMarchImplementor = null;
			_monsterMarchWaveVOs = null;
		}
		
		override public function onGameStart():void
		{
			_monsterMarchSubWaveTimeTaskInfoPool = [];
			
			_monsterMarchWaveVOs = GameAGlobalManager
				.getInstance()
				.gameDataInfoManager
				.currentSceneMapInfo
				.monsterMarchWaveVOs;
			_marchBehaviorState = WAITTING;

			dispatchEvent(new GameMarchMonsterEvent(GameMarchMonsterEvent.WAIT_AND_READ_TO_MARCH_NEXT_WAVE));
		}
		
		override public function onGameEnd():void
		{
			if(_timeHandlerId>0)
				TimeTaskManager.getInstance().destoryTimeTask(_timeHandlerId);
			_timeHandlerId = -1;
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
					var timeProgress:Number = TimeTaskManager.getInstance().getTaskTimeTaskProgress(_timeHandlerId);
					var leftTime:int = int(timeProgress * GameFightConstant.MONSTER_WAVE_DURATION);
					
					TimeTaskManager.getInstance().destoryTimeTask(_timeHandlerId);
				}
				
				_currentMonsterMarchWaveVO = GameAGlobalManager
					.getInstance()
					.gameDataInfoManager
					.getCurrentWaveVO();
				
				var subWaveVOs:Vector.<MonsterMarchSubWaveVO> = _currentMonsterMarchWaveVO.subWaveVOs;
				var subWaveCount:uint = subWaveVOs.length;
				_currentMonsterMarchSubWaveTimeTaskInfoMap = [];
				var subWaveTimeTaskInfo:MonsterMarchSubWaveTimeTaskInfo = null;
				var subWaveVO:MonsterMarchSubWaveVO = null;
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
					subWaveTimeTaskInfo.roadType = subWaveVO.roadType;
					
					GameAGlobalManager.getInstance().gameFightInfoRecorder.addBattleOPRecord( GameFightInfoRecorder.BATTLE_OP_TYPE_COUNT_MONSTER, subWaveVO.monsterTypeId, subWaveVO.monsterCount );
				}

				var event:GameMarchMonsterEvent = new GameMarchMonsterEvent(GameMarchMonsterEvent.MARCH_NEXT_WAVE);
				event.nextWavepreactTime = marchNextWavePreactTime;
				dispatchEvent(new GameMarchMonsterEvent(GameMarchMonsterEvent.MARCH_NEXT_WAVE));
				
				//新手引导
				NewbieGuideManager.getInstance().startCondition(NewbieConst.CONDITION_START_WAVE,{"param":[GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount,TollgateData.currentLevelId]});
				NewbieGuideManager.getInstance().endCondition(NewbieConst.CONDITION_END_CLICK_MONSTER_BTN,{"param":[GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount]});
				
				//do it
				_timeHandlerId = TimeTaskManager
					.getInstance()
					.createTimeTask(GameFightConstant.TIME_UINT, 
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
				GameAGlobalManager.getInstance().gameFightInfoRecorder.addWavePreactTime(marchNextWavePreactTime);
				GameAGlobalManager.getInstance().gameDataInfoManager.marchMonsterEarler(marchNextWavePreactTime);
				GameAGlobalManager.getInstance()
					.game.gameFightMainUIView.fightControllBarView
					.reduceMagicSkillCDTime(0, marchNextWavePreactTime, 0,true);
			}
			
			var curWave:int = GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount;
			//战斗开始
			if(0 == GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount
			||(EndlessBattleMgr.instance.isEndless && EndlessBattleMgr.instance.recordWave == GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount))
			{
				GameAGlobalManager.getInstance().gameDataInfoManager.bStartFight = true;
				if(EndlessBattleMgr.instance.isEndless)
					GameAGlobalManager.getInstance().game.playBattleEffect( BattleEffectType.ENDLESS_WAVE_NUM_EFFECT, [curWave+1]);
			}
			//最后一波
			else if(GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount 
				== GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveTotalCount - 1)
			{
				GameAGlobalManager.getInstance().game.playBattleEffect( BattleEffectType.FINAL_WAVE_EFFECT );
			}
			//无极幻境每5波一个节点
			/*else if(EndlessBattleMgr.instance.isSavePointWave(GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount+1))
			{
				if(EndlessBattleMgr.instance.isEndless)
					GameAGlobalManager.getInstance().game.playBattleEffect( BattleEffectType.ENDLESS_WAVE_NUM_EFFECT, curWave+1);
			}*/
			//无极幻境每波都提示
			else
			{
				if(EndlessBattleMgr.instance.isEndless)
					GameAGlobalManager.getInstance().game.playBattleEffect( BattleEffectType.ENDLESS_WAVE_NUM_EFFECT, [curWave+1]);
			}
			
			GameAGlobalManager.getInstance().gameDataInfoManager.increaseSceneWave();
			
			if(EndlessBattleMgr.instance.isEndless)
			{
				EndlessBattleMgr.instance.checkRetrieveBuffEnd();
				EndlessBattleMgr.instance.setCurWaveMonsterCnts(GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount,
				GameAGlobalManager.getInstance().gameDataInfoManager.getCurrentWaveVO().totalMonsters);
			}
		}
		
		public function getWaitNextWaveProgress():Number
		{
			if(_marchBehaviorState == WAITTING)
			{
				if(_timeHandlerId > 0)
				{
					return Math.min(Math.max(TimeTaskManager.getInstance().getTaskTimeTaskProgress(_timeHandlerId),0),1);
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
			
			if(GameAGlobalManager
				.getInstance()
				.gameDataInfoManager
				.sceneWaveCurrentCount >= GameAGlobalManager
											.getInstance()
											.gameDataInfoManager.sceneWaveTotalCount)
			{
				GameAGlobalManager.getInstance().gameDataInfoManager.setIsCompleteWave();
				return;
			}
			
			_marchBehaviorState = CURWAVECOMPLETE;
			
			if(!(EndlessBattleMgr.instance.isEndless && EndlessBattleMgr.instance.isSavePointWave(GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount)))
				waitNextWave();
		}
		
		private function waitNextWave():void
		{
			_timeHandlerId = TimeTaskManager
				.getInstance()
				.createTimeTask(GameFightConstant.TIME_UINT, 
					marchMonsterWaveTimerTickHandler, null, 
					GameFightConstant.MONSTER_WAVE_DURATION / GameFightConstant.TIME_UINT, waitNextWaveCompleteHandler);
			
			_marchBehaviorState = WAITTING;
			if(!EndlessBattleMgr.instance.isEndless)
				dispatchEvent(new GameMarchMonsterEvent(GameMarchMonsterEvent.WAIT_AND_READ_TO_MARCH_NEXT_WAVE));
		}
		
		private function waitNextWaveCompleteHandler():void
		{
			_timeHandlerId = -1;
			marchNextWave();
		}

		//event handler
		private function marchMonsterWaveTimerTickHandler():void
		{
			var timeUintIndex:int = TimeTaskManager
				.getInstance().getTimeTaskCurrentRepeatCount(_timeHandlerId);
			
			for each(var subWaveTimeTaskInfo:MonsterMarchSubWaveTimeTaskInfo in _currentMonsterMarchSubWaveTimeTaskInfoMap)
			{
				if(subWaveTimeTaskInfo.startUintTimeIndex == timeUintIndex)
				{
					subWaveTimeTaskInfo.isStartCountting = true;
					NewbieGuideManager.getInstance().startCondition(NewbieConst.CONDITION_START_TOLLGATE_AND_WAVE
						,{"param":[TollgateData.currentLevelId,GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount
							,_currentMonsterMarchSubWaveTimeTaskInfoMap.indexOf(subWaveTimeTaskInfo) + 1]});
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
						var roadType:int = subWaveTimeTaskInfo.roadType;
						
						var monsterCountPerTime:Number = subWaveTimeTaskInfo.monsterCountPerTime;
						if(monsterCountPerTime == 1)
						{
							march1MonsterPerTime(monsterTypeId, monsterRoadIndex,roadType, true);
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
		private function march1MonsterPerTime(monsterTypeId:int, roadIndex:int,roadType:int, checkIsBoos:Boolean = false):void
		{
			if(1 == roadType ||(checkIsBoos && TemplateDataFactory.getInstance().getMonsterTemplateById(monsterTypeId).isBoss))
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
				march1MonsterPerTime(monsterTypeId, roadIndex,subWaveTimeTaskInfo.roadType);
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
			var m0:BasicMonsterElement = ObjectPoolManager.getInstance()
				.createSceneElementObject(GameObjectCategoryType.MONSTER, monsterTypeId) as BasicMonsterElement;
			
			_monsterMarchImplementor.marchMonster(m0, 

				GameAGlobalManager.getInstance().gameDataInfoManager.currentSceneMapInfo.roadVOs[roadIndex].lineVOs[lineIndex].points, roadIndex, lineIndex);
			
			m0.ownWave = GameAGlobalManager.getInstance().gameDataInfoManager.sceneWaveCurrentCount;
			
			checkNewMonster(m0.monsterTemplateInfo.resId || monsterTypeId);
		}
		
		private function checkNewMonster(id:uint):void
		{
			if(NewMonsterList.instance.isNewMonster(id))
			{
				GameAGlobalManager.getInstance().game.gameFightMainUIView.newMonsterIconView.pushMonster(id);
				GameAGlobalManager.getInstance().game.gameFightMainUIView.newMonsterIconView.show();
				NewMonsterList.instance.removeNewMonster(id);
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
	public var roadType:int;
	
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