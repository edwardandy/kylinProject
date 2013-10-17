package release.module.kylinFightModule.gameplay.oldcore.utils
{
	import flash.display.Graphics;

	public final class GraphicsUtil
	{
		public static function drawSector(graphics:Graphics, centerX:Number, centerY:Number,
												   radius:Number, angle:Number, startFrom:Number = 0):void
		{
			graphics.moveTo(centerX, centerY);
			
			angle = GameMathUtil.adjustRadianBetween0And360(angle);
			startFrom = GameMathUtil.adjustRadianBetween0And360(startFrom);
			
			var n:Number = Math.ceil(Math.abs(angle)/45);
			
			var angleA:Number = angle / n;
			angleA = GameMathUtil.degreeToRadian(angleA);
			startFrom = GameMathUtil.degreeToRadian(startFrom);
			graphics.lineTo(centerX + radius * Math.cos(startFrom), centerY + radius * Math.sin(startFrom));
			
			for (var i:int = 1; i <= n; i++) 
			{
				startFrom += angleA;
				var angleMid:Number = startFrom - angleA * 0.5;
				var bx:Number = centerX + radius / Math.cos(angleA * 0.5) * Math.cos(angleMid);
				var by:Number = centerY + radius / Math.cos(angleA  * 0.5) * Math.sin(angleMid);
				var cx:Number = centerX + radius * Math.cos(startFrom);
				var cy:Number = centerY + radius * Math.sin(startFrom);
				
				graphics.curveTo(bx, by, cx, cy);
			}
			
			graphics.lineTo(centerX, centerY);
		}
	}
}