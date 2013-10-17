package release.module.kylinFightModule.gameplay.oldcore.manager.applicationManagers
{
	import com.shinezone.core.structure.controls.GameEvent;
	import com.shinezone.towerDefense.fight.constants.GamePlotProgress;
	import release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers.GameAGlobalManager;
	
	import framecore.structure.controls.battlPlotCommand.BattlePlotConst;
	import framecore.structure.model.user.battlePlot.BattlePlotData;
	import framecore.structure.model.user.battlePlot.BattlePlotTemplateInfo;
	import framecore.structure.model.user.fight.FightData;
	import framecore.structure.model.user.tollgate.TollgateData;
	import framecore.tools.logger.log;

	public class GamePlotMgr
	{
		private static var _instance:GamePlotMgr;
		
		private var _callback:Function;
		
		public function GamePlotMgr()
		{
		}
		
		public static function get instance():GamePlotMgr
		{
			return _instance ||= new GamePlotMgr;
		}
		
		public function playGamePlot(progress:int = GamePlotProgress.START,endCallback:Function = null):Boolean
		{
			var bHasPlot:Boolean = FightData.getInstance().fightDataObj.gamePlot[progress];
			if(!bHasPlot)
				return false;
			var currentLevelId:int = TollgateData.currentLevelId;
			var _talks:Vector.<BattlePlotTemplateInfo> = BattlePlotData.getInstance().getBattlePlotByTollID(currentLevelId)[progress];
			if ( _talks && _talks.length > 0 )
			{
				_callback = endCallback;
				GameEvent.getInstance().sendEvent( BattlePlotConst.CMD_PLAY_BATTLE_PLOT_REQ, [currentLevelId,progress,onPlotEnd] );
				GameAGlobalManager.getInstance().game.pause(false,false);
				GameAGlobalManager.getInstance().game.gameFightMainUIView.visible = false;
				return true;
			}
			return false;
		}
		
		private function onPlotEnd():void
		{
			GameAGlobalManager.getInstance().game.resume();
			GameAGlobalManager.getInstance().game.gameFightMainUIView.visible = true;
			if(_callback != null)
				_callback();
			_callback = null;	
		}
	}
}