package mainModule.extensions.flashVars
{
	
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	/**
	 * 储存网页传递给flash的参数 
	 * @author Edward
	 * 
	 */	
	public class FlashVarsExtension implements IExtension
	{
		private var _param:Object;
		
		public function FlashVarsExtension(data:Object)
		{
			_param = data;
		}
		
		public function extend(context:IContext):void
		{
			var flashVar:FlashVars = new FlashVars;
			
			flashVar.RES_VER = _param.ver;
			
			context.injector.map(FlashVars).toValue(flashVar);
			_param = null;
		}
	}
}