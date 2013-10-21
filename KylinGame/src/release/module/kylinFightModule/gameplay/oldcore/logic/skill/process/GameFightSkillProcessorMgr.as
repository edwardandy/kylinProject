package release.module.kylinFightModule.gameplay.oldcore.logic.skill.process
{
	import release.module.kylinFightModule.gameplay.constant.identify.SkillID;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.BasicSkillLogicMgr;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.BasicSkillLogicUnit;
	import release.module.kylinFightModule.gameplay.oldcore.logic.skill.process.concreteProcessor.ColdStormProcessor;
	
	import robotlegs.bender.framework.api.IInjector;
	
	public class GameFightSkillProcessorMgr extends BasicSkillLogicMgr
	{		
		[Inject]
		public var injector:IInjector;
		
		public function GameFightSkillProcessorMgr()
		{
			super();
		}
		
		public function getSkillProcessorById(id:uint):BasicSkillProcessor
		{
			var result:BasicSkillProcessor = getSkillLogicById(id) as BasicSkillProcessor;
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
			injector.injectInto(logic);
			return logic;
		}
		
		override protected function createDefaultLogic():BasicSkillLogicUnit
		{
			return injector.instantiateUnmapped(BasicSkillProcessor);
		}
	}
}