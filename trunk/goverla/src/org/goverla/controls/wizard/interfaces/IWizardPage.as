package org.goverla.controls.wizard.interfaces
{
	import org.goverla.controls.wizard.common.WizardDataMap;
	
	public interface IWizardPage {
		
		function set wizardData(value : WizardDataMap) : void;
		function show() : void;
		function hide() : void;
		
	}
}