package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.preLoad
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import com.shinezone.towerDefense.fight.constants.GameObjectCategoryType;
	import com.shinezone.towerDefense.fight.constants.Skill.SkillResultTyps;
	import release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers.GamePreloadResMgr;
	import framecore.tools.GameStringUtil;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.base.BaseSkillInfo;
	import framecore.structure.model.user.magicSkill.MagicSkillTemplateInfo;

	public class MagicPreLoad extends BasicPreLoad
	{
		public function MagicPreLoad(mgr:GamePreloadResMgr)
		{
			super(mgr);
		}
		
		override public function checkCurLoadRes(id:uint):void
		{
			var info:MagicSkillTemplateInfo = TemplateDataFactory.getInstance().getMagicSkillTemplateById(id);
			if(!info)
				return;
			
			var resId:uint = info.resId;
			if(resId)			
				preloadRes(GameObjectCategoryType.MAGIC_SKILL+"_"+resId);	
			
			//解析effect内包含的资源
			parseMagicEffect(GameStringUtil.deserializeString(info.effect));
			//解析buff内包含的资源
			parseMagicBuffer(info);
			
			parseCursor(info);
			parseOtherRes(info.otherResIds);
		}
		
		private function parseCursor(info:MagicSkillTemplateInfo):void
		{
			if(info.cursorId>0)
				preloadRes("cursor_"+info.cursorId);
		}
	}
}