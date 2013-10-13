package mainModule.model.gameData.dynamicData.heroSkill
{
	import flash.utils.Dictionary;
	
	import mainModule.controller.gameData.GameDataUpdateEvent;
	import mainModule.model.gameData.dynamicData.BaseDynamicItem;
	import mainModule.model.gameData.dynamicData.BaseDynamicItemsModel;
	import mainModule.model.gameData.dynamicData.DynamicDataNameConst;
	import mainModule.model.gameData.dynamicData.interfaces.IHeroSkillDynamicDataModel;

	/**
	 * 英雄技能动态数据 
	 * @author Edward
	 * 
	 */	
	public class HeroSkillDynamicDataModel extends BaseDynamicItemsModel implements IHeroSkillDynamicDataModel
	
	{
		private var _dicHeroToSkill:Dictionary = new Dictionary;
		
		public function HeroSkillDynamicDataModel()
		{
			super();
			dataId = DynamicDataNameConst.HeroSkillData;
			updateEventType = GameDataUpdateEvent.GameDataUpdate_HeroSkillData;
			itemClazz = HeroSkillDynamicItem;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function getHeroSkillDataById(heroId:uint,skillId:uint):HeroSkillDynamicItem
		{
			var vecSkills:Vector.<HeroSkillDynamicItem> = _dicHeroToSkill[heroId];
			if(!vecSkills)
				return null;
			for each(var item:HeroSkillDynamicItem in vecSkills)
			{
				if(skillId == item.skillId)
					return item;
			}
			return null;
		}
		/**
		 * @inheritDoc
		 */
		public function getHeroAllSkillData(heroId:uint):Vector.<HeroSkillDynamicItem>
		{
			var vecSkills:Vector.<HeroSkillDynamicItem> = _dicHeroToSkill[heroId];
			if(!vecSkills)
				return null;
			return vecSkills;
		}
		
		override protected function onItemAdd(item:BaseDynamicItem):void
		{
			var skillItem:HeroSkillDynamicItem = item as HeroSkillDynamicItem;
			_dicHeroToSkill[uint(skillItem.heroId)] ||= new Vector.<HeroSkillDynamicItem>;
			(_dicHeroToSkill[uint(skillItem.heroId)] as Vector.<HeroSkillDynamicItem>).push(item);
		}
		
		override protected function onItemRemove(item:BaseDynamicItem):void
		{
			var skillItem:HeroSkillDynamicItem = item as HeroSkillDynamicItem;
			if(_dicHeroToSkill[uint(skillItem.heroId)] is Vector.<HeroSkillDynamicItem>)
			{
				var idx:int = (_dicHeroToSkill[uint(skillItem.heroId)] as Vector.<HeroSkillDynamicItem>).indexOf(skillItem);
				if(-1 != idx)
					(_dicHeroToSkill[uint(skillItem.heroId)] as Vector.<HeroSkillDynamicItem>).splice(idx,1);
			}
		}
	}
}