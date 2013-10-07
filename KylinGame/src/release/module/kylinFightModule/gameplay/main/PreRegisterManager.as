package release.module.kylinFightModule.gameplay.main
{
	import flash.display.DisplayObjectContainer;
	
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;

	/**
	 * 给战斗主场景注册管理器 
	 * @author Edward
	 * 
	 */	
	public final class PreRegisterManager
	{
		public var mainFightScene:MainFightScene;
		[Inject]
		public var monsterWave:IMonsterWaveModel;
		[Inject]
		public var viewLayers:IFightViewLayersModel;
		
		public function PreRegisterManager(main:MainFightScene)
		{
			mainFightScene = main;
		}
		
		[PostConstruct]
		public function preRegister():void
		{
			mainFightScene.registerManager(IMonsterWaveModel,monsterWave);
			mainFightScene.registerManager(IFightViewLayersModel,viewLayers);
		}
	}
}