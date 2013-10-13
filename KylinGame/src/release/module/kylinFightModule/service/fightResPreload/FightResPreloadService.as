package release.module.kylinFightModule.service.fightResPreload
{
	import flash.utils.Dictionary;
	import flash.utils.setTimeout;
	
	import kylin.echo.edward.framwork.model.KylinActor;
	import kylin.echo.edward.utilities.loader.interfaces.ILoaderProgress;
	
	import mainModule.model.gameData.sheetData.interfaces.IItemSheetDataModel;
	import mainModule.model.gameData.sheetData.interfaces.IMagicSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.item.ItemSheetItem;
	import mainModule.model.gameData.sheetData.skill.magic.MagicSkillSheetItem;
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import release.module.kylinFightModule.controller.fightInitSteps.FightInitStepsEvent;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.constant.identify.TowerID;
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
	import release.module.kylinFightModule.model.interfaces.ISceneDataModel;
	import release.module.kylinFightModule.model.marchWave.MonsterSubWaveVO;
	import release.module.kylinFightModule.service.fightResPreload.preLoad.BufferPreLoad;
	import release.module.kylinFightModule.service.fightResPreload.preLoad.HeroPreLoad;
	import release.module.kylinFightModule.service.fightResPreload.preLoad.ItemPreLoad;
	import release.module.kylinFightModule.service.fightResPreload.preLoad.MagicPreLoad;
	import release.module.kylinFightModule.service.fightResPreload.preLoad.MonsterPreLoad;
	import release.module.kylinFightModule.service.fightResPreload.preLoad.SkillPreLoad;
	import release.module.kylinFightModule.service.fightResPreload.preLoad.SoilderPreLoad;
	import release.module.kylinFightModule.service.fightResPreload.preLoad.TowerPreLoad;
	import release.module.kylinFightModule.service.fightResPreload.preLoad.WeaponPreLoad;

	/**
	 * 战斗前预加载资源，包括怪物，英雄，技能，法术等的动画
	 * @author Edward
	 * 
	 */	
	public class FightResPreloadService extends KylinActor
	{		
		private static var PreProcRes:String = "preProcRes";
		
		[Inject]
		public var loadService:ILoadAssetsServices;
		[Inject]
		public var loadProgress:ILoaderProgress;
		
		[Inject]
		public var magicSkillModel:IMagicSkillSheetDataModel;
		[Inject]
		public var itemModel:IItemSheetDataModel;
		[Inject]
		public var monsterWaveModel:IMonsterWaveModel;
		[Inject]
		public var sceneModel:ISceneDataModel;
		
		private var _dicPreloadRes:Dictionary = new Dictionary(true);
		
		private var _magicLoad:MagicPreLoad;
		private var _itemLoad:ItemPreLoad;
		private var _heroLoad:HeroPreLoad;
		private var _monsterLoad:MonsterPreLoad;
		private var _soilderLoad:SoilderPreLoad;
		private var _weaponLoad:WeaponPreLoad;
		private var _skillLoad:SkillPreLoad;
		private var _bufferLoad:BufferPreLoad;
		private var _towerLoad:TowerPreLoad;
				
		public function FightResPreloadService()
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
			
		}
		
		public function checkPreloadRes(url:String):void
		{
			loadService.addBattleItem(url,"FightRes").addToLoaderProgress(loadProgress);
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
			loadService.addIconItem("Hero_" + heroId + "_" /*+ IconConst.ICON_SIZE_CIRCLE*/).addToLoaderProgress(loadProgress);
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
			var item:MagicSkillSheetItem = magicSkillModel.getMagicSkillSheetById(magicId);
			if(!item)
				return;
			loadService.addIconItem("magic_" + (item.iconId>0?item.iconId:magicId) + "_" /*+ IconConst.ICON_SIZE_CIRCLE*/)
				.addToLoaderProgress(loadProgress);
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
			var item:ItemSheetItem = itemModel.getItemSheetById(itemId);
			if(!item)
				return;
			
			var iconId:uint = item.resourceId || itemId;
			loadService.addIconItem("Item_" + iconId + "_" /*+ IconConst.ICON_SIZE_CIRCLE*/)
				.addToLoaderProgress(loadProgress);
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
			for(var i:int = monsterWaveModel.totalWaveCount;i>0;--i)
			{
				for each(var subWave:MonsterSubWaveVO in monsterWaveModel.getMonsterWave(i).vecSubWaves)
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
			checkPreloadRes(GameObjectCategoryType.TOFT + "_" + sceneModel.sceneType);
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
			
		public function preInitAllRes():void
		{					
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
			
			
			if(loadProgress.hasItem)
				loadProgress.completeCB = onEnterBattle;
			else
			{
				setTimeout(onEnterBattle,100);
			}
		}
		
		private function onEnterBattle():void
		{
			//GameEvent.getInstance().sendEvent(FlashLogConst.CMD_FLASHLOADING_LOG,[HttpConst.HTTP_REQUEST,FlashLogConst.BATTLE_LOAD_END,"Dont need load battle res"]);
			dispatch(new FightInitStepsEvent(FightInitStepsEvent.FightStartup));
		}	
	}
}