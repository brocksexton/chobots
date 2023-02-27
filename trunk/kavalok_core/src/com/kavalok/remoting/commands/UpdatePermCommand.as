package com.kavalok.remoting.commands
{
    import com.kavalok.Global;
    
    public class UpdatePermCommand extends ServerCommandBase
    {
        public function UpdatePermCommand()
        {
            super();
        }

        override public function execute():void
        {
            Global.charManager.permissions = parameter.toString();
        }
    }
}
