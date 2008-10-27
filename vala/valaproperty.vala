/* valaproperty.vala
 *
 * Copyright (C) 2006-2008  Jürg Billeter
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.

 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.

 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301  USA
 *
 * Author:
 * 	Jürg Billeter <j@bitron.ch>
 *	Raffaele Sandrini <raffaele@sandrini.ch>
 */

using GLib;

/**
 * Represents a property declaration in the source code.
 */
public class Vala.Property : Member, Lockable {
	/**
	 * The property type.
	 */
	public DataType? property_type {
		get { return _data_type; }
		set {
			_data_type = value;
			_data_type.parent_node = this;
		}
	}
	
	/**
	 * The get accessor of this property if available.
	 */
	public PropertyAccessor? get_accessor { get; set; }
	
	/**
	 * The set/construct accessor of this property if available.
	 */
	public PropertyAccessor? set_accessor { get; set; }
	
	/**
	 * Represents the generated ´this' parameter in this property.
	 */
	public FormalParameter this_parameter { get; set; }

	/**
	 * Specifies whether a `notify' signal should be emitted on property
	 * changes.
	 */
	public bool notify { get; set; default = true; }

	/**
	 * Specifies whether the implementation of this property does not
	 * provide getter/setter methods.
	 */
	public bool no_accessor_method { get; set; }
	
	/**
	 * Specifies whether automatic accessor code generation should be
	 * disabled.
	 */
	public bool interface_only { get; set; }
	
	/**
	 * Specifies whether this property is abstract. Abstract properties have
	 * no accessor bodies, may only be specified within abstract classes and
	 * interfaces, and must be overriden by derived non-abstract classes.
	 */
	public bool is_abstract { get; set; }
	
	/**
	 * Specifies whether this property is virtual. Virtual properties may be
	 * overridden by derived classes.
	 */
	public bool is_virtual { get; set; }
	
	/**
	 * Specifies whether this property overrides a virtual or abstract
	 * property of a base type.
	 */
	public bool overrides { get; set; }

	/**
	 * Reference the the Field that holds this property
	 */
	public Field field { get; set; }

	/**
	 * Specifies whether this field may only be accessed with an instance of
	 * the contained type.
	 */
	public MemberBinding binding { get; set; default = MemberBinding.INSTANCE; }

	/**
	 * Specifies the virtual or abstract property this property overrides.
	 * Reference must be weak as virtual properties set base_property to
	 * themselves.
	 */
	public Property base_property {
		get {
			find_base_properties ();
			return _base_property;
		}
	}
	
	/**
	 * Specifies the abstract interface property this property implements.
	 */
	public Property base_interface_property {
		get {
			find_base_properties ();
			return _base_interface_property;
		}
	}

	/**
	 * Specifies the default value of this property.
	 */
	public Expression default_expression { get; set; }

	/**
	 * Nickname of this property.
	 */
	public string nick {
		get {
			if (_nick == null) {
				_nick = get_canonical_name ();
			}
			return _nick;
		}
		set { _nick = value; }
	}

	/**
	 * The long description of this property.
	 */
	public string blurb {
		get {
			if (_blurb == null) {
				_blurb = get_canonical_name ();
			}
			return _blurb;
		}
		set { _blurb = value; }
	}

	private bool lock_used = false;

	private DataType _data_type;

	private string? _nick;
	private string? _blurb;

	private weak Property _base_property;
	private Property _base_interface_property;
	private bool base_properties_valid;

	/**
	 * Creates a new property.
	 *
	 * @param name         property name
	 * @param type         property type
	 * @param get_accessor get accessor
	 * @param set_accessor set/construct accessor
	 * @param source       reference to source code
	 * @return             newly created property
	 */
	public Property (string name, DataType? property_type, PropertyAccessor? get_accessor, PropertyAccessor? set_accessor, SourceReference? source_reference = null) {
		base (name, source_reference);
		this.property_type = property_type;
		this.get_accessor = get_accessor;
		this.set_accessor = set_accessor;
	}

	public override void accept (CodeVisitor visitor) {
		visitor.visit_member (this);

		visitor.visit_property (this);
	}

	public override void accept_children (CodeVisitor visitor) {
		property_type.accept (visitor);
		
		if (get_accessor != null) {
			get_accessor.accept (visitor);
		}
		if (set_accessor != null) {
			set_accessor.accept (visitor);
		}

		if (default_expression != null) {
			default_expression.accept (visitor);
		}
	}

