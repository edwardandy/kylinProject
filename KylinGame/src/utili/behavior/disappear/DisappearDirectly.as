package utili.behavior.disappear
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import utili.behavior.Behavior;
	import utili.behavior.interfaces.IDisappear;
	import utili.behavior.interfaces.IDisappearBehavior;
	import utili.behavior.interfaces.IDispose;
	
	/**
	 * ...直接消失
	 * @author MAY
	 */
	public class DisappearDirectly extends Behavior implements IDisappearBehavior
	{
		private var tick:uint;
		/**
		 * 消失
		 */
		public function disappear():void
		{
			_mPanel.alpha = 0;
			_mPanel.visible = false;	
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