package release.module.kylinFightModule.service.fightResPreload.preLoad
{
	import mainModule.model.gameData.sheetData.monster.IMonsterSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.IBaseSkillSheetItem;
	import mainModule.model.gameData.sheetData.soldier.ISoldierSheetDataModel;
	
	import release.module.kylinFightModule.gameplay.constant.BufferFields;
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.Skill.SkillResultTyps;
	import release.module.kylinFightModule.service.fightResPreload.FightResPreloadService;
	
	

	public class BasicPreLoad
	{
		[Inject]
		public var monsterModel:IMonsterSheetDataModel;
		[Inject]
		public var soldierModel:ISoldierSheetDataModel;
		
		private var _mgr:FightResPreloadService;
		
		public function BasicPreLoad(mgr:FightResPreloadService)
		{
			_mgr = mgr;
		}
		
		public function checkCurLoadRes(id:uint):void
		{
			
		}
		
		protected function preloadRes(str:String):void
		{
			_mgr.checkPreloadRes(str);
		}
			
		protected function preloadSoilderRes(id:uint):void
		{
			_mgr.checkSoilderPreloadRes(id);
		}
		
		protected function preloadWeaponRes(id:uint):void
		{
			_mgr.checkWeaponPreloadRes(id);
		}
		
		protected function preloadBufferRes(id:uint):void
		{
			_mgr.checkBufferPreloadRes(id);
		}
		
		protected function preloadMagicRes(id:uint):void
		{
			_mgr.checkMagicPreloadRes(id);
		}
		
		protected function preloadSkillRes(id:uint):void
		{
			_mgr.checkSkillPreloadRes(id);
		}
		
		protected function preloadMonsterRes(id:uint):void
		{
			_mgr.checkMonsterPreloadRes(id);
		}
		
		/**
		 * 
		 * 解析effect内包含的资源
		 * 
		 */		
		protected function parseMagicEffect(eff:Object):void
		{
			if(eff)
			{
				checkSummonEffect(eff);
				checkSummonAfterDieEffect(eff);
				checkWeaponEffect(eff);
				checkGroundEff(eff);
				checkDieType(eff);
			}
		}
				
		private function checkSummonEffect(eff:Object):void
		{
			if(eff.hasOwnProperty(SkillResultTyps.SUMMON))
			{
				var soilderId:uint = (eff[SkillResultTyps.SUMMON] as String).split("-")[0];
				//可能是士兵，也可能是怪物
				if(null != monsterModel.getMonsterSheetById(soilderId))
					preloadMonsterRes(soilderId);
				else if(null != soldierModel.getSoldierSheetById(soilderId))
					preloadSoilderRes(soilderId);
				
			}
		}
		
		private function checkSummonAfterDieEffect(eff:Object):void
		{
			if(eff.hasOwnProperty(SkillResultTyps.SUMMON_AFTER_DIE))
			{
				var soilderId:uint = (eff[SkillResultTyps.SUMMON_AFTER_DIE] as String).split("-")[0];
				//可能是士兵，也可能是怪物
				if(null != monsterModel.getMonsterSheetById(soilderId))
					preloadMonsterRes(soilderId);
				else if(null != soldierModel.getSoldierSheetById(soilderId))
					preloadSoilderRes(soilderId);
			}
		}
		
		private function checkWeaponEffect(eff:Object):void
		{
			var weaponId:uint = 0;
			if(eff.hasOwnProperty(SkillResultTyps.WEAPON))
			{
				weaponId = eff[SkillResultTyps.WEAPON];
				
			}
			
			if(eff.hasOwnProperty(SkillResultTyps.CHANGE_WEAPON))
			{
				weaponId = eff[SkillResultTyps.CHANGE_WEAPON];
				
			}
			if(weaponId>0)
				preloadWeaponRes(weaponId);
		}
		
		private function checkGroundEff(eff:Object):void
		{
			var groundEffId:uint = 0;
			if(eff.hasOwnProperty(SkillResultTyps.ADD_WALK_EFF))
			{
				groundEffId = (eff[SkillResultTyps.ADD_WALK_EFF] as String).split("-")[0];
			}
			
			if(eff.hasOwnProperty(SkillResultTyps.ADD_GROUND_EFF))
			{
				groundEffId = (eff[SkillResultTyps.ADD_GROUND_EFF] as String).split("-")[0];
			}
			
			if(groundEffId>0)
				preloadRes(GameObjectCategoryType.GROUNDEFFECT+"_"+groundEffId);
		}
		
		protected function checkDieType(eff:Object):void
		{
			if(eff.hasOwnProperty("dieType"))
				preloadRes(GameObjectCategoryType.DIEEFFECT + "_" + eff["dieType"]);
		}
		/**
		 * 
		 * 解析buff内包含的资源
		 * 
		 */		
		protected function parseMagicBuffer(info:IBaseSkillSheetItem):void
		{
			var arrBuff:Array = info.getBuffs();
			if(arrBuff)
			{
				for each(var buff:Object in arrBuff)
				{
					var buffId:uint = buff[BufferFields.BUFF];
					preloadBufferRes(buffId);
					parseMagicEffect(buff);
				}
			}
		}
		/**
		 * 解析附加资源
		 */		
		protected function parseOtherRes(otherResIds:String):void
		{
			if(otherResIds)
			{
				var arrRes:Array = otherResIds.split(",");
				for each(var url:String in arrRes)
				{
					parseEachOtherRes(url);
				}
			}
		}
		
		private function parseEachOtherRes(url:String):void
		{
			var arr:Array = url.split("_");
			
			switch(arr[0])
			{
				case GameObjectCategoryType.MONSTER:
					preloadMonsterRes(arr[1]);
					return;
			}
			
			preloadRes(url);
		}
	}
}