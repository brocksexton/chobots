package ChoData {
	import com.netease.protobuf.*;
	use namespace com.netease.protobuf.used_by_generated_code;
	import com.netease.protobuf.fieldDescriptors.*;
	import flash.utils.Endian;
	import flash.utils.IDataInput;
	import flash.utils.IDataOutput;
	import flash.utils.IExternalizable;
	import flash.errors.IOError;
	// @@protoc_insertion_point(imports)

	// @@protoc_insertion_point(class_metadata)
	public dynamic final class FishInfo extends com.netease.protobuf.Message {
		/**
		 *  @private
		 */
		public static const ID:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("ChoData.FishInfo.id", "id", (1 << 3) | com.netease.protobuf.WireType.VARINT);

		public var id:int;

		/**
		 *  @private
		 */
		public static const R:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("ChoData.FishInfo.r", "r", (2 << 3) | com.netease.protobuf.WireType.VARINT);

		public var r:int;

		/**
		 *  @private
		 */
		public static const P:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("ChoData.FishInfo.p", "p", (3 << 3) | com.netease.protobuf.WireType.VARINT);

		public var p:int;

		/**
		 *  @private
		 */
		public static const IT:FieldDescriptor$TYPE_BOOL = new FieldDescriptor$TYPE_BOOL("ChoData.FishInfo.it", "it", (4 << 3) | com.netease.protobuf.WireType.VARINT);

		public var it:Boolean;

		/**
		 *  @private
		 */
		public static const DN:FieldDescriptor$TYPE_INT32 = new FieldDescriptor$TYPE_INT32("ChoData.FishInfo.dn", "dn", (5 << 3) | com.netease.protobuf.WireType.VARINT);

		public var dn:int;

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function writeToBuffer(output:com.netease.protobuf.WritingBuffer):void {
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 1);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.id);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 2);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.r);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 3);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.p);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 4);
			com.netease.protobuf.WriteUtils.write$TYPE_BOOL(output, this.it);
			com.netease.protobuf.WriteUtils.writeTag(output, com.netease.protobuf.WireType.VARINT, 5);
			com.netease.protobuf.WriteUtils.write$TYPE_INT32(output, this.dn);
			for (var fieldKey:* in this) {
				super.writeUnknown(output, fieldKey);
			}
		}

		/**
		 *  @private
		 */
		override com.netease.protobuf.used_by_generated_code final function readFromSlice(input:flash.utils.IDataInput, bytesAfterSlice:uint):void {
			var id$count:uint = 0;
			var r$count:uint = 0;
			var p$count:uint = 0;
			var it$count:uint = 0;
			var dn$count:uint = 0;
			while (input.bytesAvailable > bytesAfterSlice) {
				var tag:uint = com.netease.protobuf.ReadUtils.read$TYPE_UINT32(input);
				switch (tag >> 3) {
				case 1:
					if (id$count != 0) {
						throw new flash.errors.IOError('Bad data format: FishInfo.id cannot be set twice.');
					}
					++id$count;
					this.id = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 2:
					if (r$count != 0) {
						throw new flash.errors.IOError('Bad data format: FishInfo.r cannot be set twice.');
					}
					++r$count;
					this.r = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 3:
					if (p$count != 0) {
						throw new flash.errors.IOError('Bad data format: FishInfo.p cannot be set twice.');
					}
					++p$count;
					this.p = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				case 4:
					if (it$count != 0) {
						throw new flash.errors.IOError('Bad data format: FishInfo.it cannot be set twice.');
					}
					++it$count;
					this.it = com.netease.protobuf.ReadUtils.read$TYPE_BOOL(input);
					break;
				case 5:
					if (dn$count != 0) {
						throw new flash.errors.IOError('Bad data format: FishInfo.dn cannot be set twice.');
					}
					++dn$count;
					this.dn = com.netease.protobuf.ReadUtils.read$TYPE_INT32(input);
					break;
				default:
					super.readUnknown(input, tag);
					break;
				}
			}
		}

	}
}
