package release.module.kylinFightModule.gameplay.oldcore.display
{
	import flash.display.Shape;
	
	public class SimpleProgressBar extends Shape
	{
		private var _currentValue:int;
		private var _maxValue:int;
		
		private var _progressColor:uint;
		private var _backgroundColor:uint;
		private var _hasBorder:Boolean;
		private var _borderColor:uint;
		
		private var _barWidth:Number;
		private var _barHeight:Number;

		public function SimpleProgressBar(currentValue:int, maxValue:int,
									progressColor:uint = 0x35bb00, backgroundColor:uint = 0xc90000,
									barWidth:Number = 30, barHeight:Number = 4,hasBorder:Boolean = false,borderColor:Number = 0x2a9000)
		{
			super();

			_progressColor = progressColor;
			_backgroundColor = backgroundColor;
			_hasBorder = hasBorder;
			_borderColor = borderColor;
			
			_currentValue = currentValue;
			_maxValue = maxValue;
			
			_barWidth = barWidth;
			_barHeight = barHeight;

			updateDraw();
		}
		
		public function get currentValue():int
		{
			return _currentValue;
		}
		
		public function set currentValue(value:int):void
		{
			if(value <= 0) value = 0;
			else if(value >= _maxValue) value = _maxValue;

			if(_currentValue != value)
			{
				_currentValue = value;
				
				updateDraw();
			}
		}
		
		public function get maxValue():int
		{
			return _maxValue;
		}
		
		public function set maxValue(value:int):void
		{
			if(_maxValue != value)
			{
				_maxValue = value;
				updateDraw();
			}
		}
		
		protected function updateDraw():void
		{
			var halfWidth:Number = _barWidth / 2;
			var progressWidth:Number = (!_maxValue || !_barWidth) ? 0 : _currentValue / _maxValue * _barWidth;
			var backgroundWidth:Number = _barWidth - progressWidth;
			
			graphics.clear();
			if(_hasBorder)
			{
				graphics.beginFill(_borderColor);
				graphics.drawRect(-halfWidth-1, -_barHeight-1, _barWidth+2, _barHeight+2);
			}
			graphics.beginFill(_progressColor);
			graphics.drawRect(-halfWidth, -_barHeight, progressWidth, _barHeight);
			if(backgroundWidth > 0)
			{
				graphics.beginFill(_backgroundColor);
				graphics.drawRect(-halfWidth + progressWidth, -_barHeight, backgroundWidth, _barHeight);
			}
			graphics.endFill();
		}
	}
}