package release.module.kylinFightModule.gameplay.oldcore.events
{
	import release.module.kylinFightModule.gameplay.oldcore.core.ISceneFocusElement;
	
	import flash.events.Event;

	public class SceneElementFocusEvent extends Event
	{
		public static const SCENE_ELEMENT_FOCUSED:String = "sceneElementFocused";

		public var focusedElement:ISceneFocusElement;

		public function SceneElementFocusEvent(type:String)
		{
			super(type);
		}
	}
}