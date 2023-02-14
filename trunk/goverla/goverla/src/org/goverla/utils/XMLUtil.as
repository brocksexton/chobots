package org.goverla.utils {

	import flash.xml.XMLNode;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import org.goverla.errors.XMLError;
	import org.goverla.utils.comparing.PropertyCompareRequirement;
	
	/**
	 * @author Sergey Kovalyov
	 */
	public class XMLUtil {
		
		public static var ELEMENT_NODE_TYPE : Number = 1;
	
		public static var TEXT_NODE_TYPE : Number = 3;
		
		public static var NODE_NAME_VALIDATION_REGULAR_EXPRESSION : String = "[A-Za-z_][A-Za-z0-9_-]*";

		public static function setAttribute(node : XMLNode, attribute : String, value : Object) : void {
			node.attributes[attribute] = value.valueOf().toString();
		}
		
		public static function getAttribute(node : XMLNode, attribute : String) : String {
			return String(node.attributes[attribute]);
		}
		
		public static function createElementNode(name : String) : XMLNode {
			return new XMLNode(ELEMENT_NODE_TYPE, name);
		}
		
		public static function createTextNode(value : String) : XMLNode {
			return new XMLNode(TEXT_NODE_TYPE, value);
		}
		
		/**
		 * Checking whether name is valid as node name. Actually this method does not
		 * fit W3C standards completely, so that it implements very simple verification
		 */
		
		public static function isValidNodeName(name : String) : Boolean {
			var matches : Array = name.match(NODE_NAME_VALIDATION_REGULAR_EXPRESSION);
			var result : Boolean = (matches != null && matches.length > 0);
			return result;
		}
		
		public static function getChildNodeByName(parent : XMLNode, name : String) : XMLNode {
			var requirement : PropertyCompareRequirement = new PropertyCompareRequirement("nodeName", name);
			var children : ArrayCollection = new ArrayCollection(parent.childNodes);
			var nodes : ArrayCollection = Arrays.getByRequirement(children, requirement);
			
			if(nodes.length == 0) {
				var format : String = "child node with name {0} doesn't exist\n in node {1}";
				throw new XMLError(StringUtil.substitute(format, name, parent.toString()));
			}
			
			var result : XMLNode = XMLNode(nodes.getItemAt(0));
			return result;
		}
	
		public static function XMLNodeToXml(node : XMLNode) : XML {
			return new XML(node.toString()); 
		}
	
	}

}