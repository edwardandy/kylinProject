package mainModule.controller.netCmds.httpCmds
{
	import kylin.echo.edward.framwork.controller.KylinCommand;
	
	import mainModule.controller.uiCmds.UIPanelEvent;
	import mainModule.model.gameData.dynamicData.interfaces.IDynamicDataDictionaryModel;
	import mainModule.model.panelData.PanelNameConst;
	import mainModule.service.netServices.httpServices.HttpRequestParam;
	import mainModule.service.netServices.httpServices.interfaces.IHttpRequestService;

	/**
	 * Http请求和响应处理 
	 * @author Edward
	 * 
	 */	
	public class HttpCmd extends KylinCommand
	{
		[Inject]
		public var event:HttpEvent;
		[Inject]
		public var httpService:IHttpRequestService;
		[Inject]
		public var dynamicDatas:IDynamicDataDictionaryModel;
		/**
		 * 请求参数 
		 */		
		protected var requestParam:HttpRequestParam;
		/**
		 * 服务器响应返回的数据 
		 */		
		protected var arrResponseData:Array;
				
		public function HttpCmd()
		{
			super();
		}
		/**
		 * 请求过程中是否需要弹出等待面板 
		 * @return 
		 * 
		 */		
		protected function get bNeedWaiting():Boolean
		{
			return requestParam && requestParam.bInQueue && requestParam.bNeedRespon;
		}

		override public function execute():void
		{
			super.execute();
			switch(event.iHttpType)
			{
				case HttpEvent.Type_Request:
					request();
					break;
				case HttpEvent.Type_RequestError:
					requestError();
					break;
				case HttpEvent.Type_Response:
					response();
					break;
				case HttpEvent.Type_RequestBeSend:
					requestBeSend();
					break;
				case HttpEvent.Type_ResponseError:
					responseError();
					break;
			}
		}
		/**
		 * 执行请求服务器 
		 * 
		 */		
		protected function request():void
		{
			requestParam = new HttpRequestParam;
			requestParam.responseEventType = event.type;	
			
			initRequestParam();
			
			if(bNeedWaiting)
				dispatch(new UIPanelEvent(UIPanelEvent.UI_OpenPanel,PanelNameConst.WaitingPanel));
			
			httpService.requestServer(requestParam);
		}
		/**
		 * 初始化发送请求数据 
		 * 
		 */		
		protected function initRequestParam():void
		{
			
		}
		/**
		 * 发送请求失败，安全或IO错误等服务器无响应 
		 * 
		 */		
		protected function requestError():void
		{
			var errorMsg:String = (event.body as Array)[0];
			requestParam = (event.body as Array)[1];
			
			if(bNeedWaiting)
				dispatch(new UIPanelEvent(UIPanelEvent.UI_ClosePanel,PanelNameConst.WaitingPanel));
		}
		/**
		 * 请求已经被发出 
		 * 
		 */		
		protected function requestBeSend():void
		{
			requestParam = (event.body as Array)[0];
		}
		/**
		 * 服务器响应成功并返回数据 
		 * 
		 */		
		protected function response():void
		{
			arrResponseData = (event.body as Array)[0];
			parseResponseData();
			
			requestParam = (event.body as Array)[1];
			if(bNeedWaiting)
				dispatch(new UIPanelEvent(UIPanelEvent.UI_ClosePanel,PanelNameConst.WaitingPanel));
		}
		/**
		 * 更新动态数据 
		 * 
		 */		
		private function parseResponseData():void
		{
			if(!arrResponseData || 0 == arrResponseData.length || !arrResponseData[0] || !arrResponseData[0].dynamic)
				return;
			dynamicDatas.updateModels(arrResponseData[0].dynamic);
		}
		/**
		 * 服务器响应但是返回错误代码 
		 * 
		 */		
		protected function responseError():void
		{
			var errorCode:int = (event.body as Array)[0];
			requestParam = (event.body as Array)[1];
			if(bNeedWaiting)
				dispatch(new UIPanelEvent(UIPanelEvent.UI_ClosePanel,PanelNameConst.WaitingPanel));
		}
	}
}