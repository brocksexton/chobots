package com.kavalok
{
	import com.kavalok.gameplay.KavalokConstants;
	
	import flash.data.EncryptedLocalStore;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	import mx.controls.List;
	import mx.core.WindowedApplication;
	import mx.events.ListEvent;
	
	import org.goverla.collections.ArrayList;
	import org.goverla.utils.Arrays;
	import org.goverla.utils.Objects;
	import org.goverla.utils.comparing.PropertyCompareRequirement;
	import org.goverla.utils.comparing.UniqueItemRequirement;
	import org.goverla.utils.converting.FunctionConverter;
	import org.goverla.utils.converting.ToPropertyValueConverter;

	public class LocalizationToolBase extends WindowedApplication
	{
		private static const WORKING_DIRECTORY : String = "workingDirectory";
		private static const XML_EXTENSION : String = "xml";
		
		public var filesList : List;
		
		[Bindable]
		protected var dataProvider : ArrayList;
		[Bindable]
		protected var files : ArrayList;
		
		private var _folder : File;
		private var _fileName : String;
		
		
		public function LocalizationToolBase()
		{
			super();
			var data : ByteArray = EncryptedLocalStore.getItem(WORKING_DIRECTORY);
			if(data != null)
			{
				navigateTo(new File(data.readUTFBytes(data.bytesAvailable)));
			}
			
		}
		
		protected function onSaveClick(event : MouseEvent) : void
		{
			for each(var locale : String in KavalokConstants.LOCALES)
			{
				var result : XML = <messages/>;
				for each(var item : Object in dataProvider)
				{
					result[item.name] = item[locale] || "";
				}
				var stream : FileStream = getStream(locale, FileMode.WRITE);
				stream.writeUTFBytes(String(result));
				stream.close();
			}	
		}
		
		protected function onFileClick(event : ListEvent) : void
		{
			loadLocalizations(Objects.castToString(filesList.selectedItem));
		}
		
		protected function onOpenFolderClick(event : MouseEvent) : void
		{
			_folder = new File();
			_folder.addEventListener(Event.SELECT, onDirectorySelect);
			_folder.browseForDirectory("Please select the directory with localization");
		}
		
		protected function onDirectorySelect(event : Event) : void
		{
			navigateTo(File(event.target));	
		}
		
		private function loadLocalizations(fileName : String) : void
		{
			_fileName = fileName;
			dataProvider = null;
			var newData : ArrayList = new ArrayList();
			for each(var locale : String in KavalokConstants.LOCALES)
			{
				var stream : FileStream = getStream(locale, FileMode.READ);
				
				var content : String = stream.readUTFBytes(stream.bytesAvailable);
				if(content.length == 0)
					continue;
				var xmlContent : XMLList = XMLList(content);
				addMessages(newData, xmlContent[1] || xmlContent[0], locale);
				stream.close();
			}
			dataProvider = newData;
		}
		
		private function getStream(locale : String, mode : String) : FileStream
		{
			var fullFileName : String = [_fileName, locale, XML_EXTENSION].join(".");
			var file : File = new File(_folder.url + "/" + fullFileName);
			var stream : FileStream = new FileStream();

			if(!file.exists)
			{
				stream.open(file, FileMode.WRITE);
				stream.close();
			}
			stream.open(file, mode); 	
			return stream;
		}
		
		private function addMessages(data : ArrayList, messages : XML, locale : String) : void
		{
			var req : PropertyCompareRequirement = new PropertyCompareRequirement("name", null);
			for each(var message : XML in messages.children())
			{
				req.propertyValue = String(message.name());
				var messageItem : Object = Arrays.safeFirstByRequirement(data, req);
				if(messageItem == null)
				{
					messageItem = {name : String(message.name())};
					data.addItem(messageItem);
				}
				messageItem[locale] = String(message.valueOf());
			}
		}
		
		private function navigateTo(directory : File) : void
		{
			if(!directory.exists)
				return;
				
			_folder = directory;
			var data : ByteArray = new ByteArray();
			data.writeUTFBytes(_folder.nativePath);
			EncryptedLocalStore.setItem(WORKING_DIRECTORY, data); 
			_folder.addEventListener(Event.SELECT, onDirectorySelect);
			
			var allFfiles : Array = _folder.getDirectoryListing();
			var localizationFiles : ArrayList = Arrays.getByRequirements(allFfiles
				, [new PropertyCompareRequirement("isDirectory", false), new PropertyCompareRequirement("extension", XML_EXTENSION)]);
			localizationFiles = Arrays.getConverted(localizationFiles, new ToPropertyValueConverter("name"));
			localizationFiles = Arrays.getConverted(localizationFiles, new FunctionConverter(getShortFileName));
			files = Arrays.getByRequirement(localizationFiles, new UniqueItemRequirement());
		}
		
		private function getShortFileName(fullName : String) : String
		{
			return fullName.split(".")[0];
		}
		
	}
}