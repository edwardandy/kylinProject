package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad
{
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GamePreloadResMgr;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.buff.BuffTemplateInfo;
	
	public class BufferPreLoad extends BasicPreLoad
	{
		public function BufferPreLoad(mgr:GamePreloadResMgr)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var info:BuffTemplateInfo = TemplateDataFactory.getInstance().getBuffTemplateById(id);
			if(!info)
				return;
			var resId:int = info.resourceId;
			if(0 == resId)
				resId = id;
			if(resId>0)
				preloadRes(GameObjectCategoryType.ORGANISM_SKILL_BUFFER+"_"+resId);
			
			parseOtherRes(info.otherResIds);
		}
		
		private function parseBuffMode(info:BuffTemplateInfo):void
		{
			
		}
	}
}