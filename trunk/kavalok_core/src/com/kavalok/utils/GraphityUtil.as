package com.kavalok.utils {
 /**
 * @Author : Ethan McMullan
 */

  import com.kavalok.Global;
  import com.kavalok.services.AdminService;
  
  public class GraphityUtil{
  
  public var graphityIsEnabled:Boolean = false;
  
   public function GraphityUtil()
   {
     super();
     new AdminService(onGetResult).getWorldConfig();
   }
  
   private function onGetResult(result:Object) : void
   {
     graphityIsEnabled = result.drawingEnabled;
	 Global.graphityEnabled = result.drawingEnabled;
	 trace("GRAPHITY RESULT: " + graphityIsEnabled.toString());
   }
  
   public function get checkGraphity() : Boolean
   {
     return graphityIsEnabled;
   }
   
   public function loadGraphity() : void
   {
     new AdminService(onGetResult).getWorldConfig();
   }
   
  }
}