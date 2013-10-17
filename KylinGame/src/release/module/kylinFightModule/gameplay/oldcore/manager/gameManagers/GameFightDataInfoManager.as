package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import com.shinezone.towerDefense.fight.algorithms.astar.MathUtil;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.TowerDefenseGameState;
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.events.GameDataInfoEvent;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GamePreloadResMgr;
	import release.module.kylinFightModule.gameplay.oldcore.manager.eventsMgr.EndlessBattleMgr;
	import release.module.kylinFightModule.gameplay.oldcore.utils.GameMathUtil;
	import com.shinezone.towerDefense.fight.vo.PointVO;
	import com.shinezone.towerDefense.fight.vo.map.MapConfigDataVO;
	import com.shinezone.towerDefense.fight.vo.map.MonsterMarchSubWaveVO;
	import com.shinezone.towerDefense.fight.vo.map.MonsterMarchWaveVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.UserData;
	import framecore.structure.model.user.spiritBless.SpiritBlessData;
	import framecore.structure.model.user.spiritBless.SpiritBlessInfo;
	import framecore.structure.model.user.spiritBless.SpiritBlessTemplateInfo;
	import framecore.structure.model.user.tollgate.TollgateData;
	import framecore.structure.model.user.tollgate.TollgateTemplateInfo;
	import framecore.structure.model.varMoudle.HttpVar;
	import framecore.tools.logger.log;

	public final class GameFightDataInfoManager extends BasicGameManager
	{
		private var _currentSceneMapInfo:MapConfigDataVO;

		private var _sceneGold:int = 0;
		private var _sceneLife:int = 0;
		private var _sceneTotalLife:int = 0;
		
		private var _monsterLifeScale:Number = 1;
		private var _monsterAtkScale:Number = 1;
		/**
		 *区分地图场景类型 1草原 2雪地 3熔岩 4 沙漠 5沼泽
		 */		
		private var _sceneType:int;

		private var _sceneWaveCurrentCount:int = 0;
		private var _sceneWaveTotalCount:int = 0;
		
		private var _isCompleteallWave:Boolean = false;
		
		public var gameFightId:String;
		
		public var bStartFight:Boolean =  false;
		
		private var _earlerGolds:int = 0;
		
		public function GameFightDataInfoManager()
		{
			super();
		}
		
		//获取当前地图配置信息

		public function get monsterAtkScale():Number
		{
			return _monsterAtkScale;
		}

		public function set monsterAtkScale(value:Number):void
		{
			_monsterAtkScale = (value || 1);
		}

		public function get monsterLifeScale():Number
		{
			return _monsterLifeScale;
		}

		public function set monsterLifeScale(value:Number):void
		{
			_monsterLifeScale = (value || 1);
		}

		public function get currentSceneMapInfo():MapConfigDataVO
		{
			return _currentSceneMapInfo;
		}
		
		//物资
		public function get sceneGold():int
		{
			return _sceneGold;
		}
		
		//场景生命
		public function get sceneLife():int
		{
			return _sceneLife;
		}
		
		public function get totalSceneLife():int
		{
			return _sceneTotalLife;
		}
		
		/**
		 *区分地图场景类型 1草原 2雪地 3熔岩 4 沙漠 5沼泽
		 */		
		public function get sceneType():int
		{
			return _sceneType;
		}
		
		//场景当前波次数
		public function get sceneWaveCurrentCount():int
		{
			return _sceneWaveCurrentCount;
		}
		
		//场景总波次数
		public function get sceneWaveTotalCount():int
		{
			return _sceneWaveTotalCount;
		}
		
		//初始化场景数据
		public function initializeMapConfigData(currentSceneMapInfo:MapConfigDataVO):void
		{
			_currentSceneMapInfo = currentSceneMapInfo;
			_currentSceneMapInfo.genRoadDistance();
			
			//preloadMonsterRes();
			_sceneGold = currentSceneMapInfo.initializeGold;
			//test by gaojian
			var name:String = UserData.getInstance().userBaseInfo.name;
			log("name:",name);
			if(GameAGlobalManager.bTest)
			{
				_sceneGold = 100000;
			}
			_sceneLife = currentSceneMapInfo.initializeLife;
			_sceneType = currentSceneMapInfo.sceneType;
			_sceneTotalLife = _sceneLife;
			
			if(EndlessBattleMgr.instance.isEndless)
				_sceneWaveCurrentCount = EndlessBattleMgr.instance.recordWave;
			else
				_sceneWaveCurrentCount = 0;
			
			_sceneWaveTotalCount = currentSceneMapInfo.initializeTotalWavesCount;
			
			_isCompleteallWave = false;

			var event:GameDataInfoEvent = new GameDataInfoEvent(GameDataInfoEvent.INITIALIZE_DATA_INFO);
			innerDispatchEvent(event);
			
			bStartFight = false;
		}
		
		
		//更新场景生命
		public function updateSceneLife(value:int):void
		{
			//test by gaojian
			if(GameAGlobalManager.bTest)
			{
				return;
			}
			_sceneLife += value;
			
			if(_sceneLife <= 0)
			{
				_sceneLife = 0;
			}
			
			var event:GameDataInfoEvent = new GameDataInfoEvent(GameDataInfoEvent.UPDATE_SCENE_LIFE);
			dispatchEvent(event);
		}
		
		//更新场景物资
		public function updateSceneGold(value:int):void
		{
			_sceneGold += value;
			
			if(_sceneGold <= 0)
			{
				_sceneGold = 0;
			}
			
			var event:GameDataInfoEvent = new GameDataInfoEvent(GameDataInfoEvent.UPDATE_SCENE_GOLD);
			dispatchEvent(event);
		}
		
		public function updateSceneScore():void
		{
			var event:GameDataInfoEvent = new GameDataInfoEvent(GameDataInfoEvent.UPDATE_SCENE_SCORE);
			dispatchEvent(event);
		}
		
		override public function dispatchEvent(event:Event):Boolean
		{
			if(!EndlessBattleMgr.instance.isEndless && GameAGlobalManager.getInstance().game.gameState != TowerDefenseGameState.GAME_RUNNING) 
				return false;
			return innerDispatchEvent(event);
		}
		
		//获取当前波次数据
		public function getCurrentWaveVO():MonsterMarchWaveVO
		{
			return _currentSceneMapInfo.monsterMarchWaveVOs[_sceneWaveCurrentCount - 1];
		}
		
		//获取下一波次数据
		public function getNextWaveVO():MonsterMarchWaveVO
		{
			return _currentSceneMapInfo.monsterMarchWaveVOs[_sceneWaveCurrentCount];
		}
		
		//怎加当前波次
		public function increaseSceneWave():void
		{
			if(_isCompleteallWave) return;

			if(_sceneWaveCurrentCount < _sceneWaveTotalCount)
			{
				_sceneWaveCurrentCount++;

				var event:GameDataInfoEvent = new GameDataInfoEvent(GameDataInfoEvent.UPDATE_SCENE_WAVE);
				dispatchEvent(event);
			}
		}
		
		//设置波次结束
		public function setIsCompleteWave():void
		{
			_isCompleteallWave = true;
		}
		
		public function getIsCompleteWave():Boolean
		{
			return _isCompleteallWave;
		}
		
		public function marchMonsterEarler(time:uint):void
		{
			_earlerGolds = time*2/1000;
			updateSceneGold(_earlerGolds);
		}
		
		public function get earlerGolds():int
		{
			return _earlerGolds;
		}
	}
}