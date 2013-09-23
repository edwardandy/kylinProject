 package utili.behavior.appear
{
	import utili.behavior.Behavior;
	import utili.behavior.displayUtility.DisplayUtility;
	import utili.behavior.interfaces.IAppear;
	import utili.behavior.interfaces.IAppearBehavior;
	import utili.behavior.interfaces.IDispose;

	/**
	 * 面板出现特效
	 * （20130105前后要求统一的效果） 
	 * @author Jiao Zhongxiao
	 * 
	 */	
	public class AppearAlphaScale2 extends Behavior implements IAppearBehavior
	{
		public function AppearAlphaScale2()
		{
			super();
		}
		
		public function appear():void
		{
			DisplayUtility.instance.panelAppear( _mPanel, false, false, appearCB);
		}
	}
}