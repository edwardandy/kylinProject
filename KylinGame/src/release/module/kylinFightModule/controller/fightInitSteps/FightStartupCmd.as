package release.module.kylinFightModule.controller.fightInitSteps
{
	import flash.display.Sprite;
	
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import mainModule.model.gameData.dynamicData.fight.IFightDynamicDataModel;
	
	import release.module.kylinFightModule.controller.fightState.FightStateEvent;
	import release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.GameFightMainUIView;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameFightMonsterMarchManager;
	import release.module.kylinFightModule.gameplay.oldcore.vo.treasureData.TreasureDataList;
	import release.module.kylinFightModule.model.interfaces.IFightViewLayersModel;
	import release.module.kylinFightModule.model.interfaces.IMonsterWaveModel;
	import release.module.kylinFightModule.model.sceneElements.ISceneElementsModel;
	import release.module.kylinFightModule.model.state.FightState;

	/**
	 * 战斗前准备完毕，开始战斗 
	 * @author Edward
	 * 
	 */	
	public class FightStartupCmd extends KylinCommand
	{
		[Inject]
		public var fightData:IFightDynamicDataModel;
		[Inject]
		public var treasureList:TreasureDataList;
		[Inject]
		public var sceneElementsModel:ISceneElementsModel;
		[Inject]
		public var fightState:FightState;
		[Inject]
		public var fightViewModel:IFightViewLayersModel;
		[Inject]
		public var mainUI:GameFightMainUIView;
		[Inject]
		public var monsterMarchMgr:GameFightMonsterMarchManager;
		
		
		public function FightStartupCmd()
		{
			super();
		}
		
		override public function execute():void
		{
			super.execute();
			treasureList.initList(fightData.arrTreasureList);
			sceneElementsModel.initBeforeFightStart();
			fightState.state = FightState.Initialized;
			
			
			fightViewModel.groundBg.graphics.beginFill(0,0);
			fightViewModel.groundBg.graphics.drawRect(0,0,760,650);
			fightViewModel.groundBg.graphics.endFill();
			
			fightViewModel.UILayer.addChild(mainUI);
			monsterMarchMgr.mainUI = mainUI;
			dispatch(new FightStateEvent(FightStateEvent.FightStart));
		}
	}
}