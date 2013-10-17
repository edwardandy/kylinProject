package release.module.kylinFightModule.gameplay.oldcore.logic.skill.process
{
	import com.shinezone.towerDefense.fight.constants.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.BasicSkillLogicMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.BasicSkillLogicUnit;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.concreteProcessor.ColdStormProcessor;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.BasicGameManager;
	
	public class GameFightSkillProcessorMgr extends BasicSkillLogicMgr
	{		
		public function GameFightSkillProcessorMgr()
		{
			super();
		}
		
		public function getSkillProcessorById(id:uint,isHero:Boolean = false):BasicSkillProcessor
		{
			var result:BasicSkillProcessor = getSkillLogicById(id,isHero) as BasicSkillProcessor;
			return result;	
		}
		
		override protected function getLogic(id:uint):BasicSkillLogicUnit
		{
			var logic:BasicSkillLogicUnit;
			switch(id)
			{
				case SkillID.ColdStorm:
					logic = new ColdStormProcessor();
					break;
				default:
					logic = new BasicSkillProcessor();
					break;
			}
			return logic;
		}
		
		override protected function createDefaultLogic():BasicSkillLogicUnit
		{
			return new BasicSkillProcessor();
		}
	}
}