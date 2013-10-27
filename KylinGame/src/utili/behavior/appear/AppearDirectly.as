package utili.behavior.appear
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import utili.behavior.Behavior;
	import utili.behavior.interfaces.IAppear;
	import utili.behavior.interfaces.IAppearBehavior;
	import utili.behavior.interfaces.IDispose;

	/**
	 * ...直接出现
	 * @author MAY
	 */
	public class AppearDirectly extends Behavior implements IAppearBehavior
	{
		private var tick:uint;
		/**
		 * 出现
		 */
		public function appear():void
		{
			_mPanel.alpha = 1;
			_mPanel.visible = true;
			tick = setTimeout(appearCB,10);
		}
		
		override protected function appearCB():void
		{
			super.appearCB();
			if(tick>0)
				clearTimeout(tick);
		}
		
		/**
		 * 停止动作
		 */
		public function stopAction():void
		{
			
		}
		
		/**
		 * 销毁
		 */
		override public function dispose():void
		{
			super.dispose();
		}
		
	}

}