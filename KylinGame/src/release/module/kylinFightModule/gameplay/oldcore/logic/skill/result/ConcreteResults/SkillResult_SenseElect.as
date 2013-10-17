package release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.ConcreteResults
{
	import com.shinezone.towerDefense.fight.constants.FightElementCampType;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillOwner;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.Interface.ISkillTarget;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.result.BasicSkillResult;

	/**
	 * 感电buff 对周围的所有生命单位每秒造成伤害 
	 */	
	public class SkillResult_SenseElect extends BasicSkillResult
	{
		public function SkillResult_SenseElect(strId:String)
		{
			super(strId);
		}
		
		override public function effect(value:Object,target:ISkillTarget,owner:ISkillOwner):Boolean
		{
			var arrValue:Array = getValueArray(value);
			var dmg:int = arrValue[1];
			if(arrValue.length>=3)
				dmg = getRandomValue(arrValue[1]+"-"+arrValue[2]);
			return target.atkRoundUnits(arrValue[0],dmg,FightElementCampType.ALL_CAMP,owner,getDieType(value));
		}
	}
}