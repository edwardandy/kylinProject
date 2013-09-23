package utili.behavior.disappear
{
	import utili.behavior.Behavior;
	import utili.behavior.displayUtility.DisplayUtility;
	import utili.behavior.interfaces.IDisappear;
	import utili.behavior.interfaces.IDisappearBehavior;
	import utili.behavior.interfaces.IDispose;

	/**
	 * 面板消失特效
	 * （20130105前后要求统一的效果）  
	 * @author Jiao Zhongxiao
	 * 
	 */	
	public class DisappearAlphaScale2 extends Behavior implements IDisappearBehavior
	{
		public function DisappearAlphaScale2()
		{
			super();
		}
		
		public function disappear():void
		{
			DisplayUtility.instance.panelDisappear( _mPanel, false, false,appearCB);
		}
	}
}