/* valacodegenerator.vala
 *
 * Copyright (C) 2006  Jürg Billeter
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.

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
 */

using GLib;

namespace Vala {
	public class CodeGenerator : CodeVisitor {
		CCodeFragment header_begin;
		CCodeFragment header_type_declaration;
		CCodeFragment header_type_definition;
		CCodeFragment header_type_member_declaration;
		CCodeFragment source_begin;
		CCodeFragment source_include_directives;
		CCodeFragment source_type_member_declaration;
		CCodeFragment source_type_member_definition;
		
		CCodeStruct instance_struct;
		CCodeStruct class_struct;
		CCodeFunction function;
		CCodeBlock block;
		
		TypeReference reference; // dummy for dependency resolution

		public void emit (CodeContext context) {
			context.accept (this);
		}
	
		public override void visit_begin_source_file (SourceFile source_file) {
			header_begin = new CCodeFragment ();
			header_type_declaration = new CCodeFragment ();
			header_type_definition = new CCodeFragment ();
			header_type_member_declaration = new CCodeFragment ();
			source_begin = new CCodeFragment ();
			source_include_directives = new CCodeFragment ();
			source_type_member_declaration = new CCodeFragment ();
			source_type_member_definition = new CCodeFragment ();
			
			if (source_file.comment != null) {
				header_begin.append (new CCodeComment (text = source_file.comment));
			}
		}
		
		public override void visit_end_source_file (SourceFile source_file) {
			var writer = new CCodeWriter (stream = File.open (source_file.get_cheader_filename (), "w"));
			header_begin.write (writer);
			header_type_declaration.write (writer);
			header_type_definition.write (writer);
			header_type_member_declaration.write (writer);
			writer.close ();
			
			writer = new CCodeWriter (stream = File.open (source_file.get_csource_filename (), "w"));
			source_begin.write (writer);
			source_include_directives.write (writer);
			source_type_member_declaration.write (writer);
			source_type_member_definition.write (writer);
			writer.close ();

			header_begin = null;
			header_type_declaration = null;
			header_type_definition = null;
			header_type_member_declaration = null;
			source_begin = null;
			source_include_directives = null;
			source_type_member_declaration = null;
			source_type_member_definition = null;
		}
		
		public override void visit_begin_class (Class cl) {
			instance_struct = new CCodeStruct (name = "_%s".printf (cl.name));
			class_struct = new CCodeStruct (name = "_%sClass".printf (cl.name));

			if (cl.source_reference.comment != null) {
				header_type_definition.append (new CCodeComment (text = cl.source_reference.comment));
			}
			header_type_definition.append (instance_struct);
			header_type_definition.append (class_struct);
		}
		
		public override void visit_begin_struct (Struct st) {
			instance_struct = new CCodeStruct (name = "_%s".printf (st.name));

			if (st.source_reference.comment != null) {
				header_type_definition.append (new CCodeComment (text = st.source_reference.comment));
			}
			header_type_definition.append (instance_struct);
		}
		
		public override void visit_begin_enum (Enum en) {
			instance_struct = new CCodeEnum (name = "_%s".printf (en.name));

			if (en.source_reference.comment != null) {
				header_type_definition.append (new CCodeComment (text = en.source_reference.comment));
			}
			header_type_definition.append (instance_struct);
		}
		
		public override void visit_field (Field f) {
			instance_struct.add_field (f.type_reference.get_cname (), f.name);
		}
		
		public override void visit_end_method (Method m) {
			var cmethod_decl = new CCodeFunction (name = m.name, return_type = "void");
			function = new CCodeFunction (name = m.name, return_type = "void");
			
			if (m.access == MemberAccessibility.PUBLIC) {
				header_type_member_declaration.append (cmethod_decl);
			} else {
				cmethod_decl.modifiers |= CCodeModifiers.STATIC;
				function.modifiers |= CCodeModifiers.STATIC;
				source_type_member_declaration.append (cmethod_decl);
			}

			if (m.body != null) {
				function.block = m.body.ccodenode;
			}

			if (m.source_reference.comment != null) {
				source_type_member_definition.append (new CCodeComment (text = m.source_reference.comment));
			}
			source_type_member_definition.append (function);
		}
		

		public override void visit_end_block (Block b) {
			var cblock = new CCodeBlock ();
			
			foreach (Statement stmt in b.statement_list) {
				if (stmt.ccodenode is CCodeFragment) {
					foreach (CCodeStatement cstmt in ((CCodeFragment) stmt.ccodenode).children) {
						cblock.add_statement (cstmt);
					}
				} else {
					cblock.add_statement ((CCodeStatement) stmt.ccodenode);
				}
			}
			
			b.ccodenode = cblock;
		}

		public override void visit_empty_statement (EmptyStatement stmt) {
			stmt.ccodenode = new CCodeEmptyStatement ();
		}

		public override void visit_declaration_statement (DeclarationStatement stmt) {
			/* split declaration statement as var declarators might have different types */
		
			var cfrag = new CCodeFragment ();
			
			foreach (VariableDeclarator decl in stmt.declaration.variable_declarators) {
				var cdecl = new CCodeDeclarationStatement (type_name = decl.type_reference.get_cname ());
			
				cdecl.add_declarator ((CCodeVariableDeclarator) decl.ccodenode);

				cfrag.append (cdecl);
			}
			
			stmt.ccodenode = cfrag;
		}

