package release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.concreteProcessor
{
	import com.shinezone.towerDefense.fight.constants.BufferFields;
	import release.module.kylinFightModule.gameplay.oldcore.display.sceneElements.organisms.monsters.boss.HeartOfIce;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.BasicSkillProcessor;

	/**
	 * 极寒风暴
	 */
	public class ColdStormProcessor extends BasicSkillProcessor
	{
		public function ColdStormProcessor()
		{
			super();
		}
		
		override protected function changeParamBeforeUse(src:Object,owner:ISkillOwner):Object
		{
			var boss:HeartOfIce = owner as HeartOfIce;
			if(!src || !boss)
				return src;
			var param:Object = {};
			var field:*;
			for(field in src)
			{
				param[field] = src[field];
			}
			
			param[BufferFields.DURATION] = boss.getColdStormDuration();
			return param;
		}
	}
}