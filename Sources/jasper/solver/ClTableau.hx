/*
 * Copyright (c) 2017 Jeremy Meltingtallow
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of
 * this software and associated documentation files (the "Software"), to deal in
 * the Software without restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the
 * Software, and to permit persons to whom the Software is furnished to do so,
 * subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 * FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 * COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN
 * AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 * THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

// FILE: EDU.Washington.grad.gjb.cassowary
// package EDU.Washington.grad.gjb.cassowary;

package jasper.solver;

import jasper.Hashtable;
import jasper.Stringable;
import jasper.HashSet;
import jasper.variable.ClAbstractVariable;
import jasper.ClLinearExpression;

class ClTableau implements Stringable
{
	public var columns (default, null):Hashtable<ClAbstractVariable, HashSet<ClAbstractVariable>>; //Hashtable of vars -> set of vars
	public var rows (default, null):Hashtable<ClAbstractVariable, ClLinearExpression>; //Hashtable of vars -> expr
	public var infeasibleRows (default, null):HashSet<ClAbstractVariable>; //Set of vars
	public var externalRows (default, null):HashSet<ClAbstractVariable>; //Set of vars
	public var externalParametricVars (default, null):HashSet<ClAbstractVariable>; //Set of vars

	/**
	 *  [Description]
	 */
	public function new() : Void
	{
		this.columns = new Hashtable(); // values are sets
		this.rows = new Hashtable(); // values are ClLinearExpressions
		this.infeasibleRows = new HashSet();
		this.externalRows = new HashSet();
		this.externalParametricVars = new HashSet();
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param subject - 
	 */
	public function noteRemovedVariable(v :ClAbstractVariable, subject :ClAbstractVariable) : Void
	{
		if (subject != null) {
			this.columns.get(v).remove(subject);
		}
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @param subject - 
	 */
	public function noteAddedVariable(v :ClAbstractVariable, subject :ClAbstractVariable) : Void
	{
		if (subject != null) {
			this.insertColVar(v, subject);
		}
	}

	/**
	 *  [Description]
	 *  @return String
	 */
	public function getInternalInfo() : String
	{
		var retstr = "Tableau Information:\n";
		retstr += "Rows: " + this.rows.size();
		retstr += " (= " + (this.rows.size() - 1) + " constraints)";
		retstr += "\nColumns: " + this.columns.size();
		retstr += "\nInfeasible Rows: " + this.infeasibleRows.size();
		retstr += "\nExternal basic variables: " + this.externalRows.size();
		retstr += "\nExternal parametric variables: ";
		retstr += this.externalParametricVars.size();
		retstr += "\n";
		return retstr;
	}

	/**
	 *  [Description]
	 *  @return String
	 */
	public function toString() : String
	{
		var bstr = "Tableau:\n";
		this.rows.each(function(clv, expr) {
			bstr += clv;
			bstr += " <==> ";
			bstr += expr;
			bstr += "\n";
		});
		bstr += "\nColumns:\n";
		bstr += this.columns.toString();
		bstr += "\nInfeasible rows: ";
		bstr += this.infeasibleRows.toString();
		bstr += "External basic variables: ";
		bstr += this.externalRows.toString();
		bstr += "External parametric variables: ";
		bstr += this.externalParametricVars.toString();
		return bstr;
	}

	/**
	 *  [Description]
	 *  @param paramVar - 
	 *  @param rowVar - 
	 */
	public function insertColVar(paramVar :ClAbstractVariable, rowVar :ClAbstractVariable) : Void
	{
		var rowset = this.columns.get(paramVar);
		if (rowset == null) {
			this.columns.put(paramVar, rowset = new HashSet());
		}
		rowset.add(rowVar);
	}

	/**
	 *  [Description]
	 *  @param aVar - 
	 *  @param expr - 
	 */
	public function addRow(aVar :ClAbstractVariable, expr :ClLinearExpression) : Void
	{
		var that=this;
		this.rows.put(aVar, expr);

		expr.terms.each(function(clv, coeff) {
			that.insertColVar(clv, aVar);
			if (clv.isExternal()) {
				that.externalParametricVars.add(clv);
			}
		});

		if (aVar.isExternal()) {
			this.externalRows.add(aVar);
		}
	}

	/**
	 *  [Description]
	 *  @param aVar - 
	 */
	public function removeColumn(aVar :ClAbstractVariable) : Void
	{
		var that=this;

		var rows = this.columns.remove(aVar);
		if (rows != null) {
			rows.each(function(clv) {
				var expr = that.rows.get(clv);
				expr.terms.remove(aVar);
			});
		}

		if (aVar.isExternal()) {
			this.externalRows.remove(aVar);
			this.externalParametricVars.remove(aVar);
		}
	}

	/**
	 *  [Description]
	 *  @param aVar - 
	 *  @return ClLinearExpression
	 */
	public function removeRow(aVar :ClAbstractVariable) : ClLinearExpression 
	{
		var that=this;
		var expr = this.rows.get(aVar);
		Util.Assert(expr != null, "expr is null in removeRow ClTableau.hx");

		expr.terms.each(function(clv, coeff) {
			var varset = that.columns.get(clv);
			if (varset != null) {
				varset.remove(aVar);
			}
		});

		this.infeasibleRows.remove(aVar);
		if (aVar.isExternal()) {
			this.externalRows.remove(aVar);
		}
		this.rows.remove(aVar);

		return expr;
	}

	/**
	 *  [Description]
	 *  @param oldVar - 
	 *  @param expr - 
	 */
	public function substituteOut(oldVar :ClAbstractVariable, expr :ClLinearExpression) : Void
	{
		var that=this;
		var varset = this.columns.get(oldVar);

		varset.each(function(v) {
			var row = that.rows.get(v);
			row.substituteOut(oldVar, expr, v, that);
			if (v.isRestricted() && row.constant < 0.0) {
				that.infeasibleRows.add(v);
			}
		});

		if (oldVar.isExternal()) {
			this.externalRows.add(oldVar);
			this.externalParametricVars.remove(oldVar);
		}
		this.columns.remove(oldVar);
	}

	/**
	 *  [Description]
	 *  @param subject - 
	 *  @return Bool
	 */
	public function columnsHasKey(subject :ClAbstractVariable) : Bool
	{
		return (this.columns.get(subject) != null);
	}

	/**
	 *  [Description]
	 *  @param v - 
	 *  @return ClLinearExpression
	 */
	public function rowExpression(v :ClAbstractVariable) : ClLinearExpression
	{
		return this.rows.get(v);
	}
}

