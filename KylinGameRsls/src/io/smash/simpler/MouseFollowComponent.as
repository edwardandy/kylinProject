package io.smash.simpler
{
    import io.smash.time.TickedComponent;
    import io.smash.time.TimeManager;
    
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.geom.Point;
    
    public class MouseFollowComponent extends TickedComponent
    {
        [SmashInject]
        public var stage:Stage;
        
        public var targetProperty:String;
        
        public override function onTick(iElapse:int):void
        {
            owner.setProperty(targetProperty, new Point(stage.mouseX, stage.mouseY));
        }
    }
}