		public override void visit_variable_declarator (VariableDeclarator decl) {
			if (decl.initializer != null) {
				decl.ccodenode = new CCodeVariableDeclarator (name = decl.name, initializer = decl.initializer.ccodenode);
			} else {
				decl.ccodenode = new CCodeVariableDeclarator (name = decl.name);
			}
		}

		public override void visit_expression_statement (ExpressionStatement stmt) {
			stmt.ccodenode = new CCodeExpressionStatement (expression = (CCodeExpression) stmt.expression.ccodenode);
		}

		public override void visit_if_statement (IfStatement stmt) {
			if (stmt.false_statement != null) {
				stmt.ccodenode = new CCodeIfStatement (condition = (CCodeExpression) stmt.condition.ccodenode, true_statement = (CCodeStatement) stmt.true_statement.ccodenode, false_statement = (CCodeStatement) stmt.false_statement.ccodenode);
			} else {
				stmt.ccodenode = new CCodeIfStatement (condition = (CCodeExpression) stmt.condition.ccodenode, true_statement = (CCodeStatement) stmt.true_statement.ccodenode);
			}
		}

		public override void visit_for_statement (ForStatement stmt) {
			var cfor = new CCodeForStatement (condition = (CCodeExpression) stmt.condition.ccodenode, body = (CCodeStatement) stmt.body.ccodenode);
			
			foreach (Expression init_expr in stmt.initializer) {
				cfor.add_initializer ((CCodeExpression) init_expr.ccodenode);
			}
			
			foreach (Expression it_expr in stmt.iterator) {
				cfor.add_iterator ((CCodeExpression) it_expr.ccodenode);
			}
			
			stmt.ccodenode = cfor;
		}

		public override void visit_return_statement (ReturnStatement stmt) {
			if (stmt.return_expression == null) {
				stmt.ccodenode = new CCodeReturnStatement ();
			} else {
				stmt.ccodenode = new CCodeReturnStatement (return_expression = (CCodeExpression) stmt.return_expression.ccodenode);
			}
		}

		public override void visit_boolean_literal (BooleanLiteral expr) {
			if (expr.value) {
				expr.ccodenode = new CCodeConstant (name = "TRUE");
			} else {
				expr.ccodenode = new CCodeConstant (name = "FALSE");
			}
		}

		public override void visit_character_literal (CharacterLiteral expr) {
			expr.ccodenode = new CCodeConstant (name = expr.value);
		}

		public override void visit_integer_literal (IntegerLiteral expr) {
			expr.ccodenode = new CCodeConstant (name = expr.value);
		}

		public override void visit_string_literal (StringLiteral expr) {
			expr.ccodenode = new CCodeConstant (name = expr.value);
		}

		public override void visit_null_literal (NullLiteral expr) {
			expr.ccodenode = new CCodeConstant (name = "NULL");
		}

		public override void visit_literal_expression (LiteralExpression expr) {
			expr.ccodenode = expr.literal.ccodenode;
		}

		public override void visit_simple_name (SimpleName expr) {
			/* local variable */
			expr.ccodenode = new CCodeIdentifier (name = expr.name);
		}

		public override void visit_parenthesized_expression (ParenthesizedExpression expr) {
			expr.ccodenode = new CCodeParenthesizedExpression (inner = (CCodeExpression) expr.inner.ccodenode);
		}

		public override void visit_member_access (MemberAccess expr) {
			expr.ccodenode = new CCodeIdentifier (name = expr.member_name);
		}

		public override void visit_invocation_expression (InvocationExpression expr) {
			var ccall = new CCodeFunctionCall (call = (CCodeExpression) expr.call.ccodenode);
			
			foreach (Expression arg in expr.argument_list) {
				ccall.add_argument ((CCodeExpression) arg.ccodenode);
			}
			
			expr.ccodenode = ccall;
		}

		public override void visit_object_creation_expression (ObjectCreationExpression expr) {
			var ccall = new CCodeFunctionCall (call = new CCodeIdentifier (name = "g_object_new"));
			
			ccall.add_argument (new CCodeConstant (name = expr.type_reference.get_upper_case_cname ("TYPE_")));

			foreach (NamedArgument arg in expr.named_argument_list) {
				ccall.add_argument (new CCodeConstant (name = "\"%s\"".printf (arg.name)));
				ccall.add_argument ((CCodeExpression) arg.argument.ccodenode);
			}
			ccall.add_argument (new CCodeConstant (name = "NULL"));
			
			expr.ccodenode = ccall;
		}

		public override void visit_unary_expression (UnaryExpression expr) {
			expr.ccodenode = expr.inner.ccodenode;
		}

		public override void visit_cast_expression (CastExpression expr) {
			expr.ccodenode = expr.inner.ccodenode;
		}

		public override void visit_binary_expression (BinaryExpression expr) {
			expr.ccodenode = new CCodeBinaryExpression (left = expr.left.ccodenode, right = expr.right.ccodenode);
		}

		public override void visit_assignment (Assignment a) {
			a.ccodenode = new CCodeAssignment (left = (CCodeExpression) a.left.ccodenode, right = (CCodeExpression) a.right.ccodenode);
		}
	}
}
