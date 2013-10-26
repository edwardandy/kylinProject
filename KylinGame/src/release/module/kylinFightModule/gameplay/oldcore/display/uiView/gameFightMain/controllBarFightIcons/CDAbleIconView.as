package release.module.kylinFightModule.gameplay.oldcore.display.uiView.gameFightMain.controllBarFightIcons
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import io.smash.time.IRenderAble;
	
	import kylin.echo.edward.utilities.display.DisplayUtility;
	
	import mainModule.service.loadServices.interfaces.ILoadAssetsServices;
	
	import release.module.kylinFightModule.gameplay.constant.GameObjectCategoryType;
	import release.module.kylinFightModule.gameplay.constant.identify.MagicID;
	import release.module.kylinFightModule.gameplay.oldcore.core.TickSynchronizer;
	import release.module.kylinFightModule.gameplay.oldcore.utils.SimpleCDTimer;
	
	import robotlegs.bender.framework.api.IInjector;

	public class CDAbleIconView extends BasicIconView implements IRenderAble
	{
		[Inject]
		public var tickMgr:TickSynchronizer;
		[Inject]
		public var loadService:ILoadAssetsServices;
		[Inject]
		public var injector:IInjector;
		
		protected var myIconUseCDTimer:SimpleCDTimer;
		protected var myIconUseCDTime:uint = 0;
		
		private var _myIconUseCDProgressShape:Shape;
		
		private var _mcResetCDEff:MovieClip;
		private var _mcDecreaseCDEff:rdcCdEff;
		private var _iDecreaseCDSec:int;
		
		private var _greyIcon:Bitmap = null;
		private var _playedCDEndEffect:Boolean = true;
		
		public function CDAbleIconView()
		{
			super();
		}
		
		override public function notifyOnGameStart():void
		{
			super.notifyOnGameStart();
			_playedCDEndEffect = true;
			if(myIconUseCDTime > 0)
			{
				myIconUseCDTimer.setDurationTime(myIconUseCDTime);
				myIconUseCDTimer.clearCDTime();
			}
		}
		
		override public function notifyOnGameEnd():void
		{
			super.notifyOnGameEnd();
			
			if(myIconUseCDTime > 0)
			{
				myIconUseCDTimer.clearCDTime();
				myIconUseCDTime = 0;
			}
			_myIconUseCDProgressShape.graphics.clear();
		}
		
		override public function notifyTargetMouseCursorSuccessRealsed(mouseClickEvent:MouseEvent):void
		{
			super.notifyTargetMouseCursorSuccessRealsed(mouseClickEvent);
			
			resetCDAbleIconViewCDTime();
		}
		
		public final function resetCDAbleIconViewCDTime():void
		{
			//gaojian
			/*if(GameAGlobalManager.bTest)
				return;*/
			if(myIconUseCDTime > 0)
			{
				myIconUseCDTimer.resetCDTime();
			}
		}
		
		public final function clearCDAbleIconViewCDTime(bPlayEff:Boolean = false):void
		{
			if(bPlayEff)
				playCDResetEff();
			if(myIconUseCDTime > 0)
			{
				myIconUseCDTimer.clearCDTime();
			}
		}
		
		protected function playCDResetEff():void
		{
			if(!_mcResetCDEff)
			{
				//_mcResetCDEff = ClassLibrary.getInstance().getMovieClip(GameObjectCategoryType.MAGIC_SKILL+"_"+MagicID.Magic_Vortex);
				
				_mcResetCDEff = loadService.domainMgr.getMovieClipByDomain(GameObjectCategoryType.MAGIC_SKILL+"_"+MagicID.Magic_Vortex);
				_mcResetCDEff.x = myIconBitmapBackground.width * 0.5;
				_mcResetCDEff.y = myIconBitmapBackground.height * 0.5;
			}
			_mcResetCDEff.addFrameScript(_mcResetCDEff.totalFrames - 1,onCDResetEffEnd);
			addChild(_mcResetCDEff);
			_mcResetCDEff.mouseChildren = _mcResetCDEff.mouseEnabled = false;
			_mcResetCDEff.gotoAndPlay(1);
		}
		
		private function onCDResetEffEnd():void
		{
			_mcResetCDEff.stop();
			removeChild(_mcResetCDEff);
		}
		
		override protected function setIconBitmapData(value:BitmapData):void
		{
			super.setIconBitmapData(value);
			if ( _greyIcon.bitmapData )
			{
				_greyIcon.bitmapData.dispose();
				_greyIcon.bitmapData = null;
			}
			if ( value )
			{
				_greyIcon.bitmapData = new BitmapData( value.width, value.height, true, 0xFF0000 );
				_greyIcon.bitmapData.draw( myIconBitmapBackground );
				_greyIcon.bitmapData.draw( myIconBitmap );
			}
			_greyIcon.x = myIconBitmap.x;
			_greyIcon.y = myIconBitmap.y;
			_myIconUseCDProgressShape.x = _greyIcon.x;
			_myIconUseCDProgressShape.y = _greyIcon.y;
			DisplayUtility.instance.makeGrey( _greyIcon, true );
			if(value != null)
			{
				tickMgr.attachToTicker(this);
			}
			else
			{
				tickMgr.dettachFromTicker(this);
			}
		}
		
		public function decreaseCDCoolDownRunTime(value:uint,bPlayAnim:Boolean = false):void
		{
			if(myIconUseCDTime > 0)
			{
				if(bPlayAnim)
				{
					var leftCd:int = myIconUseCDTimer.getCDCoolDownLeftTime();
					playDecreaseCDAnim((leftCd>value?value:leftCd)/1000);
				}
				myIconUseCDTimer.decreaseCDCoolDownRunTime(value);	
			}
		}
		
		private function playDecreaseCDAnim(sec:int):void
		{
			if(sec<=0)
				return;
			_iDecreaseCDSec = sec;
			if(!_mcDecreaseCDEff)
			{
				_mcDecreaseCDEff = new rdcCdEff;
				_mcDecreaseCDEff.x = this.width/2;
				_mcDecreaseCDEff.y = -10;
			}
			this.addChild(_mcDecreaseCDEff);
			var text:TextField = (_mcDecreaseCDEff.content.getChildByName("txtNum") as TextField);
			if(text)
				text.text = "-"+_iDecreaseCDSec+"S";
			_mcDecreaseCDEff.gotoAndPlay(1);
			_mcDecreaseCDEff.addFrameScript(_mcDecreaseCDEff.totalFrames-1,onEndDecreaseEff);
		}
		
		private function onEndDecreaseEff():void
		{
			if(contains(_mcDecreaseCDEff))
				removeChild(_mcDecreaseCDEff);	
		}
		
		override protected function onInitialize():void
		{
			super.onInitialize();
			
			myIconUseCDTimer = new SimpleCDTimer(myIconUseCDTime);
			injector.injectInto(myIconUseCDTimer);
			
			_myIconUseCDProgressShape = new Shape();
			addChild(_myIconUseCDProgressShape);
			
			_greyIcon = new Bitmap();
			addChild( _greyIcon );
			_greyIcon.mask = _myIconUseCDProgressShape;
		}

		override protected function getIsInValidIconMouseClick():Boolean
		{
			return !myIconUseCDTimer.getIsCDEnd() || 
				super.getIsInValidIconMouseClick(); 
		}
		
		public function render(iElapse:int):void
		{
			/*if(myIconUseCDTime > 0)
			{
				myIconUseCDTimer.tick();
			}*/

			drawCurrentCDTimerProgressGraphics(myIconUseCDTimer);
		}
		
		protected function drawCurrentCDTimerProgressGraphics(simpleCd:SimpleCDTimer):void
		{
			_myIconUseCDProgressShape.graphics.clear();
			
			if(!simpleCd.getIsCDEnd())
			{
				_playedCDEndEffect = false;
				var angle:Number = simpleCd.getCDCoolDownPercent();
				_myIconUseCDProgressShape.graphics.beginFill(0, 1);
				_myIconUseCDProgressShape.graphics.drawRect( 0, 0, _greyIcon.width, _greyIcon.height * angle);
			}
			else
			{
				if ( !_playedCDEndEffect )
				{
					playCDResetEff();
					_playedCDEndEffect = true;
				}
			}
			
			_myIconUseCDProgressShape.graphics.endFill();
		}
	}
}