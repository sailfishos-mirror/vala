/* javascriptcoregtk-4.0.vapi generated by vapigen, do not modify. */

[CCode (cprefix = "JS", gir_namespace = "JavaScript", gir_version = "4.0", lower_case_cprefix = "JS_")]
[Version (deprecated = true, deprecated_since = "2.22")]
namespace JS {
	[CCode (cheader_filename = "JavaScriptCore/JavaScript.h", cname = "void", free_function = "JSClassRelease", has_type_id = false)]
	[Compact]
	public class Class {
		[CCode (cname = "JSClassRelease")]
		[DestroysInstance]
		public void release ();
		[CCode (cname = "JSClassRetain")]
		public JS.Class retain ();
	}
	[CCode (cheader_filename = "JavaScriptCore/JavaScript.h", cname = "const struct OpaqueJSContext", free_function = "", has_type_id = false)]
	[Compact]
	public class Context {
		[CCode (cname = "JSCheckScriptSyntax")]
		public bool check_script_syntax (JS.String script, JS.String? source_url = null, int starting_line_number = 1, out JS.Value? exception = null);
		[CCode (cname = "JSGarbageCollect")]
		public void collect_garbage ();
		[CCode (cname = "JSEvaluateScript")]
		public unowned JS.Value? evaluate_script (JS.String script, JS.Object? this_object = null, JS.String? source_url = null, int starting_line_number = 1, out JS.Value? exception = null);
	}
	[CCode (cheader_filename = "JavaScriptCore/JavaScript.h", cname = "struct OpaqueJSContext", free_function = "JSGlobalContextRelease", has_type_id = false)]
	[Compact]
	public class GlobalContext : JS.Context {
		[CCode (cname = "JSGlobalContextCreate")]
		public GlobalContext (JS.Class? global_object_class = null);
		[CCode (cname = "JSGlobalContextRelease")]
		[DestroysInstance]
		public void release ();
		[CCode (cname = "JSGlobalContextRetain")]
		public JS.GlobalContext retain ();
	}
	[CCode (cheader_filename = "JavaScriptCore/JavaScript.h", cname = "struct OpaqueJSValue", free_function = "", has_type_id = false)]
	[Compact]
	public class Object {
		[CCode (cname = "JSObjectCallAsFunction", instance_pos = 1.1)]
		public JS.Value call_as_function (JS.Context ctx, JS.Object? this_object, [CCode (array_length_pos = 2.5)] JS.Value[]? arguments, out JS.Value? exception);
		[CCode (cname = "JSObjectGetProperty", instance_pos = 1.1)]
		public JS.Value get_property (JS.Context ctx, JS.String property_name, out JS.Value? exception);
		[CCode (cname = "JSObjectHasProperty", instance_pos = 1.1)]
		public bool has_property (JS.Context ctx, JS.String property_name);
		[CCode (cname = "JSObjectMakeFunction")]
		public Object.make_function (JS.String? name, [CCode (array_length_pos = 1.5)] JS.String[]? parameter_names, JS.String body, JS.String? source_url, int starting_line_number, out JS.Value? exception);
	}
	[CCode (cheader_filename = "JavaScriptCore/JavaScript.h", cname = "struct OpaqueJSString", free_function = "JSStringRelease", has_type_id = false)]
	[Compact]
	public class String {
		[CCode (cname = "JSStringCreateWithUTF8CString")]
		public String.create_with_utf8_cstring (string str);
		[CCode (cname = "JSStringGetLength")]
		public size_t get_length ();
		[CCode (cname = "JSStringGetMaximumUTF8CStringSize")]
		public size_t get_maximum_utf8_cstring_size ();
		[CCode (cname = "JSStringGetUTF8CString")]
		public size_t get_utf8_cstring ([CCode (array_length_type = "gsize")] uint8[] buffer);
		[CCode (cname = "JSStringIsEqual")]
		public bool is_equal (JS.String b);
		[CCode (cname = "JSStringIsEqualToUTF8CString")]
		public bool is_equal_to_utf8_cstring (string b);
		[CCode (cname = "JSStringRelease")]
		[DestroysInstance]
		public void release ();
		[CCode (cname = "JSStringRetain")]
		public JS.String retain ();
	}
	[CCode (cheader_filename = "JavaScriptCore/JavaScript.h", cname = "const struct OpaqueJSValue", free_function = "", has_type_id = false)]
	[Compact]
	public class Value {
		[CCode (cname = "JSValueGetType", instance_pos = 1.1)]
		public JS.Type get_type (JS.Context ctx);
		[CCode (cname = "JSValueGetTypedArrayType", instance_pos = 1.1)]
		public JS.TypedArrayType get_typed_array_type (JS.Context ctx);
		[CCode (cname = "JSValueIsArray", instance_pos = 1.1)]
		public bool is_array (JS.Context ctx);
		[CCode (cname = "JSValueIsBoolean", instance_pos = 1.1)]
		public bool is_boolean (JS.Context ctx);
		[CCode (cname = "JSValueIsDate", instance_pos = 1.1)]
		public bool is_date (JS.Context ctx);
		[CCode (cname = "JSValueIsEqual", instance_pos = 1.1)]
		public bool is_equal (JS.Context ctx, JS.Value b, out JS.Value? exception = null);
		[CCode (cname = "JSValueIsNull", instance_pos = 1.1)]
		public bool is_null (JS.Context ctx);
		[CCode (cname = "JSValueIsNumber", instance_pos = 1.1)]
		public bool is_number (JS.Context ctx);
		[CCode (cname = "JSValueIsObject", instance_pos = 1.1)]
		public bool is_object (JS.Context ctx);
		[CCode (cname = "JSValueIsObjectOfClass", instance_pos = 1.1)]
		public bool is_object_of_class (JS.Context ctx, JS.Class js_class);
		[CCode (cname = "JSValueIsStrictEqual", instance_pos = 1.1)]
		public bool is_strict_equal (JS.Context ctx, JS.Value b);
		[CCode (cname = "JSValueIsString", instance_pos = 1.1)]
		public bool is_string (JS.Context ctx);
		[CCode (cname = "JSValueIsUndefined", instance_pos = 1.1)]
		public bool is_undefined (JS.Context ctx);
		[CCode (cname = "JSValueProtect", instance_pos = 1.1)]
		public void protect (JS.Context ctx);
		[CCode (cname = "JSValueToBoolean", instance_pos = 1.1)]
		public bool to_boolean (JS.Context ctx);
		[CCode (cname = "JSValueToNumber", instance_pos = 1.1)]
		public double to_number (JS.Context ctx, out JS.Value? exception = null);
		[CCode (cname = "JSValueToObject", instance_pos = 1.1)]
		public JS.Object to_object (JS.Context ctx, out JS.Value? exception = null);
		[CCode (cname = "JSValueToStringCopy", instance_pos = 1.1)]
		public JS.String to_string_copy (JS.Context ctx, out JS.Value? exception = null);
		[CCode (cname = "JSValueUnprotect", instance_pos = 1.1)]
		public void unprotect (JS.Context ctx);
	}
	[CCode (cheader_filename = "JavaScriptCore/JavaScript.h", cname = "JSType", has_type_id = false)]
	public enum Type {
		[CCode (cname = "kJSTypeUndefined")]
		UNDEFINED,
		[CCode (cname = "kJSTypeNull")]
		NULL,
		[CCode (cname = "kJSTypeBoolean")]
		BOOLEAN,
		[CCode (cname = "kJSTypeNumber")]
		NUMBER,
		[CCode (cname = "kJSTypeString")]
		STRING,
		[CCode (cname = "kJSTypeObject")]
		OBJECT
	}
	[CCode (cheader_filename = "JavaScriptCore/JavaScript.h", cname = "JSTypedArrayType", has_type_id = false)]
	public enum TypedArrayType {
		[CCode (cname = "kJSTypedArrayTypeInt8Array")]
		INT8,
		[CCode (cname = "kJSTypedArrayTypeInt16Array")]
		INT16,
		[CCode (cname = "kJSTypedArrayTypeInt32Array")]
		INT32,
		[CCode (cname = "kJSTypedArrayTypeUint8Array")]
		UINT8,
		[CCode (cname = "kJSTypedArrayTypeUint8ClampedArray")]
		UINT8_CLAMPED,
		[CCode (cname = "kJSTypedArrayTypeUint16Array")]
		UINT16,
		[CCode (cname = "kJSTypedArrayTypeUint32Array")]
		UINT32,
		[CCode (cname = "kJSTypedArrayTypeFloat32Array")]
		FLOAT32,
		[CCode (cname = "kJSTypedArrayTypeFloat64Array")]
		FLOAT64,
		[CCode (cname = "kJSTypedArrayTypeArrayBuffer")]
		BUFFER,
		[CCode (cname = "kJSTypedArrayTypeNone")]
		NONE
	}
}
[CCode (cprefix = "JSC", gir_namespace = "JavaScriptCore", gir_version = "4.0", lower_case_cprefix = "jsc_")]
namespace JSC {
	[CCode (cheader_filename = "jsc/jsc.h", type_id = "jsc_class_get_type ()")]
	public class Class : GLib.Object {
		[CCode (has_construct_function = false)]
		protected Class ();
		public JSC.Value add_constructor_variadic (string? name, [CCode (delegate_target_pos = 2.33333, destroy_notify_pos = 2.66667)] owned GLib.Callback callback, GLib.Type return_type);
		public JSC.Value add_constructorv (string? name, [CCode (delegate_target_pos = 2.33333, destroy_notify_pos = 2.66667)] owned GLib.Callback callback, GLib.Type return_type, [CCode (array_length_cname = "n_parameters", array_length_pos = 3.5, array_length_type = "guint")] GLib.Type[]? parameter_types);
		public void add_method_variadic (string name, [CCode (delegate_target_pos = 2.33333, destroy_notify_pos = 2.66667)] owned GLib.Callback callback, GLib.Type return_type);
		public void add_methodv (string name, [CCode (delegate_target_pos = 2.33333, destroy_notify_pos = 2.66667)] owned GLib.Callback callback, GLib.Type return_type, [CCode (array_length_cname = "n_parameters", array_length_pos = 3.5, array_length_type = "guint")] GLib.Type[]? parameter_types);
		public void add_property (string name, GLib.Type property_type, [CCode (scope = "async")] GLib.Callback? getter, [CCode (scope = "async")] GLib.Callback? setter, void* user_data, GLib.DestroyNotify? destroy_notify);
		public unowned string get_name ();
		public unowned JSC.Class get_parent ();
		[NoAccessorMethod]
		public JSC.Context context { owned get; construct; }
		public string name { get; construct; }
		public JSC.Class parent { get; construct; }
	}
	[CCode (cheader_filename = "jsc/jsc.h", type_id = "jsc_context_get_type ()")]
	public class Context : GLib.Object {
		[CCode (has_construct_function = false)]
		public Context ();
		public JSC.CheckSyntaxResult check_syntax (string code, ssize_t length, JSC.CheckSyntaxMode mode, string uri, uint line_number, out JSC.Exception exception);
		public void clear_exception ();
		public JSC.Value evaluate (string code, ssize_t length);
		public JSC.Value evaluate_in_object (string code, ssize_t length, void* object_instance, JSC.Class? object_class, string uri, uint line_number, out JSC.Value object);
		public JSC.Value evaluate_with_source_uri (string code, ssize_t length, string uri, uint line_number);
		public static unowned JSC.Context? get_current ();
		public unowned JSC.Exception? get_exception ();
		public JSC.Value get_global_object ();
		public JSC.Value get_value (string name);
		public unowned JSC.VirtualMachine get_virtual_machine ();
		public void pop_exception_handler ();
		public void push_exception_handler (owned JSC.ExceptionHandler handler);
		public unowned JSC.Class register_class (string name, JSC.Class? parent_class, JSC.ClassVTable? vtable, GLib.DestroyNotify? destroy_notify);
		public void set_value (string name, JSC.Value value);
		public void @throw (string error_message);
		public void throw_exception (JSC.Exception exception);
		[CCode (has_construct_function = false)]
		public Context.with_virtual_machine (JSC.VirtualMachine vm);
		public JSC.VirtualMachine virtual_machine { get; construct; }
	}
	[CCode (cheader_filename = "jsc/jsc.h", type_id = "jsc_exception_get_type ()")]
	public class Exception : GLib.Object {
		[CCode (has_construct_function = false)]
		public Exception (JSC.Context context, string message);
		public uint get_line_number ();
		public unowned string get_message ();
		public unowned string? get_source_uri ();
	}
	[CCode (cheader_filename = "jsc/jsc.h", type_id = "jsc_value_get_type ()")]
	public class Value : GLib.Object {
		[CCode (has_construct_function = false)]
		protected Value ();
		[CCode (has_construct_function = false)]
		public Value.array_from_garray (JSC.Context context, GLib.GenericArray<JSC.Value>? array);
		[CCode (has_construct_function = false)]
		public Value.array_from_strv (JSC.Context context, [CCode (array_length = false, array_null_terminated = true)] global::string[] strv);
		[CCode (has_construct_function = false)]
		public Value.boolean (JSC.Context context, bool value);
		public JSC.Value constructor_callv ([CCode (array_length_cname = "n_parameters", array_length_pos = 0.5, array_length_type = "guint")] JSC.Value[]? parameters);
		public JSC.Value function_callv ([CCode (array_length_cname = "n_parameters", array_length_pos = 0.5, array_length_type = "guint")] JSC.Value[]? parameters);
		[CCode (has_construct_function = false)]
		public Value.function_variadic (JSC.Context context, global::string? name, [CCode (delegate_target_pos = 3.33333, destroy_notify_pos = 3.66667)] owned GLib.Callback callback, GLib.Type return_type);
		[CCode (has_construct_function = false)]
		public Value.functionv (JSC.Context context, global::string? name, [CCode (delegate_target_pos = 3.33333, destroy_notify_pos = 3.66667)] owned GLib.Callback callback, GLib.Type return_type, [CCode (array_length_cname = "n_parameters", array_length_pos = 4.5, array_length_type = "guint")] GLib.Type[]? parameter_types);
		public unowned JSC.Context get_context ();
		public bool is_array ();
		public bool is_boolean ();
		public bool is_constructor ();
		public bool is_function ();
		public bool is_null ();
		public bool is_number ();
		public bool is_object ();
		public bool is_string ();
		public bool is_undefined ();
		[CCode (has_construct_function = false)]
		public Value.@null (JSC.Context context);
		[CCode (has_construct_function = false)]
		public Value.number (JSC.Context context, double number);
		[CCode (has_construct_function = false)]
		public Value.object (JSC.Context context, void* instance, JSC.Class? jsc_class);
		public void object_define_property_accessor (global::string property_name, JSC.ValuePropertyFlags flags, GLib.Type property_type, [CCode (scope = "async")] GLib.Callback? getter, [CCode (scope = "async")] GLib.Callback? setter, void* user_data, GLib.DestroyNotify? destroy_notify);
		public void object_define_property_data (global::string property_name, JSC.ValuePropertyFlags flags, JSC.Value? property_value);
		public bool object_delete_property (global::string name);
		[CCode (array_length = false, array_null_terminated = true)]
		public global::string[]? object_enumerate_properties ();
		public JSC.Value object_get_property (global::string name);
		public JSC.Value object_get_property_at_index (uint index);
		public bool object_has_property (global::string name);
		public JSC.Value object_invoke_methodv (global::string name, [CCode (array_length_cname = "n_parameters", array_length_pos = 1.5, array_length_type = "guint")] JSC.Value[]? parameters);
		public bool object_is_instance_of (global::string name);
		public void object_set_property (global::string name, JSC.Value property);
		public void object_set_property_at_index (uint index, JSC.Value property);
		[CCode (has_construct_function = false)]
		public Value.string (JSC.Context context, global::string? string);
		[CCode (has_construct_function = false)]
		public Value.string_from_bytes (JSC.Context context, GLib.Bytes? bytes);
		public bool to_boolean ();
		public double to_double ();
		public int32 to_int32 ();
		public global::string to_string ();
		public GLib.Bytes to_string_as_bytes ();
		[CCode (has_construct_function = false)]
		public Value.undefined (JSC.Context context);
		public JSC.Context context { get; construct; }
	}
	[CCode (cheader_filename = "jsc/jsc.h", type_id = "jsc_virtual_machine_get_type ()")]
	public class VirtualMachine : GLib.Object {
		[CCode (has_construct_function = false)]
		public VirtualMachine ();
	}
	[CCode (cheader_filename = "jsc/jsc.h", type_id = "jsc_weak_value_get_type ()")]
	public class WeakValue : GLib.Object {
		[CCode (has_construct_function = false)]
		public WeakValue (JSC.Value value);
		public JSC.Value get_value ();
		[NoAccessorMethod]
		public JSC.Value value { construct; }
		public signal void cleared ();
	}
	[CCode (cheader_filename = "jsc/jsc.h", has_type_id = false)]
	public struct ClassVTable {
		public weak JSC.ClassGetPropertyFunction get_property;
		public weak JSC.ClassSetPropertyFunction set_property;
		public weak JSC.ClassHasPropertyFunction has_property;
		public weak JSC.ClassDeletePropertyFunction delete_property;
		public weak JSC.ClassEnumeratePropertiesFunction enumerate_properties;
	}
	[CCode (cheader_filename = "jsc/jsc.h", cprefix = "JSC_CHECK_SYNTAX_MODE_", has_type_id = false)]
	public enum CheckSyntaxMode {
		SCRIPT,
		MODULE
	}
	[CCode (cheader_filename = "jsc/jsc.h", cprefix = "JSC_CHECK_SYNTAX_RESULT_", has_type_id = false)]
	public enum CheckSyntaxResult {
		SUCCESS,
		RECOVERABLE_ERROR,
		IRRECOVERABLE_ERROR,
		UNTERMINATED_LITERAL_ERROR,
		OUT_OF_MEMORY_ERROR,
		STACK_OVERFLOW_ERROR
	}
	[CCode (cheader_filename = "jsc/jsc.h", cprefix = "JSC_VALUE_PROPERTY_", has_type_id = false)]
	[Flags]
	public enum ValuePropertyFlags {
		CONFIGURABLE,
		ENUMERABLE,
		WRITABLE
	}
	[CCode (cheader_filename = "jsc/jsc.h", has_target = false)]
	public delegate bool ClassDeletePropertyFunction (JSC.Class jsc_class, JSC.Context context, void* instance, string name);
	[CCode (array_length = false, array_null_terminated = true, cheader_filename = "jsc/jsc.h", has_target = false)]
	public delegate string[]? ClassEnumeratePropertiesFunction (JSC.Class jsc_class, JSC.Context context, void* instance);
	[CCode (cheader_filename = "jsc/jsc.h", has_target = false)]
	public delegate JSC.Value? ClassGetPropertyFunction (JSC.Class jsc_class, JSC.Context context, void* instance, string name);
	[CCode (cheader_filename = "jsc/jsc.h", has_target = false)]
	public delegate bool ClassHasPropertyFunction (JSC.Class jsc_class, JSC.Context context, void* instance, string name);
	[CCode (cheader_filename = "jsc/jsc.h", has_target = false)]
	public delegate bool ClassSetPropertyFunction (JSC.Class jsc_class, JSC.Context context, void* instance, string name, JSC.Value value);
	[CCode (cheader_filename = "jsc/jsc.h", instance_pos = 2.9)]
	public delegate void ExceptionHandler (JSC.Context context, JSC.Exception exception);
	[CCode (cheader_filename = "jsc/jsc.h", cname = "JSC_MAJOR_VERSION")]
	public const int MAJOR_VERSION;
	[CCode (cheader_filename = "jsc/jsc.h", cname = "JSC_MICRO_VERSION")]
	public const int MICRO_VERSION;
	[CCode (cheader_filename = "jsc/jsc.h", cname = "JSC_MINOR_VERSION")]
	public const int MINOR_VERSION;
	[CCode (cheader_filename = "jsc/jsc.h")]
	public static uint get_major_version ();
	[CCode (cheader_filename = "jsc/jsc.h")]
	public static uint get_micro_version ();
	[CCode (cheader_filename = "jsc/jsc.h")]
	public static uint get_minor_version ();
}
