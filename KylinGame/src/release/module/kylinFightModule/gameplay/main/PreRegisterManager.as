package release.module.kylinFightModule.gameplay.main
{
	
	import flash.display.Stage;
	
	import io.smash.debug.Console;
	import io.smash.debug.ConsoleCommandManager;
	import io.smash.input.KeyboardManager;
	import io.smash.property.PropertyManager;
	import io.smash.time.TimeManager;
	import io.smash.util.TypeUtility;
	
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
		[Inject]
		public var stage:Stage;
		
		public function PreRegisterManager(main:MainFightScene)
		{
			mainFightScene = main;
		}
		
		[PostConstruct]
		public function preRegister():void
		{
			mainFightScene.name = "MainFightScene_Group";
			mainFightScene.registerManager(Stage, stage);
			mainFightScene.registerManager(PropertyManager, new PropertyManager());
			//mainFightScene.registerManager(ConsoleCommandManager, new ConsoleCommandManager());
			mainFightScene.registerManager(TimeManager, new TimeManager());
			mainFightScene.registerManager(KeyboardManager, new KeyboardManager());
			mainFightScene.registerManager(Console, new Console());
			
			mainFightScene.registerManager(IMonsterWaveModel,monsterWave);
			mainFightScene.registerManager(IFightViewLayersModel,viewLayers);
		}
	}
}