package release.module.kylinFightModule.gameplay.oldcore.display.uiView
{
	import release.module.kylinFightModule.gameplay.oldcore.core.BasicView;
	
	import flash.events.Event;

	public class GameFightLoadingView extends BasicView
	{
		private var _loadingAnimation:FightLoadingAnimation;
		
		public function GameFightLoadingView()
		{
			super();
			
			this.mouseChildren = false;
		}
		
		public function showLoadingDoor():void
		{
			_loadingAnimation.gotoAndPlay(1);
		}
		
		public function hideLoadingDoor():void
		{
			_loadingAnimation.gotoAndPlay(40);
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			_loadingAnimation = new FightLoadingAnimation();
			_loadingAnimation.stop();
			_loadingAnimation.addFrameScript(39, showLoadingDoorEndHandler, 79, hideLoadingDoorEndHandler);
			addChild(_loadingAnimation);
		}
		
		private function showLoadingDoorEndHandler():void
		{
			_loadingAnimation.stop();
			
			dispatchEvent(new Event(Event.OPEN));
		}
		
		private function hideLoadingDoorEndHandler():void
		{
			_loadingAnimation.gotoAndStop(1);
			
			dispatchEvent(new Event(Event.CLOSE));
		}
		
		override public function dispose():void
		{
			super.dispose();
			
			removeChild(_loadingAnimation);
			_loadingAnimation.addFrameScript(19, null, 39, null);
			_loadingAnimation.stop();
			_loadingAnimation = null;
		}
	}
}