package mainModule.service.netServices.httpServices.interfaces
{
	import mainModule.service.netServices.httpServices.HttpRequestParam;

	/**
	 * 请求Http服务器操作
	 * @author Edward
	 * 
	 */	
	public interface IHttpRequestService
	{
		/**
		 * 请求http服务器 
		 * @param param 处理请求的参数，包括前端和服务器所需的
		 * 
		 */		
		function requestServer(param:HttpRequestParam):void;
	}
}