package release.module.kylinFightModule.gameplay.oldcore.manager.gameManagers
{
	import release.module.kylinFightModule.gameplay.oldcore.core.IDisposeObject;
	import release.module.kylinFightModule.gameplay.oldcore.core.IGameLifecycleBeNotifyer;
	import com.shinezone.towerDefense.fight.constants.TowerDefenseGameState;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class BasicGameManager extends EventDispatcher implements IDisposeObject, IGameLifecycleBeNotifyer
	{
		public function BasicGameManager()
		{
			super();
		}
		
		public function initialize(...parameters:Array):void
		{
		}
		
		//IGameLifecycleNotifyer
		public function onGameStart():void
		{
		}
		
		public function onGameEnd():void
		{
		}
		
		public function onGamePause():void
		{
		}
		
		public function onGameResume():void
		{
		}
		
		//IDisposeObject Interface
		public function dispose():void
		{
		}
		
		//如果游戏不再运行过程中是不会抛出事件的
		override public function dispatchEvent(event:Event):Boolean
		{
			if(GameAGlobalManager.getInstance().game.gameState != TowerDefenseGameState.GAME_RUNNING) return false;
			return innerDispatchEvent(event);
		}
		
		protected final function innerDispatchEvent(event:Event):Boolean
		{
			return super.dispatchEvent(event);
		}
	}
}