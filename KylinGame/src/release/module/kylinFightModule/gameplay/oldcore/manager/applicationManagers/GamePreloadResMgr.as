package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers
{
	import br.com.stimuli.loading.BulkProgressEvent;
	import br.com.stimuli.loading.loadingtypes.ImageItem;
	import br.com.stimuli.loading.loadingtypes.XMLItem;
	
	import com.shinezone.core.resource.ClassLibrary;
	import com.shinezone.core.structure.controls.GameEvent;
	import com.shinezone.towerDefense.fight.constants.BattleAppDomainType;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.Skill.SkillResultTyps;
	import com.shinezone.towerDefense.fight.constants.Skill.SkillType;
	import com.shinezone.towerDefense.fight.constants.identify.MagicID;
	import com.shinezone.towerDefense.fight.constants.identify.MonsterID;
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import com.shinezone.towerDefense.fight.constants.identify.TowerID;
	import release.module.kylinFightModule.gameplay.oldcore.display.render.BitmapFrameInfo;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.effects.SkillEffect.SkillEffectBehaviorState;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons.PropIconView;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad.BufferPreLoad;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad.HeroPreLoad;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad.ItemPreLoad;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad.MagicPreLoad;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad.MonsterPreLoad;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad.SkillPreLoad;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad.SoilderPreLoad;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad.TowerPreLoad;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad.WeaponPreLoad;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	import com.shinezone.towerDefense.fight.vo.map.MonsterMarchSubWaveVO;
	import com.shinezone.towerDefense.fight.vo.map.MonsterMarchWaveVO;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.sampler.getSize;
	import flash.utils.Dictionary;
	import flash.utils.clearTimeout;
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	import framecore.structure.model.constdata.FlashLogConst;
	import framecore.structure.model.constdata.HttpConst;
	import framecore.structure.model.constdata.IconConst;
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.UserData;
	import framecore.structure.model.user.base.BaseSkillInfo;
	import framecore.structure.model.user.fight.FightData;
	import framecore.structure.model.user.hero.HeroData;
	import framecore.structure.model.user.hero.HeroInfo;
	import framecore.structure.model.user.item.ItemData;
	import framecore.structure.model.user.item.ItemInfo;
	import framecore.structure.model.user.item.ItemTemplateInfo;
	import framecore.structure.model.user.magicSkill.MagicSkillData;
	import framecore.structure.model.user.magicSkill.MagicSkillTemplateInfo;
	import framecore.structure.model.user.monster.MonsterTemplateInfo;
	import framecore.structure.model.user.tollgate.TollgateData;
	import framecore.structure.model.user.tollgate.TollgateInfo;
	import framecore.structure.model.user.weapon.WeaponTemplateInfo;
	import framecore.structure.model.varMoudle.HttpVar;
	import framecore.tools.GameStringUtil;
	import framecore.tools.loadmgr.LoadMgr;
	import framecore.tools.loadmgr.LoaderProgressItems;
	import framecore.tools.loadmgr.LoadingProgressMgr;
	import framecore.tools.logger.logch;

	public final class GamePreloadResMgr
	{
		private static var _instance:GamePreloadResMgr;
		
		private static var PreProcRes:String = "preProcRes";
		
		private var _dicPreloadRes:Dictionary = new Dictionary(true);
		
		private var _loadMgr:LoadMgr;
		private var _loadProgress:LoaderProgressItems;
		
		private var _magicLoad:MagicPreLoad;
		private var _itemLoad:ItemPreLoad;
		private var _heroLoad:HeroPreLoad;
		private var _monsterLoad:MonsterPreLoad;
		private var _soilderLoad:SoilderPreLoad;
		private var _weaponLoad:WeaponPreLoad;
		private var _skillLoad:SkillPreLoad;
		private var _bufferLoad:BufferPreLoad;
		private var _towerLoad:TowerPreLoad;
		
		private var _afterInitCallback:Function;
				
		public function GamePreloadResMgr()
		{
			_magicLoad = new MagicPreLoad(this);
			_itemLoad = new ItemPreLoad(this);
			_heroLoad = new HeroPreLoad(this);
			_monsterLoad = new MonsterPreLoad(this);
			_soilderLoad = new SoilderPreLoad(this);
			_weaponLoad = new WeaponPreLoad(this);
			_skillLoad = new SkillPreLoad(this);
			_bufferLoad = new BufferPreLoad(this);
			_towerLoad = new TowerPreLoad(this);
			
			_loadMgr = LoadMgr.instance;
			_loadProgress = LoadingProgressMgr.instance.loadBattleProgress;
		}
		
		public static function get instance():GamePreloadResMgr
		{
			return _instance ||= new GamePreloadResMgr();
		}
		
		public function checkPreloadRes(url:String):void
		{
			if(undefined == _dicPreloadRes[url])
			{
				var item:ImageItem = _loadMgr.addBattleItem(url,BattleAppDomainType.FightRes);
				if(!item)
				{
					logch("GamePreload:","cannot gen res item:"+url);
					return;
				}
				else if(item.isLoaded)
				{
					logch("GamePreload:","item isLoaded:"+url);
					_dicPreloadRes[url] = true;
				}
				else
				{
					logch("GamePreload:","item added to load:"+url);
					_loadProgress.addItem(item);
					_dicPreloadRes[url] = false;
				}
			}
		}
		
		/**
		 * 英雄资源
		 */		
		public function checkHeroPreloadRes(heroId:uint):void
		{
			_heroLoad.checkCurLoadRes(heroId);
		}
		
		public function checkHeroPreloadIcon(heroId:uint):void
		{
			var item:ImageItem = _loadMgr.addIconItem("Hero_" + heroId + "_" + IconConst.ICON_SIZE_CIRCLE,null,LoadMgr.Load_BattleRes);
			if(item && !item.isLoaded)
				_loadProgress.addItem(item);
		}
		/**
		 * 怪物资源
		 */		
		public function checkMonsterPreloadRes(monsterId:uint):void
		{
			_monsterLoad.checkCurLoadRes(monsterId);
		}
		/**
		 * 技能资源
		 */		
		public function checkSkillPreloadRes(skillId:uint):void
		{
			_skillLoad.checkCurLoadRes(skillId);
		}
		/**
		 * 子弹资源
		 */		
		public function checkWeaponPreloadRes(weaponId:uint):void
		{
			_weaponLoad.checkCurLoadRes(weaponId);
			
		}
		/**
		 * 士兵资源
		 */		
		public function checkSoilderPreloadRes(soilderId:uint):void
		{
			_soilderLoad.checkCurLoadRes(soilderId);
		}
		/**
		 * 法术资源
		 */		
		public function checkMagicPreloadRes(magicId:uint):void
		{
			_magicLoad.checkCurLoadRes(magicId);
		}
		
		public function checkMagicPreloadIcon(magicId:uint):void
		{
			var info:MagicSkillTemplateInfo = TemplateDataFactory.getInstance().getMagicSkillTemplateById(magicId);
			if(!info)
				return;
			
			var item:ImageItem = _loadMgr.addIconItem("magic_" + (info.iconId>0?info.iconId:magicId) + "_" + IconConst.ICON_SIZE_CIRCLE,null,LoadMgr.Load_BattleRes);
			if(item && !item.isLoaded)
				_loadProgress.addItem(item);
		}
		/**
		 * 道具资源
		 */		
		public function checkItemPreloadRes(itemId:uint):void
		{
			_itemLoad.checkCurLoadRes(itemId);
		}
		
		public function checkItemPreloadIcon(itemId:uint):void
		{
			var itemTemp:ItemTemplateInfo = TemplateDataFactory.getInstance().getItemTemplateById(itemId);
			if(!itemTemp)
				return;
			
			var iconId:uint = itemTemp.resourceId || itemId;
			var item:ImageItem = _loadMgr.addIconItem("Item_" + iconId + "_" + IconConst.ICON_SIZE_CIRCLE,null,LoadMgr.Load_BattleRes);
			if(item && !item.isLoaded)
				_loadProgress.addItem(item);
		}
		/**
		 * buff资源
		 */		
		public function checkBufferPreloadRes(buffId:uint):void
		{
			_bufferLoad.checkCurLoadRes(buffId);
		}

		/**
		 * 预加载道具使用效果资源
		 */
		private function preloadItemRes():void
		{
			for each(var id:uint in PropIconView.ITEMIDS)
			{
				checkItemPreloadRes(id);
				checkItemPreloadIcon(id);
			}
		}
		/**
		 * 预加载战场法术使用效果资源
		 */
		private function preloadMagicRes():void
		{
			var arr:Array = MagicSkillData.getInstance().getAllOwnMagicTemps();
			for each(var temp:MagicSkillTemplateInfo in arr)
			{
				checkMagicPreloadRes(temp.configId);
				checkMagicPreloadIcon(temp.configId);
			}
		}
		/**
		 * 预加载英雄技能使用效果资源
		 */
		private function preloadHeroSkillRes():void
		{
			for each(var id:uint in UserData.getInstance().userExtendInfo.currentHeroIds)
			{	
				checkHeroPreloadRes(id);
				checkHeroPreloadIcon(id);
			}
		}
		
		/**
		 * 预加载怪物资源
		 */
		private function preloadMonsterRes():void
		{
			var fightDataObject:Object = FightData.getInstance().fightDataObj;
			for each(var wave:Object in fightDataObject.waveInfo)
			{
				for each(var subWave:Object in wave.subWaves)
				{
					checkMonsterPreloadRes(subWave.monsterTypeId);
				}
			}
		}
		/**
		 * 预加载塔基资源
		 */
		private function preloadToftRes():void
		{
			checkPreloadRes(GameObjectCategoryType.TOFT + "_" + GameAGlobalManager.getInstance().gameDataInfoManager.sceneType);
		}
		/**
		 * 预加载塔资源
		 */
		private function preloadTowerRes():void
		{
			var arrTowerIds:Array = [TowerID.BarrackTower,TowerID.ArrowTower,TowerID.MagicTower,TowerID.CannonTower];
			for each(var towerId:uint in arrTowerIds)
			{
				_towerLoad.checkCurLoadRes(towerId);
			}
		}
		
		private function preloadMapRes():void
		{
			var currentLevelId:uint = TollgateData.currentLevelId;
			
			var strMapId:String = "map_" + int(currentLevelId*0.1) + "_2";
			
			var mapImg:ImageItem = LoadMgr.instance.addMapImgItem(strMapId);
			var mapXml:XMLItem = LoadMgr.instance.addMapXmlItem("map_" + currentLevelId + "_2");
			if(!mapImg || !mapXml)
			{
				throw(new Error("LoadFightMap Error mapId: "+currentLevelId));
				return;
			}
			
			if(mapImg.isLoaded)
				(TollgateData.getInstance().getOwnInfoById(currentLevelId) as TollgateInfo).mapImage = (mapImg.content as DisplayObject);
			
			if(mapXml.isLoaded)
				(TollgateData.getInstance().getOwnInfoById(currentLevelId) as TollgateInfo).mapXml = mapXml.content as XML;
			
			if(mapImg.isLoaded && mapXml.isLoaded)
				return;
			
			if(!mapImg.isLoaded)
			{
				mapImg.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					(TollgateData.getInstance().getOwnInfoById(currentLevelId) as TollgateInfo).mapImage = (mapImg.content as DisplayObject);
					mapImg.removeEventListener(Event.COMPLETE, arguments.callee);
				});
				_loadProgress.addItem(mapImg);
			}
			
			if(!mapXml.isLoaded)
			{
				mapXml.addEventListener(Event.COMPLETE,function(e:Event):void
				{
					(TollgateData.getInstance().getOwnInfoById(currentLevelId) as TollgateInfo).mapXml = mapXml.content as XML;
					mapXml.removeEventListener(Event.COMPLETE, arguments.callee);
				});
				_loadProgress.addItem(mapXml);
			}
			
			LoadMgr.instance.getMapLoader().start();
		}
		/**
		 * 预加载所有资源 
		 */		
		public function preInitAllRes(cb:Function):void
		{
			_afterInitCallback = cb;
			_loadProgress.dispose();
						
			preloadMapRes();
			
			preloadItemRes();
			preloadMagicRes();
			preloadHeroSkillRes();
			preloadMonsterRes();
			//preloadToftRes();
			preloadTowerRes();
			
			checkPreloadRes("others");
			checkPreloadRes("scenetip");
			checkPreloadRes("MagicSkill_211001");
			checkMagicPreloadRes(211501);
			checkMagicPreloadRes(211601);
			checkPreloadRes("DieEffect_2");
			checkPreloadRes("DieEffect_3");
			checkPreloadRes("DieEffect_4");
			checkPreloadRes("DieEffect_5");
			checkPreloadRes("DieEffect_6");
			checkPreloadRes("Toft_1");
			checkPreloadRes("Toft_2");
			checkPreloadRes("Toft_3");
			checkPreloadRes("Toft_4");
			checkPreloadRes("Toft_5");
			checkPreloadRes("Toft_6");
			
			checkSkillPreloadRes(SkillID.AutoRecoverLife);
			
			
			if(_loadProgress.hasItem)
			{
				_loadMgr.getBattleResLoader().start();
				_loadProgress.addEventListener(Event.COMPLETE,onResLoadCmp);
			}
			else if(_afterInitCallback!=null)
			{
				_loadProgress.dispatchEvent(new Event(Event.COMPLETE));
				setTimeout(onEnterBattle,100);
			}
		}
		
		private function onEnterBattle():void
		{
			GameEvent.getInstance().sendEvent(FlashLogConst.CMD_FLASHLOADING_LOG,[HttpConst.HTTP_REQUEST,FlashLogConst.BATTLE_LOAD_END,"Dont need load battle res"]);
			_afterInitCallback();	
		}	
		
		private function onResLoadCmp(e:Event):void
		{
			GameEvent.getInstance().sendEvent(FlashLogConst.CMD_FLASHLOADING_LOG,[HttpConst.HTTP_REQUEST,FlashLogConst.BATTLE_LOAD_END,"Load battle res complete"]);
			_loadProgress.removeEventListener(Event.COMPLETE,onResLoadCmp);
			
			for(var id:String in _dicPreloadRes)
			{
				if(false == _dicPreloadRes[id])
				{
					_dicPreloadRes[id] = true;
				}
			}

			if(_afterInitCallback!=null)
				_afterInitCallback();
		}
	}
}