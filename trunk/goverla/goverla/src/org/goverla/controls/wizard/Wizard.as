package org.goverla.controls.wizard 
{
	
	import org.goverla.controls.wizard.common.WizardDataMap;
	import org.goverla.controls.wizard.errors.WizardError;
	import org.goverla.controls.wizard.interfaces.IWizardNavigation;
	import org.goverla.controls.wizard.interfaces.IWizardPage;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.containers.VBox;
	import mx.containers.ViewStack;
	import mx.core.Container;
	import mx.core.IUIComponent;
	import mx.events.IndexChangedEvent;

	/**
	* @author Tyutyunnyk Eugene
	* @author Maxym Hryniv
	*/
	public class Wizard extends VBox {

		private var _viewStack : ViewStack;
		
		private var _wizardBar : WizardBar;		
		
		private var _navigation : IWizardNavigation;

		private var _wizardData : WizardDataMap;
		
		public function Wizard() {
			super();
			_viewStack = new ViewStack();
			_wizardBar = new WizardBar();			
		} 		
		
		public function get selectedIndex() : int {
			return _viewStack.selectedIndex;
		}

		public function set selectedIndex(value : int) : void {
			_viewStack.selectedIndex = value;
			refreshButtons();
		}

		public function get selectedChild() : Container {
			return _viewStack.selectedChild;
		}

		public function set selectedChild(value : Container) : void {
			_viewStack.selectedChild = value;
		}

		public function get navigation() : IWizardNavigation {
			return _navigation;
		}

		public function set navigation(value : IWizardNavigation) : void {
			if(_navigation != null) {
				_navigation.back.removeListener(onBack);
				_navigation.next.removeListener(onNext);
			}
			_navigation = value;
			addNavigationListeners(_navigation);
		}
		
		public function back() : void {
			if(selectedIndex == 0) {
				throw new WizardError("Can't move back from '0' index");
			} 
			
			selectedIndex--;
		}

		public function next() : void {
			if(selectedIndex == _viewStack.numChildren - 1) {
				throw new WizardError("Can't move back from '0' index");
			} 
			
			selectedIndex++;
			setEnabledCurrentComponent();
		}
		
		public function setEnabledCurrentComponent() : void {
			IUIComponent(_viewStack.getChildAt(selectedIndex)).enabled = true;
		}
		
		public function get wizardData() : WizardDataMap {
			if(_wizardData == null) {
				_wizardData = new WizardDataMap();
			}
			return _wizardData;
		}
		
		override public function initialize():void {
			super.initialize();
			_viewStack.percentHeight = 100;
			_viewStack.percentWidth = 100;
			_viewStack.addEventListener(IndexChangedEvent.CHANGE, onViewStackIndexChange);
			_viewStack.resizeToContent = true;
			
			_wizardBar.dataProvider = _viewStack;
			addChild(_wizardBar);
			addChild(_viewStack);
		}
		
		override public function addChild(child:DisplayObject):DisplayObject {
			var result : DisplayObject;
			if(child != _viewStack && child != _wizardBar) {
				result = _viewStack.addChild(child);
				if(child is IWizardPage) {
					IWizardPage(child).wizardData = wizardData;
				}
				
				if(child is IWizardNavigation) {
					addNavigationListeners(IWizardNavigation(child));
				}

			} else {
				result = super.addChild(child);
			}
			
			refreshButtons();
			return result;
		}
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			var result : DisplayObject = _viewStack.removeChild(child);
			if(child is IWizardPage) {
				IWizardPage(child).wizardData = null;
			}
			
			if(child is IWizardNavigation) {
				removeNavigationListeners(IWizardNavigation(child));
			}
			return result;
		} 

		override public function contains(child:DisplayObject):Boolean {
			return _viewStack.contains(child);
		}
		
		private function refreshButtons() : void {
			if(navigation != null) {
				navigation.backEnabled = true;
				navigation.nextEnabled = true;
				
				if(selectedIndex == _viewStack.numChildren - 1) {
					navigation.nextEnabled = false;
				}
				if(selectedIndex == 0) {
					navigation.backEnabled = false;
				}
			}
			
		}
		
		private function addNavigationListeners(navigation : IWizardNavigation) : void {
			navigation.next.addListener(onNext);
			navigation.back.addListener(onBack);
		}

		private function removeNavigationListeners(navigation : IWizardNavigation) : void {
			navigation.next.removeListener(onNext);
			navigation.back.removeListener(onBack);
		}
		
		private function onBack(event : Event) : void {
			back();
		} 

		private function onNext(event : Event) : void {
			next();
		} 
		
		private function onViewStackIndexChange(event : IndexChangedEvent) : void {
			if(_viewStack.getChildAt(event.oldIndex) is IWizardPage) {
				IWizardPage(_viewStack.getChildAt(event.oldIndex)).hide();
			}
			if(_viewStack.getChildAt(event.newIndex) is IWizardPage) {
				IWizardPage(_viewStack.getChildAt(event.newIndex)).show();
			}
			refreshButtons();
		}
		
	}
}