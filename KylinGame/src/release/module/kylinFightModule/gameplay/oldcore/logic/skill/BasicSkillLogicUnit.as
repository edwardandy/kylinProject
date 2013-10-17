package release.module.kylinFightModule.gameplay.oldcore.logic.skill
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	import framecore.structure.model.user.TemplateDataFactory;
	import framecore.structure.model.user.base.BaseSkillInfo;
	
	public class BasicSkillLogicUnit implements IDisposeObject
	{
		protected var _id:uint = 0;
		protected var _isHeroSkill:Boolean = false;
		protected var _skillInfo:BaseSkillInfo;
		
		public function BasicSkillLogicUnit()
		{
		}
		
		public function setData(skillId:uint,bIsHero:Boolean = false):void
		{
			if(skillId == _id && bIsHero == _isHeroSkill)
				return;
			_id = skillId;
			_isHeroSkill = bIsHero;
			init();
		}
		
		protected function init():void
		{
			if(_isHeroSkill)
				_skillInfo = TemplateDataFactory.getInstance().getHeroSkillTemplateById(_id);
			else
				_skillInfo = TemplateDataFactory.getInstance().getSkillTemplateById(_id);
		}
		
		public function dispose():void
		{
			_id = 0;
			_skillInfo = null;
			_isHeroSkill = false;
		}
	}
}