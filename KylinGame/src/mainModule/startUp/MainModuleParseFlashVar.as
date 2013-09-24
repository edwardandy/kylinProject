package mainModule.startUp
{
	import mainModule.model.gameConstAndVar.FlashVarsModel;
	
	import robotlegs.bender.framework.api.IInjector;
	
	/**
	 * 解析js传给flash的变量并保存
	 * @author Administrator
	 * 
	 */	
	public final class MainModuleParseFlashVar
	{
		public function MainModuleParseFlashVar(data:Object,inject:IInjector)
		{
			var flashVar:FlashVarsModel = new FlashVarsModel;
			
			flashVar.RES_VER = data.ver;
			
			inject.map(FlashVarsModel).toValue(flashVar);
		}
	}
}