	/**
	 * Returns the C name of this property in upper case. Words are
	 * separated by underscores. The upper case C name of the class is
	 * prefix of the result.
	 *
	 * @return the upper case name to be used in C code
	 */
	public string get_upper_case_cname () {
		return "%s_%s".printf (parent_symbol.get_lower_case_cname (null), camel_case_to_lower_case (name)).up ();
	}
	
	/**
	 * Returns the string literal of this property to be used in C code.
	 *
	 * @return string literal to be used in C code
	 */
	public CCodeConstant get_canonical_cconstant () {
		return new CCodeConstant ("\"%s\"".printf (get_canonical_name ()));
	}

	private string get_canonical_name () {
		var str = new StringBuilder ();
		
		string i = name;
		
		while (i.len () > 0) {
			unichar c = i.get_char ();
			if (c == '_') {
				str.append_c ('-');
			} else {
				str.append_unichar (c);
			}
			
			i = i.next_char ();
		}
		
		return str.str;
	}

	void process_ccode_attribute (Attribute a) {
		if (a.has_argument ("notify")) {
			notify = a.get_bool ("notify");
		}
	}

	/**
	 * Process all associated attributes.
	 */
	public void process_attributes () {
		foreach (Attribute a in attributes) {
			if (a.name == "CCode") {
				process_ccode_attribute (a);
			} else if (a.name == "NoAccessorMethod") {
				no_accessor_method = true;
			} else if (a.name == "Description") {
				if (a.has_argument ("nick")) {
					nick = a.get_string ("nick");
				}
				if (a.has_argument ("blurb")) {
					blurb = a.get_string ("blurb");
				}
			}			
		}
	}
	
	public bool get_lock_used () {
		return lock_used;
	}
	
	public void set_lock_used (bool used) {
		lock_used = used;
	}
	
	/**
	 * Checks whether the accessors and type of the specified property
	 * matches this property.
	 *
	 * @param prop a property
	 * @return     true if the specified property is compatible to this
	 *             property
	 */
	public bool equals (Property prop2) {
		if (!prop2.property_type.equals (property_type)) {
			return false;
		}

		if ((get_accessor == null && prop2.get_accessor != null) ||
		    (get_accessor != null && prop2.get_accessor == null)) {
			return false;
		}

		if ((set_accessor == null && prop2.set_accessor != null) ||
		    (set_accessor != null && prop2.set_accessor == null)) {
			return false;
		}

		if (set_accessor != null) {
			if (set_accessor.writable != prop2.set_accessor.writable) {
				return false;
			}
			if (set_accessor.construction != prop2.set_accessor.construction) {
				return false;
			}
		}

		return true;
	}

	public override void replace_type (DataType old_type, DataType new_type) {
		if (property_type == old_type) {
			property_type = new_type;
		}
	}

	private void find_base_properties () {
		if (base_properties_valid) {
			return;
		}

		if (parent_symbol is Class) {
			/* VAPI classes don't specify overridden properties */
			if (!parent_symbol.external_package) {
				find_base_interface_property ((Class) parent_symbol);
				if (is_virtual || overrides) {
					find_base_class_property ((Class) parent_symbol);
				}
			} else if (is_virtual || is_abstract) {
				_base_property = this;
			}
		} else if (parent_symbol is Interface) {
			if (is_virtual || is_abstract) {
				_base_interface_property = this;
			}
		}

		base_properties_valid = true;
	}

	private void find_base_class_property (Class cl) {
		var sym = cl.scope.lookup (name);
		if (sym is Property) {
			var base_property = (Property) sym;
			if (base_property.is_abstract || base_property.is_virtual) {
				if (!equals (base_property)) {
					error = true;
					Report.error (source_reference, "Type and/or accessors of overriding property `%s' do not match overridden property `%s'.".printf (get_full_name (), base_property.get_full_name ()));
					return;
				}

				_base_property = base_property;
				return;
			}
		}

		if (cl.base_class != null) {
			find_base_class_property (cl.base_class);
		}
	}

	private void find_base_interface_property (Class cl) {
		// FIXME report error if multiple possible base properties are found
		foreach (DataType type in cl.get_base_types ()) {
			if (type.data_type is Interface) {
				var sym = type.data_type.scope.lookup (name);
				if (sym is Property) {
					var base_property = (Property) sym;
					if (base_property.is_abstract) {
						if (!equals (base_property)) {
							error = true;
							Report.error (source_reference, "Type and/or accessors of overriding property `%s' do not match overridden property `%s'.".printf (get_full_name (), base_property.get_full_name ()));
							return;
						}

						_base_interface_property = base_property;
						return;
					}
				}
			}
		}
	}
}
