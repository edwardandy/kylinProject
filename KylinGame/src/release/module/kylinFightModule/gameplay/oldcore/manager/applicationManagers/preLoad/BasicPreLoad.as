package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GamePreloadResMgr;
	import framecore.tools.GameStringUtil;
	
	import framecore.structure.model.user.base.BaseSkillInfo;

	public class BasicPreLoad
	{
		private var _mgr:GamePreloadResMgr;
		
		public function BasicPreLoad(mgr:GamePreloadResMgr)
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
				preloadSoilderRes(soilderId);
				preloadMonsterRes(soilderId);
			}
		}
		
		private function checkSummonAfterDieEffect(eff:Object):void
		{
			if(eff.hasOwnProperty(SkillResultTyps.SUMMON_AFTER_DIE))
			{
				var soilderId:uint = (eff[SkillResultTyps.SUMMON_AFTER_DIE] as String).split("-")[0];
				//可能是士兵，也可能是怪物
				preloadSoilderRes(soilderId);
				preloadMonsterRes(soilderId);
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
		protected function parseMagicBuffer(info:BaseSkillInfo):void
		{
			var arrBuff:Array = GameStringUtil.deserializeSplitString(info.buff);
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