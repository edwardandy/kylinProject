package release.module.kylinFightModule.gameplay.oldcore.logic.skill
{
	import mainModule.model.gameData.sheetData.skill.BaseOwnerSkillSheetItem;
	import mainModule.model.gameData.sheetData.skill.IBaseOwnerSkillSheetItem;
	import mainModule.model.gameData.sheetData.skill.heroSkill.IHeroSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.monsterSkill.IMonsterSkillSheetDataModel;
	import mainModule.model.gameData.sheetData.skill.towerSkill.ITowerSkillSheetDataModel;
	
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	
	public class BasicSkillLogicUnit implements IDisposeObject
	{
		[Inject]
		public var heroSkillModel:IHeroSkillSheetDataModel;
		[Inject]
		public var monsterSkillModel:IMonsterSkillSheetDataModel;
		[Inject]
		public var towerSkillModel:ITowerSkillSheetDataModel;
		
		protected var _id:uint = 0;
		protected var _isHeroSkill:Boolean = false;
		protected var _skillInfo:IBaseOwnerSkillSheetItem;
		
		public function BasicSkillLogicUnit()
		{
		}
		
		public function setData(skillId:uint):void
		{
			if(skillId == _id)
				return;
			_id = skillId;
			init();
		}
		
		protected function init():void
		{
			_skillInfo = heroSkillModel.getHeroSkillSheetById(_id);
			if(_skillInfo)
				_isHeroSkill = true;
			else
			{
				_isHeroSkill = false;
				_skillInfo = monsterSkillModel.getMonsterSkillSheetById(_id);
				_skillInfo ||= towerSkillModel.getTowerSkillSheetById(_id);
			}
		}
		
		public function dispose():void
		{
			_id = 0;
			_skillInfo = null;
			_isHeroSkill = false;
		}
	}
}