package mainModule.extensions.viewLayers
{
	import flash.display.DisplayObjectContainer;
	
	import kylin.echo.edward.utilities.display.DisplayObjectUtils;
	
	
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	/**
	 * 现实层级设置 
	 * @author Edward
	 * 
	 */	
	public class ViewLayerExtension implements IExtension
	{
		private var _root:DisplayObjectContainer;
		
		public function ViewLayerExtension(root:DisplayObjectContainer)
		{
			_root = root;
		}
		
		public function extend(context:IContext):void
		{
			context.injector.map(ViewLayersMgr).asSingleton();
			
			var viewLayers:ViewLayersMgr = context.injector.getOrCreateNewInstance(ViewLayersMgr);
			
			_root.addChild(viewLayers.fightScene);
			_root.addChild(viewLayers.contextRoot);
			DisplayObjectUtils.instance.fillRectSprite(viewLayers.waitPanelAppearLayer,_root.stage.stageWidth,_root.stage.stageHeight,0,0);
			
			context.configure( new ContextView(viewLayers.contextRoot) );
		}
	}
}