package com.odnoklassniki.sdk.errors 
{
	public class Errors
	{
		
		public static function showError(s:String):void 
		{
			throw new Error(s);
		}
		
	}

}